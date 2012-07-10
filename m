Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab2GJOSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 10:18:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:53990 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806Ab2GJOSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 10:18:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="175540692"
Date: Tue, 10 Jul 2012 22:18:30 +0800
From: wfg@linux.intel.com
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Kernel boot hangs on commit "switch fput to task_work_add"
Message-ID: <20120710141830.GA5385@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Al,

The linux-next kernel reliably hung after this line:

[    4.846260] debug: unmapping init [mem 0xffff88000182a000-0xffff8800019fffff]

And it's bisected to commit:

        commit 4a9ffe81385c2af04f296bea05482f34e02ea10d
        Author: Al Viro <viro@zeniv.linux.org.uk>
        Date:   Sun Jun 24 09:56:45 2012 +0400

            switch fput to task_work_add

            ... and schedule_work() for interrupt/kernel_thread callers
            (and yes, now it *is* OK to call from interrupt).

I tried add this debug aid:

init_post(void):
+       printk(KERN_WARNING "flush_delayed_fput\n");
        flush_delayed_fput();
+       printk(KERN_WARNING "flush_delayed_fput done\n");

And then it hangs after "flush_delayed_fput done". So it's not directly
freezing inside flush_delayed_fput()..

Thanks,
Fengguang

--VS++wcV0S1rZb1Fb
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=dmesg-kvm-fat-1642-2012-07-10-18-18-02
Content-Transfer-Encoding: 8bit

[    0.000000] Linux version 3.5.0-rc6-07761-g46a7146 (wfg@bee) (gcc version 4.7.0 (Debian 4.7.1-1) ) #16 SMP Tue Jul 10 17:17:01 CST 2012
[    0.000000] Command line: rcutorture.rcutorture_runnable=0 trinity=10m tree=mm:akpm auth_hashtable_size=10 sunrpc.auth_hashtable_size=10 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 hung_task_panic=1 softlockup_panic=1 unknown_nmi_panic=1 nmi_watchdog=panic,lapic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2012-07-10-17-17-28-mm-origin.akpm-81aee07-46a7146-x86_64-randconfig-mm5-1-fat BOOT_IMAGE=kernel-tests/kernels/x86_64-randconfig-mm5/46a7146478b4526950011838a0e249ddf594ef7c/vmlinuz-3.5.0-rc6-07761-g46a7146
[    0.000000] Disabled fast string operations
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffcfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffd000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffbc000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
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
[    0.000000] early log buf free: 128644(98%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] kvm-clock: Using msrs 12 and 11
[    0.000000] kvm-clock: cpu 0, msr 0:1c63c41, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00010000-0xffffffff]
[    0.000000]   Normal   empty
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
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfffbbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 471 pages/cpu @ffff88000dc00000 s1907040 r0 d22176 u2097152
[    0.000000] pcpu-alloc: s1907040 r0 d22176 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] kvm-clock: cpu 0, msr 0:ddd0c41, primary cpu clock
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64390
[    0.000000] Kernel command line: rcutorture.rcutorture_runnable=0 trinity=10m tree=mm:akpm auth_hashtable_size=10 sunrpc.auth_hashtable_size=10 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 hung_task_panic=1 softlockup_panic=1 unknown_nmi_panic=1 nmi_watchdog=panic,lapic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2012-07-10-17-17-28-mm-origin.akpm-81aee07-46a7146-x86_64-randconfig-mm5-1-fat BOOT_IMAGE=kernel-tests/kernels/x86_64-randconfig-mm5/46a7146478b4526950011838a0e249ddf594ef7c/vmlinuz-3.5.0-rc6-07761-g46a7146
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Memory: 198572k/262132k available (4655k kernel code, 452k absent, 63108k reserved, 6167k data, 2216k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU debugfs-based tracing is enabled.
[    0.000000] 	RCU lockdep checking is enabled.
[    0.000000] 	Additional per-CPU info printed with stalls.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=2.
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
[    0.000000] tsc: Detected 3200.226 MHz processor
[    0.010000] Calibrating delay loop (skipped) preset value.. 6400.45 BogoMIPS (lpj=32002260)
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
[    0.010000] ENABLING IO-APIC IRQs
[    0.010000] init IO_APIC IRQs
[    0.010000]  apic 2 pin 0 not connected
[    0.010028] IOAPIC[0]: Set routing entry (2-1 -> 0x41 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.011110] IOAPIC[0]: Set routing entry (2-2 -> 0x51 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.012182] IOAPIC[0]: Set routing entry (2-3 -> 0x61 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.013252] IOAPIC[0]: Set routing entry (2-4 -> 0x71 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.014320] IOAPIC[0]: Set routing entry (2-5 -> 0x81 -> IRQ 5 Mode:0 Active:0 Dest:1)
[    0.015401] IOAPIC[0]: Set routing entry (2-6 -> 0x91 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.016475] IOAPIC[0]: Set routing entry (2-7 -> 0xa1 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.017549] IOAPIC[0]: Set routing entry (2-8 -> 0xb1 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.018631] IOAPIC[0]: Set routing entry (2-9 -> 0xc1 -> IRQ 33 Mode:1 Active:0 Dest:1)
[    0.019719] IOAPIC[0]: Set routing entry (2-10 -> 0xd1 -> IRQ 34 Mode:1 Active:0 Dest:1)
[    0.020046] IOAPIC[0]: Set routing entry (2-11 -> 0xe1 -> IRQ 35 Mode:1 Active:0 Dest:1)
[    0.021145] IOAPIC[0]: Set routing entry (2-12 -> 0x22 -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.022246] IOAPIC[0]: Set routing entry (2-13 -> 0x42 -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.023340] IOAPIC[0]: Set routing entry (2-14 -> 0x52 -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.024443] IOAPIC[0]: Set routing entry (2-15 -> 0x62 -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.025531]  apic 2 pin 16 not connected
[    0.026058]  apic 2 pin 17 not connected
[    0.026591]  apic 2 pin 18 not connected
[    0.027117]  apic 2 pin 19 not connected
[    0.027649]  apic 2 pin 20 not connected
[    0.028176]  apic 2 pin 21 not connected
[    0.028707]  apic 2 pin 22 not connected
[    0.030004]  apic 2 pin 23 not connected
[    0.030679] ..TIMER: vector=0x51 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.031739] smpboot: CPU0: Intel Common KVM processor stepping 01
[    0.032904] Using local APIC timer interrupts.
[    0.032904] calibrating APIC timer ...
[    0.040000] ... lapic delta = 6253499
[    0.040000] ..... delta 6253499
[    0.040000] ..... mult: 268585736
[    0.040000] ..... calibration result: 10005598
[    0.040000] ..... CPU clock speed is 3201.9026 MHz.
[    0.040000] ..... host bus clock speed is 1000.5598 MHz.
[    0.040000] ... verify APIC timer
[    0.155231] ... jiffies delta = 10
[    0.155822] ... jiffies result ok
[    0.156464] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.159078] SMP alternatives: lockdep: fixing up alternatives
[    0.160000] smpboot: Booting Node   0, Processors  #1 OK
[    0.010000] kvm-clock: cpu 1, msr 0:dfd0c41, secondary cpu clock
[    0.010000] masked ExtINT on CPU#1
[    0.010000] Disabled fast string operations
[    0.180068] Brought up 2 CPUs
[    0.180461] smpboot: Total of 2 processors activated (12800.90 BogoMIPS)
[    0.181601] device: 'platform': device_add
[    0.182199] bus: 'platform': registered
[    0.182720] bus: 'cpu': registered
[    0.190006] device: 'cpu': device_add
[    0.190966] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.191881] device class 'regulator': registering
[    0.192599] Registering platform device 'reg-dummy'. Parent at platform
[    0.193490] device: 'reg-dummy': device_add
[    0.194056] bus: 'platform': add device reg-dummy
[    0.194718] bus: 'platform': add driver reg-dummy
[    0.195345] bus: 'platform': driver_probe_device: matched device reg-dummy with driver reg-dummy
[    0.196501] bus: 'platform': really_probe: probing driver reg-dummy with device reg-dummy
[    0.197610] device: 'regulator.0': device_add
[    0.198274] dummy: 
[    0.198600] driver: 'reg-dummy': driver_bound: bound to device 'reg-dummy'
[    0.199531] bus: 'platform': really_probe: bound device reg-dummy to driver reg-dummy
[    0.200141] NET: Registered protocol family 16
[    0.200959] device class 'bdi': registering
[    0.201553] device class 'lcd': registering
[    0.202121] device class 'backlight': registering
[    0.202748] device class 'tty': registering
[    0.203329] bus: 'hsi': registered
[    0.203791] bus: 'i2c': registered
[    0.204261] bus: 'i2c': add driver dummy
[    0.204789] i2c-core: driver [dummy] registered
[    0.205742] device class 'dmi': registering
[    0.206329] device: 'id': device_add
[    0.207029] device: 'cpu0': device_add
[    0.207540] bus: 'cpu': add device cpu0
[    0.208209] device: 'cpu1': device_add
[    0.208713] bus: 'cpu': add device cpu1
[    0.210032] device: 'default': device_add
[    0.210980] bio: create slab <bio-0> at 0
[    0.211562] device class 'block': registering
[    0.212338] bus: 'i2c': add driver mcp230xx
[    0.212915] i2c-core: driver [mcp230xx] registered
[    0.213553] bus: 'platform': add driver stmpe-gpio
[    0.214205] bus: 'i2c': add driver sx150x
[    0.214743] i2c-core: driver [sx150x] registered
[    0.215369] bus: 'platform': add driver tps65912-gpio
[    0.216052] bus: 'platform': add driver wm831x-gpio
[    0.216703] bus: 'platform': add driver wm8350-gpio
[    0.217425] device class 'graphics': registering
[    0.218057] bus: 'platform': add driver aat2870-backlight
[    0.218774] bus: 'platform': add driver reg-fixed-voltage
[    0.219565] bus: 'platform': add driver 88pm860x-regulator
[    0.220011] bus: 'platform': add driver aat2870-regulator
[    0.220740] bus: 'i2c': add driver ad5398
[    0.221287] i2c-core: driver [ad5398] registered
[    0.221910] bus: 'i2c': add driver lp3972
[    0.222448] i2c-core: driver [lp3972] registered
[    0.223071] bus: 'i2c': add driver max1586
[    0.223628] i2c-core: driver [max1586] registered
[    0.224254] bus: 'platform': add driver max8925-regulator
[    0.224978] bus: 'platform': add driver mc13892-regulator
[    0.225703] bus: 'platform': add driver palmas-pmic
[    0.226357] bus: 'platform': add driver tps6105x-regulator
[    0.227140] bus: 'i2c': add driver tps62360
[    0.227706] i2c-core: driver [tps62360] registered
[    0.228343] bus: 'i2c': add driver tps65023
[    0.228921] i2c-core: driver [tps65023] registered
[    0.229566] bus: 'platform': add driver tps6507x-pmic
[    0.230010] bus: 'platform': add driver tps65217-pmic
[    0.230693] bus: 'platform': add driver tps65912-pmic
[    0.231373] bus: 'platform': add driver wm831x-buckv
[    0.232036] bus: 'platform': add driver wm831x-buckp
[    0.232704] bus: 'platform': add driver wm831x-boostp
[    0.233386] bus: 'platform': add driver wm831x-epe
[    0.234028] bus: 'platform': add driver wm831x-isink
[    0.234701] bus: 'platform': add driver wm831x-ldo
[    0.235352] bus: 'platform': add driver wm831x-aldo
[    0.236006] bus: 'platform': add driver wm831x-alive-ldo
[    0.236771] bus: 'platform': add driver wm8350-regulator
[    0.237577] bus: 'platform': add driver wm8400-regulator
[    0.238331] device class 'misc': registering
[    0.238912] bus: 'i2c': add driver 88PM860x
[    0.240009] i2c-core: driver [88PM860x] registered
[    0.240644] bus: 'i2c': add driver stmpe-i2c
[    0.241222] i2c-core: driver [stmpe-i2c] registered
[    0.241876] bus: 'i2c': add driver WM8400
[    0.242415] i2c-core: driver [WM8400] registered
[    0.243037] bus: 'i2c': add driver wm831x
[    0.243585] i2c-core: driver [wm831x] registered
[    0.244208] bus: 'i2c': add driver wm8350
[    0.244755] i2c-core: driver [wm8350] registered
[    0.245377] bus: 'i2c': add driver tps6105x
[    0.245952] i2c-core: driver [tps6105x] registered
[    0.246590] bus: 'i2c': add driver tps6507x
[    0.247213] i2c-core: driver [tps6507x] registered
[    0.247864] bus: 'i2c': add driver tps65217
[    0.248432] i2c-core: driver [tps65217] registered
[    0.249086] bus: 'i2c': add driver tps65912
[    0.249649] i2c-core: driver [tps65912] registered
[    0.250006] bus: 'i2c': add driver mc13xxx
[    0.250567] i2c-core: driver [mc13xxx] registered
[    0.251194] bus: 'i2c': add driver da903x
[    0.251747] i2c-core: driver [da903x] registered
[    0.252357] bus: 'i2c': add driver da9052
[    0.252903] i2c-core: driver [da9052] registered
[    0.253524] bus: 'i2c': add driver max8925
[    0.254074] i2c-core: driver [max8925] registered
[    0.254706] bus: 'i2c': add driver max8997
[    0.255257] i2c-core: driver [max8997] registered
[    0.255891] bus: 'i2c': add driver aat2870
[    0.256448] i2c-core: driver [aat2870] registered
[    0.257126] bus: 'i2c': add driver palmas
[    0.257670] i2c-core: driver [palmas] registered
[    0.258287] bus: 'platform': add driver nop_usb_xceiv
[    0.258977] device class 'udc': registering
[    0.259555] bus: 'serio': registered
[    0.260010] bus: 'gameport': registered
[    0.260530] device class 'input': registering
[    0.261114] Linux video capture interface: v2.00
[    0.261733] device class 'video4linux': registering
[    0.262383] device class 'dvb': registering
[    0.262948] device class 'power_supply': registering
[    0.263616] device class 'hwmon': registering
[    0.264198] device class 'leds': registering
[    0.264775] device class 'devfreq': registering
[    0.265386] device class 'net': registering
[    0.265978] device: 'lo': device_add
[    0.290270] Switching to clocksource kvm-clock
[    0.291125] FS-Cache: Loaded
[    0.291537] device: 'cachefiles': device_add
[    0.292158] CacheFiles: Loaded
[    0.292605] device class 'mem': registering
[    0.293181] device: 'mem': device_add
[    0.293695] device: 'null': device_add
[    0.294219] device: 'zero': device_add
[    0.294734] device: 'full': device_add
[    0.295244] device: 'random': device_add
[    0.295785] device: 'urandom': device_add
[    0.296327] device: 'kmsg': device_add
[    0.296842] device: 'oldmem': device_add
[    0.297429] device: 'tty': device_add
[    0.297947] device: 'console': device_add
[    0.298487] device class 'thermal': registering
[    0.299253] NET: Registered protocol family 2
[    0.299900] IP route cache hash table entries: 2048 (order: 2, 16384 bytes)
[    0.299985] TCP established hash table entries: 8192 (order: 5, 131072 bytes)
[    0.301152] TCP bind hash table entries: 8192 (order: 7, 655360 bytes)
[    0.303426] TCP: Hash tables configured (established 8192 bind 8192)
[    0.304337] TCP: reno registered
[    0.304837] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    0.305658] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    0.306690] NET: Registered protocol family 1
[    0.307465] Unpacking initramfs...
[    1.149064] debug: unmapping init [mem 0xffff88000e8d6000-0xffff88000ffeffff]
[    1.163517] DMA-API: preallocated 32768 debug entries
[    1.164204] DMA-API: debugging enabled by kernel config
[    1.165215] Registering platform device 'rtc_cmos'. Parent at platform
[    1.166082] device: 'rtc_cmos': device_add
[    1.166630] bus: 'platform': add device rtc_cmos
[    1.167320] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    1.168730] camellia-x86_64: performance on this CPU would be suboptimal: disabling camellia-x86_64.
[    1.169956] blowfish-x86_64: performance on this CPU would be suboptimal: disabling blowfish-x86_64.
[    1.171304] bus: 'platform': add driver alarmtimer
[    1.171987] Registering platform device 'alarmtimer'. Parent at platform
[    1.172904] device: 'alarmtimer': device_add
[    1.173474] bus: 'platform': add device alarmtimer
[    1.174134] bus: 'platform': driver_probe_device: matched device alarmtimer with driver alarmtimer
[    1.175330] bus: 'platform': really_probe: probing driver alarmtimer with device alarmtimer
[    1.176428] driver: 'alarmtimer': driver_bound: bound to device 'alarmtimer'
[    1.177374] bus: 'platform': really_probe: bound device alarmtimer to driver alarmtimer
[    1.178462] audit: initializing netlink socket (disabled)
[    1.179218] type=2000 audit(1341911876.170:1): initialized
[    1.180189] rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 onoff_interval=0 onoff_holdoff=0
[    1.185254] bus: 'event_source': registered
[    1.185838] device: 'breakpoint': device_add
[    1.186404] bus: 'event_source': add device breakpoint
[    1.187124] device: 'software': device_add
[    1.187675] bus: 'event_source': add device software
[    1.188499] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.189618] VFS: Disk quotas dquot_6.5.2
[    1.190222] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.191256] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    1.192224] jffs2: version 2.2. Â© 2001-2006 Red Hat, Inc.
[    1.193140] ROMFS MTD (C) 2007 Red Hat, Inc.
[    1.193737] QNX4 filesystem 0.2.3 registered.
[    1.194327] QNX6 filesystem 1.0.0 registered.
[    1.194918] device: 'autofs': device_add
[    1.195461] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    1.197202] alg: No test for cipher_null (cipher_null-generic)
[    1.198147] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[    1.199053] alg: No test for digest_null (digest_null-generic)
[    1.199957] alg: No test for compress_null (compress_null-generic)
[    1.207870] alg: No test for stdrng (krng)
[    1.216000] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    1.217047] NET: Registered protocol family 38
[    1.217667] device class 'bsg': registering
[    1.218273] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    1.219259] io scheduler noop registered
[    1.219806] io scheduler cfq registered (default)
[    1.220462] list_sort_test: start testing list_sort()
[    1.222515] crc32: CRC_LE_BITS = 8, CRC_BE BITS = 8
[    1.223172] crc32: self tests passed, processed 225944 bytes in 571024 nsec
[    1.224647] crc32c: CRC_LE_BITS = 8
[    1.225119] crc32c: self tests passed, processed 225944 bytes in 273386 nsec
[    1.226063] bus: 'platform': add driver adp5520-gpio
[    1.226736] bus: 'i2c': add driver adp5588-gpio
[    1.227342] i2c-core: driver [adp5588-gpio] registered
[    1.228130] bus: 'i2c': add driver lp855x
[    1.228671] i2c-core: driver [lp855x] registered
[    1.229293] bus: 'platform': add driver max8925-backlight
[    1.230047] bus: 'platform': add driver adp5520-backlight
[    1.230787] bus: 'i2c': add driver adp8860_bl
[    1.231373] i2c-core: driver [adp8860_bl] using legacy suspend method
[    1.232289] i2c-core: driver [adp8860_bl] using legacy resume method
[    1.233127] i2c-core: driver [adp8860_bl] registered
[    1.233801] bus: 'platform': add driver 88pm860x-backlight
[    1.234534] bus: 'platform': add driver hecubafb
[    1.235160] no IO addresses supplied
[    1.235641] bus: 'platform': add driver broadsheetfb
[    1.236321] bus: 'platform': add driver s1d13xxxfb
[    1.236972] bus: 'platform': add driver sm501-fb
[    1.237590] bus: 'platform': add driver reg-virt-consumer
[    1.238344] bus: 'platform': add driver reg-userspace-consumer
[    1.239164] device: 'ptmx': device_add
[    1.239680] r3964: Philips r3964 Driver $Revision: 1.10 $
[    1.240438] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.241302] Registering platform device 'serial8250'. Parent at platform
[    1.242206] device: 'serial8250': device_add
[    1.242782] bus: 'platform': add device serial8250
ÿ[    1.580477] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.581965] device: 'ttyS0': device_add
[    1.583194] device: 'ttyS1': device_add
[    1.584379] device: 'ttyS2': device_add
[    1.585566] device: 'ttyS3': device_add
[    1.586671] bus: 'platform': add driver serial8250
[    1.587915] bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
[    1.589108] bus: 'platform': really_probe: probing driver serial8250 with device serial8250
[    1.590274] driver: 'serial8250': driver_bound: bound to device 'serial8250'
[    1.591216] bus: 'platform': really_probe: bound device serial8250 to driver serial8250
[    1.592276] bus: 'platform': add driver timb-uart
[    1.592930] bus: 'platform': add driver altera_jtaguart
[    1.593675] bus: 'platform': add driver xuartps
[    1.594326] device: 'ttyprintk': device_add
[    1.594914] device: 'rtc': device_add
[    1.595411] Real Time Clock Driver v1.12b
[    1.595954] device class 'ppdev': registering
[    1.596544] ppdev: user-space parallel port driver
[    1.597213] smapi::smapi_init, ERROR invalid usSmapiID
[    1.597908] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
[    1.599136] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
[    1.600159] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    1.601003] bus: 'platform': add driver ipmi
[    1.601576] ipmi message handler version 39.2
[    1.602164] ipmi device interface
[    1.602608] device class 'ipmi': registering
[    1.603221] bus: 'platform': add driver ipmi_si
[    1.603839] IPMI System Interface driver.
[    1.604389] ipmi_si: Adding default-specified kcs state machine
[    1.605214] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[    1.606538] ipmi_si: Interface detection failed
[    1.630182] ipmi_si: Adding default-specified smic state machine
[    1.631376] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
[    1.634213] ipmi_si: Interface detection failed
[    1.660180] ipmi_si: Adding default-specified bt state machine
[    1.661918] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
[    1.664671] ipmi_si: Interface detection failed
[    1.690223] bus: 'platform': remove driver ipmi_si
[    1.691636] driver: 'ipmi_si': driver_release
[    1.692887] ipmi_si: Unable to find any System Interface(s)
[    1.694463] IPMI Watchdog: driver initialized
[    1.695717] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[    1.697824] device class 'drm': registering
[    1.698388] [drm:drm_core_init] *ERROR* Cannot create /proc/dri
[    1.699186] device class 'drm': unregistering
[    1.699774] class 'drm': release.
[    1.700282] class_create_release called for drm
[    1.700916] bus: 'platform': add driver parport_pc
[    1.701564] Registering platform device 'parport_pc.956'. Parent at platform
[    1.702497] device: 'parport_pc.956': device_add
[    1.703126] bus: 'platform': add device parport_pc.956
[    1.703836] bus: 'platform': driver_probe_device: matched device parport_pc.956 with driver parport_pc
[    1.705070] bus: 'platform': really_probe: probing driver parport_pc with device parport_pc.956
[    1.706212] driver: 'parport_pc.956': driver_bound: bound to device 'parport_pc'
[    1.707199] bus: 'platform': really_probe: bound device parport_pc.956 to driver parport_pc
[    1.708382] bus: 'platform': remove device parport_pc.956
[    1.709137] Registering platform device 'parport_pc.888'. Parent at platform
[    1.710131] device: 'parport_pc.888': device_add
[    1.710761] bus: 'platform': add device parport_pc.888
[    1.711464] bus: 'platform': driver_probe_device: matched device parport_pc.888 with driver parport_pc
[    1.712688] bus: 'platform': really_probe: probing driver parport_pc with device parport_pc.888
[    1.713894] driver: 'parport_pc.888': driver_bound: bound to device 'parport_pc'
[    1.714885] bus: 'platform': really_probe: bound device parport_pc.888 to driver parport_pc
[    1.716053] parport0: PC-style at 0x378 [PCSPP(,...)]
[    1.716865] parport0: irq 0 detected
[    1.717386] device: 'parport0': device_add
[    1.718049] Registering platform device 'parport_pc.632'. Parent at platform
[    1.718997] device: 'parport_pc.632': device_add
[    1.719610] bus: 'platform': add device parport_pc.632
[    1.720387] bus: 'platform': driver_probe_device: matched device parport_pc.632 with driver parport_pc
[    1.721621] bus: 'platform': really_probe: probing driver parport_pc with device parport_pc.632
[    1.722781] driver: 'parport_pc.632': driver_bound: bound to device 'parport_pc'
[    1.723759] bus: 'platform': really_probe: bound device parport_pc.632 to driver parport_pc
[    1.724932] bus: 'platform': remove device parport_pc.632
[    1.725655] device class 'enclosure': registering
[    1.726290] bus: 'i2c': add driver apds9802als
[    1.726908] i2c-core: driver [apds9802als] using legacy suspend method
[    1.727789] i2c-core: driver [apds9802als] using legacy resume method
[    1.728637] i2c-core: driver [apds9802als] registered
[    1.729323] bus: 'i2c': add driver isl29020
[    1.729895] i2c-core: driver [isl29020] registered
[    1.730596] bus: 'i2c': add driver hmc6352
[    1.731167] i2c-core: driver [hmc6352] registered
[    1.731803] bus: 'i2c': add driver fsa9480
[    1.732355] i2c-core: driver [fsa9480] using legacy suspend method
[    1.733186] i2c-core: driver [fsa9480] using legacy resume method
[    1.733995] i2c-core: driver [fsa9480] registered
[    1.734621] bus: 'platform': add driver sm501
[    1.735227] bus: 'i2c': add driver twl6040
[    1.735786] i2c-core: driver [twl6040] registered
[    1.736419] bus: 'i2c': add driver adp5520
[    1.736989] i2c-core: driver [adp5520] registered
[    1.737617] Uniform Multi-Platform E-IDE driver
[    1.738252] bus: 'ide': registered
[    1.738726] device class 'ide_port': registering
[    1.739344] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[    1.740722] Probing IDE interface ide0...
[    2.450175] device: 'ide0': device_add
[    2.450762] device: 'ide0': device_add
[    2.451949] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    2.453299] Probing IDE interface ide1...
[    3.340366] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROM drive
[    4.060214] device: 'ide1': device_add
[    4.061291] device: 'ide1': device_add
[    4.062457] ide1 at 0x170-0x177,0x376 on irq 15
[    4.063986] device: '1.0': device_add
[    4.065054] bus: 'ide': add device 1.0
[    4.066301] ide-cd driver 5.00
[    4.067196] bus: 'ide': add driver ide-cdrom
[    4.068097] bus: 'ide': driver_probe_device: matched device 1.0 with driver ide-cdrom
[    4.069126] bus: 'ide': really_probe: probing driver ide-cdrom with device 1.0
[    4.070183] device: '1.0': device_add
[    4.071024] ide-cd: hdc: ATAPI 4X CD-ROM drive, 512kB Cache
[    4.071809] cdrom: Uniform CD-ROM driver Revision: 3.20
[    4.073337] device: '22:0': device_add
[    4.073887] device: 'hdc': device_add
[    4.074424] driver: '1.0': driver_bound: bound to device 'ide-cdrom'
[    4.075576] bus: 'ide': really_probe: bound device 1.0 to driver ide-cdrom
[    4.076462] device class 'ide_tape': registering
[    4.077081] bus: 'ide': add driver ide-tape
[    4.077643] device class 'mtd': registering
[    4.078205] device: 'mtd-unmap': device_add
[    4.078804] device: 'mtd-romap': device_add
[    4.079418] device: 'mtd-rwmap': device_add
[    4.080216] SSFDC read-only Flash Translation layer
[    4.080923] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    4.081706] bus: 'platform': add driver mtd-ram
[    4.082294] bus: 'platform': add driver docg3
[    4.082882] bus: 'platform': remove driver docg3
[    4.083478] driver: 'docg3': driver_release
[    4.112040] No recognised DiskOnChip devices found
[    4.112677] slram: not enough parameters.
[    4.114532] device: 'mtd0': device_add
[    4.115106] device: 'mtd0ro': device_add
[    4.115919] device: '31:0': device_add
[    4.116392] device: 'mtdblock0': device_add
[    4.160034] onenand_wait: timeout! ctrl=0x0000 intr=0x0000
[    4.160733] OneNAND Manufacturer: Samsung (0xec)
[    4.161350] OneNAND 16MB 1.8V 16-bit (0x04)
[    4.161914] OneNAND version = 0x001e
[    4.162394] Lock scheme is Continuous Lock
[    4.162961] Scanning device for bad blocks
[    4.164279] Creating 1 MTD partitions on "OneNAND simulator":
[    4.165067] 0x000000000000-0x000001000000 : "OneNAND simulator partition"
[    4.166287] device: 'mtd1': device_add
[    4.166830] device: 'mtd1ro': device_add
[    4.167584] device: '31:1': device_add
[    4.168136] device: 'mtdblock1': device_add
[    4.168733] device class 'ubi': registering
[    4.169301] device: 'ubi_ctrl': device_add
[    4.169883] bus: 'hsi': add driver hsi_char
[    4.170480] HSI/SSI char device loaded
[    4.171002] eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
[    4.172196] device: 'eql': device_add
[    4.172820] device: 'ifb0': device_add
[    4.173364] device: 'ifb1': device_add
[    4.174126] bus: 'platform': add driver cfspi_sspi
[    4.174819] plip: parport0 has no IRQ. Using IRQ-less mode,which is fairly inefficient!
[    4.175909] device: 'plip0': device_add
[    4.176466] NET3 PLIP version 2.4-parport gniibe@mri.co.jp
[    4.177213] plip0: Parallel port at 0x378, not using IRQ.
[    4.177947] PPP generic driver version 2.4.2
[    4.178560] device class 'ppp': registering
[    4.179152] device: 'ppp': device_add
[    4.179681] PPP Deflate Compression module registered
[    4.180387] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256).
[    4.181334] CSLIP: code copyright 1989 Regents of the University of California.
[    4.182305] SLIP linefill/keepalive option.
[    4.182882] hdlc: HDLC support module revision 1.22
[    4.183537] device class 'uio': registering
[    4.184139] bus: 'platform': add driver uio_pdrv_genirq
[    4.184866] bus: 'platform': add driver gpio-vbus
[    4.185505] bus: 'platform': remove driver gpio-vbus
[    4.186177] driver: 'gpio-vbus': driver_release
[    4.186854] bus: 'platform': add driver net2272
[    4.187494] bus: 'platform': add driver m66592_udc
[    4.188156] bus: 'platform': remove driver m66592_udc
[    4.188850] driver: 'm66592_udc': driver_release
[    4.189465] bus: 'platform': add driver r8a66597_udc
[    4.190169] bus: 'platform': remove driver r8a66597_udc
[    4.190887] driver: 'r8a66597_udc': driver_release
[    4.191522] bus: 'platform': add driver mv-udc
[    4.192161] Registering platform device 'i8042'. Parent at platform
[    4.193006] device: 'i8042': device_add
[    4.193518] bus: 'platform': add device i8042
[    4.194145] bus: 'platform': add driver i8042
[    4.194749] bus: 'platform': driver_probe_device: matched device i8042 with driver i8042
[    4.195812] bus: 'platform': really_probe: probing driver i8042 with device i8042
[    4.197513] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.198224] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.198923] driver: 'i8042': driver_bound: bound to device 'i8042'
[    4.199783] device: 'serio0': device_add
[    4.200351] bus: 'serio': add device serio0
[    4.200987] device: 'serio1': device_add
[    4.201517] bus: 'serio': add device serio1
[    4.202100] bus: 'platform': really_probe: bound device i8042 to driver i8042
[    4.261647] bus: 'serio': add driver atkbd
[    4.262222] bus: 'i2c': add driver synaptics_i2c
[    4.262872] bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
[    4.263924] bus: 'serio': really_probe: probing driver atkbd with device serio0
[    4.265347] device: 'input0': device_add
[    4.265942] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    4.267130] device: 'event0': device_add
[    4.267739] evbug: Connected device: input0 (AT Translated Set 2 keyboard at isa0060/serio0/input0)
[    4.268939] driver: 'serio0': driver_bound: bound to device 'atkbd'
[    4.269776] bus: 'serio': really_probe: bound device serio0 to driver atkbd
[    4.270746] i2c-core: driver [synaptics_i2c] registered
[    4.271446] bus: 'i2c': add driver smbus_alert
[    4.272051] i2c-core: driver [smbus_alert] registered
[    4.272740] bus: 'platform': add driver simtec-i2c
[    4.273388] i2c-parport-light: adapter type unspecified
[    4.274090] Colour QuickCam for Video4Linux v0.06
[    4.782391] bus: 'i2c': add driver saa7706h
[    4.782981] bus: 'serio': driver_probe_device: matched device serio1 with driver atkbd
[    4.783123] i2c-core: driver [saa7706h] registered
[    4.783126] Driver for 1-wire Dallas network protocol.
[    4.783136] bus: 'w1': registered
[    4.783138] bus: 'w1': add driver w1_master_driver
[    4.783145] bus: 'w1': add driver w1_slave_driver
[    4.783153] bus: 'platform': add driver w1-gpio
[    4.783165] bus: 'platform': remove driver w1-gpio
[    4.783169] driver: 'w1-gpio': driver_release
[    4.783202] bus: 'platform': add driver pda-power
[    4.783210] bus: 'platform': add driver wm831x-power
[    4.783219] device: 'test_ac': device_add
[    4.783248] device: 'test_battery': device_add
[    4.783336] device: 'thermal_zone0': device_add
[    4.783401] device: 'hwmon0': device_add
[    4.783458] device: 'test_usb': device_add
[    4.783482] bus: 'platform': add driver ds2780-battery
[    4.783500] bus: 'platform': add driver ds2781-battery
[    4.783509] bus: 'i2c': add driver sbs-battery
[    4.783513] i2c-core: driver [sbs-battery] using legacy suspend method
[    4.783514] i2c-core: driver [sbs-battery] registered
[    4.783517] bus: 'platform': add driver da903x-battery
[    4.783525] bus: 'i2c': add driver max17042
[    4.783530] i2c-core: driver [max17042] registered
[    4.783532] bus: 'platform': add driver isp1704_charger
[    4.783540] bus: 'platform': add driver max8903-charger
[    4.783548] bus: 'i2c': add driver lp8727
[    4.783556] i2c-core: driver [lp8727] registered
[    4.783560] bus: 'platform': add driver gpio-charger
[    4.783567] bus: 'i2c': add driver smb347
[    4.783572] i2c-core: driver [smb347] registered
[    4.783644] bus: 'i2c': add driver w83781d
[    4.783650] i2c-core: driver [w83781d] registered
[    4.783653] bus: 'i2c': add driver adm1021
[    4.783657] i2c-core: driver [adm1021] registered
[    4.783660] bus: 'i2c': add driver adm1026
[    4.783665] i2c-core: driver [adm1026] registered
[    4.783667] bus: 'i2c': add driver adm1029
[    4.783672] i2c-core: driver [adm1029] registered
[    4.783695] bus: 'i2c': add driver adm1031
[    4.783700] i2c-core: driver [adm1031] registered
[    4.783703] bus: 'i2c': add driver adm9240
[    4.783707] i2c-core: driver [adm9240] registered
[    4.783710] bus: 'i2c': add driver ads1015
[    4.783714] i2c-core: driver [ads1015] registered
[    4.783719] bus: 'i2c': add driver asc7621
[    4.783723] i2c-core: driver [asc7621] registered
[    4.783726] bus: 'i2c': add driver ds1621
[    4.783730] i2c-core: driver [ds1621] registered
[    4.783733] bus: 'i2c': add driver emc2103
[    4.783737] i2c-core: driver [emc2103] registered
[    4.783974] bus: 'i2c': add driver f75375
[    4.783980] i2c-core: driver [f75375] registered
[    4.783983] bus: 'i2c': add driver gl520sm
[    4.783987] i2c-core: driver [gl520sm] registered
[    4.784071] bus: 'i2c': add driver jc42
[    4.784077] i2c-core: driver [jc42] registered
[    4.784079] bus: 'i2c': add driver lm73
[    4.784087] i2c-core: driver [lm73] registered
[    4.784090] bus: 'i2c': add driver lm75
[    4.784095] i2c-core: driver [lm75] registered
[    4.784098] bus: 'i2c': add driver lm77
[    4.784102] i2c-core: driver [lm77] registered
[    4.784104] bus: 'i2c': add driver lm78
[    4.784109] i2c-core: driver [lm78] registered
[    4.784112] bus: 'i2c': add driver lm85
[    4.784116] i2c-core: driver [lm85] registered
[    4.784119] bus: 'i2c': add driver lm90
[    4.784123] i2c-core: driver [lm90] registered
[    4.784126] bus: 'i2c': add driver lm93
[    4.784130] i2c-core: driver [lm93] registered
[    4.784133] bus: 'i2c': add driver lm95241
[    4.784137] i2c-core: driver [lm95241] registered
[    4.784140] bus: 'i2c': add driver ltc4151
[    4.784144] i2c-core: driver [ltc4151] registered
[    4.784147] bus: 'i2c': add driver max16065
[    4.784151] i2c-core: driver [max16065] registered
[    4.784154] bus: 'i2c': add driver max1619
[    4.784158] i2c-core: driver [max1619] registered
[    4.784214] bus: 'i2c': add driver sht21
[    4.784220] i2c-core: driver [sht21] registered
[    4.784222] bus: 'i2c': add driver smsc47m192
[    4.784227] i2c-core: driver [smsc47m192] registered
[    4.784231] bus: 'platform': add driver wm831x-hwmon
[    4.784239] bus: 'platform': add driver wm8350-hwmon
[    4.784256] cpuidle: using governor ladder
[    4.784258] bus: 'platform': add driver 88pm860x-led
[    4.784266] bus: 'platform': add driver leds-gpio
[    4.784279] bus: 'i2c': add driver lp3944
[    4.784283] i2c-core: driver [lp3944] registered
[    4.784286] bus: 'i2c': add driver lp5521
[    4.784290] i2c-core: driver [lp5521] registered
[    4.784293] bus: 'platform': add driver leds-ot200
[    4.784301] bus: 'i2c': add driver leds-pca9633
[    4.784306] i2c-core: driver [leds-pca9633] registered
[    4.784309] bus: 'platform': add driver da903x-led
[    4.784317] bus: 'platform': add driver wm831x-status
[    4.784324] bus: 'platform': add driver leds-lt3593
[    4.784332] bus: 'platform': add driver max8997-led
[    4.784347] bus: 'platform': add driver dcdbas
[    4.784356] Registering platform device 'dcdbas'. Parent at platform
[    4.784357] device: 'dcdbas': device_add
[    4.784358] bus: 'platform': add device dcdbas
[    4.784393] bus: 'platform': driver_probe_device: matched device dcdbas with driver dcdbas
[    4.784395] bus: 'platform': really_probe: probing driver dcdbas with device dcdbas
[    4.784397] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    4.784398] driver: 'dcdbas': driver_bound: bound to device 'dcdbas'
[    4.784401] bus: 'platform': really_probe: bound device dcdbas to driver dcdbas
[    4.784412] bus: 'i2c': add driver cptm1217
[    4.784417] i2c-core: driver [cptm1217] using legacy suspend method
[    4.784418] i2c-core: driver [cptm1217] using legacy resume method
[    4.784419] i2c-core: driver [cptm1217] registered
[    4.784422] bus: 'i2c': add driver synaptics_rmi4_i2c
[    4.784426] i2c-core: driver [synaptics_rmi4_i2c] registered
[    4.854079] bus: 'serio': really_probe: probing driver atkbd with device serio1
[    4.855386] device: 'binder': device_add
[    4.855386] atkbd: probe of serio1 rejects match -19
[    4.856733] device: 'log_main': device_add
[    4.857290] logger: created 256K log 'log_main'
[    4.857987] device: 'log_events': device_add
[    4.858562] logger: created 256K log 'log_events'
[    4.859279] device: 'log_radio': device_add
[    4.859856] logger: created 256K log 'log_radio'
[    4.860574] device: 'log_system': device_add
[    4.861161] logger: created 256K log 'log_system'
[    4.861790] Linux telephony interface: v1.00
[    4.862356] device class 'extcon': registering
[    4.862956] bus: 'platform': add driver extcon-gpio
[    4.863606] bus: 'platform': add driver max8997-muic
[    4.864362] GACT probability on
[    4.864800] Mirror/redirect action on
[    4.865289] Simple TC action Loaded
[    4.865829] TCP: bic registered
[    4.866256] TCP: cubic registered
[    4.866706] Initializing XFRM netlink socket
[    4.867321] NET: Registered protocol family 10
[    4.868230] sit: IPv6 over IPv4 tunneling driver
[    4.868876] device: 'sit0': device_add
[    4.869491] device: 'ip6tnl0': device_add
[    4.870113] l2tp_core: L2TP core driver, V2.0
[    4.870785] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[    4.871822] DECnet: Routing cache hash table of 128 buckets, 10Kbytes
[    4.872663] NET: Registered protocol family 12
[    4.910210] 8021q: 802.1Q VLAN Support v1.8
[    4.911005] lib80211: common routines for IEEE802.11 drivers
[    4.912620] lib80211_crypt: registered algorithm 'NULL'
[    4.914150] lib80211_crypt: registered algorithm 'WEP'
[    4.915609] lib80211_crypt: registered algorithm 'CCMP'
[    4.917104] lib80211_crypt: registered algorithm 'TKIP'
[    4.918196] NET: Registered protocol family 37
[    4.918923] Key type dns_resolver registered
[    4.919667] batman_adv: B.A.T.M.A.N. advanced 2012.3.0 (compatibility version 14) loaded
[    4.921025] 
[    4.921025] printing PIC contents
[    4.921642] ... PIC  IMR: fffb
[    4.922121] ... PIC  IRR: 9013
[    4.922519] ... PIC  ISR: 0000
[    4.923000] ... PIC ELCR: 0c00
[    4.923394] printing local APIC contents on CPU#0/0:
[    4.924075] ... APIC ID:      00000000 (0)
[    4.924635] ... APIC VERSION: 00050014
[    4.925135] ... APIC TASKPRI: 00000000 (00)
[    4.925702] ... APIC PROCPRI: 00000000
[    4.926205] ... APIC LDR: 01000000
[    4.926678] ... APIC DFR: ffffffff
[    4.927135] ... APIC SPIV: 000001ff
[    4.927617] ... APIC ISR field:
[    4.928039] 0000000000000000000000000000000000000000000000000000000000000000
[    4.929138] ... APIC TMR field:
[    4.929560] 0000000000000000000000000000000000000000000000000000000000000000
[    4.930029] ... APIC IRR field:
[    4.930029] 0000000000000000000000000000000000000000000000000000000000008000
[    4.930029] ... APIC ESR: 00000000
[    4.930029] ... APIC ICR: 000008fd
[    4.930029] ... APIC ICR2: 02000000
[    4.930029] ... APIC LVTT: 000000ef
[    4.930029] ... APIC LVTPC: 00010000
[    4.930029] ... APIC LVT0: 00010700
[    4.930029] ... APIC LVT1: 00000400
[    4.930029] ... APIC LVTERR: 000000fe
[    4.930029] ... APIC TMICT: 00098294
[    4.930029] ... APIC TMCCT: 00000000
[    4.930029] ... APIC TDCR: 00000003
[    4.930029] 
[    4.937789] number of MP IRQ sources: 20.
[    4.938328] number of IO-APIC #2 registers: 24.
[    4.938962] testing the IO APIC.......................
[    4.939681] IO APIC #2......
[    4.940089] .... register #00: 00000000
[    4.940586] .......    : physical APIC id: 00
[    4.941247] .......    : Delivery Type: 0
[    4.941874] .......    : LTS          : 0
[    4.942385] .... register #01: 00170011
[    4.942956] .......     : max redirection entries: 17
[    4.943595] .......     : PRQ implemented: 0
[    4.944141] .......     : IO APIC version: 11
[    4.944778] .... register #02: 00000000
[    4.945270] .......     : arbitration: 00
[    4.945787] .... IRQ redirection table:
[    4.946277]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    4.947067]  00 00  1    0    0   0   0    0    0    00
[    4.947768]  01 01  0    0    0   0   0    1    1    41
[    4.948459]  02 03  0    0    0   0   0    1    1    51
[    4.949235]  03 01  1    0    0   0   0    1    1    61
[    4.949931]  04 01  1    0    0   0   0    1    1    71
[    4.950651]  05 01  1    0    0   0   0    1    1    81
[    4.951423]  06 01  1    0    0   0   0    1    1    91
[    4.952119]  07 01  1    0    0   0   0    1    1    A1
[    4.952897]  08 01  1    0    0   0   0    1    1    B1
[    4.953587]  09 03  1    1    0   0   0    1    1    C1
[    4.954283]  0a 03  1    1    0   0   0    1    1    D1
[    4.955056]  0b 03  1    1    0   0   0    1    1    E1
[    4.955751]  0c 03  0    0    0   0   0    1    1    22
[    4.956439]  0d 01  1    0    0   0   0    1    1    42
[    4.957211]  0e 01  0    0    0   0   0    1    1    52
[    4.957916]  0f 01  0    0    0   0   0    1    1    62
[    4.958608]  10 00  1    0    0   0   0    0    0    00
[    4.959384]  11 00  1    0    0   0   0    0    0    00
[    4.960097]  12 00  1    0    0   0   0    0    0    00
[    4.960879]  13 00  1    0    0   0   0    0    0    00
[    4.961569]  14 00  1    0    0   0   0    0    0    00
[    4.962272]  15 00  1    0    0   0   0    0    0    00
[    4.963037]  16 00  1    0    0   0   0    0    0    00
[    4.963730]  17 00  1    0    0   0   0    0    0    00
[    4.964408] IRQ to pin mappings:
[    4.964907] IRQ0 -> 0:2
[    4.965262] IRQ1 -> 0:1
[    4.965616] IRQ3 -> 0:3
[    4.965976] IRQ4 -> 0:4
[    4.966329] IRQ5 -> 0:5
[    4.966761] IRQ6 -> 0:6
[    4.967118] IRQ7 -> 0:7
[    4.967472] IRQ8 -> 0:8
[    4.967852] IRQ12 -> 0:12
[    4.968227] IRQ13 -> 0:13
[    4.968602] IRQ14 -> 0:14
[    4.969059] IRQ15 -> 0:15
[    4.969476] IRQ33 -> 0:9
[    4.969955] IRQ34 -> 0:10
[    4.970364] IRQ35 -> 0:11
[    4.970820] .................................... done.
[    4.971481] device: 'cpu_dma_latency': device_add
[    4.972098] device: 'network_latency': device_add
[    4.972785] device: 'network_throughput': device_add
[    4.973431] registered taskstats version 1
[    4.974873] console [netcon0] enabled
[    4.975377] netconsole: network logging started
[    4.975958] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    4.976788] EDD information not available.
[    4.978303] debug: unmapping init [mem 0xffffffff81a93000-0xffffffff81cbcfff]
[    4.979454] Write protecting the kernel read-only data: 10240k
[    4.980532] debug: unmapping init [mem 0xffff88000148d000-0xffff8800015fffff]
[    4.981707] debug: unmapping init [mem 0xffff88000182a000-0xffff8800019fffff]
Kernel freezed on [    4.981707] debug: unmapping init [mem 0xffff88000182a000-0xffff8800019fffff]

--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.5.0-rc6-07761-g46a7146"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.5.0-rc6 Kernel Configuration
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
# CONFIG_GENERIC_ISA_DMA is not set
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
# CONFIG_ARCH_MAY_HAVE_PC_FDC is not set
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
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
# CONFIG_EXPERIMENTAL is not set
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
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
CONFIG_KERNEL_LZO=y
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_FHANDLE is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
# CONFIG_TASK_IO_ACCOUNTING is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
# CONFIG_AUDIT_LOGINUID_IMMUTABLE is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_TREE_RCU_TRACE=y
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_MM_OWNER is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
# CONFIG_EVENTFD is not set
# CONFIG_SHMEM is not set
# CONFIG_AIO is not set
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
# CONFIG_VM_EVENT_COUNTERS is not set
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
# CONFIG_GCOV_PROFILE_ALL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
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
# CONFIG_FREEZER is not set

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
# CONFIG_KVMTOOL_TEST_ENABLE is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
# CONFIG_SCHED_MC is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_I8K=y
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
# CONFIG_DIRECT_GBPAGES is not set
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
# CONFIG_SPARSEMEM_VMEMMAP is not set
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_COMPACTION is not set
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_CLEANCACHE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_SFI=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

#
# Memory power savings
#

#
# Bus options (PCI etc.)
#
# CONFIG_PCI is not set
# CONFIG_ARCH_SUPPORTS_MSI is not set
CONFIG_PCI_LABEL=y
# CONFIG_ISA_DMA_API is not set
# CONFIG_PCCARD is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
# CONFIG_IA32_EMULATION is not set
# CONFIG_COMPAT_FOR_U64_ALIGNMENT is not set
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_IPCOMP=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_ROUTE_CLASSID=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_INET_UDP_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_CUBIC=y
# CONFIG_TCP_CONG_WESTWOOD is not set
# CONFIG_TCP_CONG_HTCP is not set
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_IPV6=y
CONFIG_IPV6_PRIVACY=y
# CONFIG_IPV6_ROUTER_PREF is not set
CONFIG_INET6_AH=y
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
CONFIG_INET6_TUNNEL=y
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
# CONFIG_INET6_XFRM_MODE_BEET is not set
CONFIG_IPV6_SIT=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
CONFIG_L2TP=y
# CONFIG_L2TP_DEBUGFS is not set
CONFIG_STP=y
CONFIG_GARP=y
# CONFIG_BRIDGE is not set
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_DECNET=y
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
CONFIG_PHONET=y
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
CONFIG_NET_SCH_HTB=y
# CONFIG_NET_SCH_HFSC is not set
CONFIG_NET_SCH_PRIO=y
CONFIG_NET_SCH_MULTIQ=y
CONFIG_NET_SCH_RED=y
# CONFIG_NET_SCH_SFB is not set
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=y
# CONFIG_NET_SCH_NETEM is not set
CONFIG_NET_SCH_DRR=y
CONFIG_NET_SCH_MQPRIO=y
CONFIG_NET_SCH_CHOKE=y
# CONFIG_NET_SCH_QFQ is not set
# CONFIG_NET_SCH_CODEL is not set
# CONFIG_NET_SCH_FQ_CODEL is not set
# CONFIG_NET_SCH_INGRESS is not set
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_TCINDEX is not set
CONFIG_NET_CLS_ROUTE4=y
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
CONFIG_NET_CLS_RSVP6=y
# CONFIG_NET_CLS_FLOW is not set
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
CONFIG_NET_ACT_GACT=y
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=y
# CONFIG_NET_ACT_NAT is not set
CONFIG_NET_ACT_PEDIT=y
CONFIG_NET_ACT_SIMP=y
# CONFIG_NET_ACT_SKBEDIT is not set
# CONFIG_NET_ACT_CSUM is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_BLA is not set
CONFIG_BATMAN_ADV_DEBUG=y
# CONFIG_OPENVSWITCH is not set

#
# Network testing
#
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
# CONFIG_CFG80211 is not set
CONFIG_LIB80211=y
CONFIG_LIB80211_CRYPT_WEP=y
CONFIG_LIB80211_CRYPT_CCMP=y
CONFIG_LIB80211_CRYPT_TKIP=y
CONFIG_LIB80211_DEBUG=y

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_RFKILL_REGULATOR is not set
# CONFIG_NET_9P is not set
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
CONFIG_CAIF_NETDEV=y
# CONFIG_CAIF_USB is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
# CONFIG_FW_LOADER is not set
CONFIG_DEBUG_DRIVER=y
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_CHAR=y
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
# CONFIG_FTL is not set
CONFIG_NFTL=y
CONFIG_NFTL_RW=y
# CONFIG_INFTL is not set
# CONFIG_RFD_FTL is not set
CONFIG_SSFDC=y
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
CONFIG_MTD_CFI_ADV_OPTIONS=y
# CONFIG_MTD_CFI_NOSWAP is not set
CONFIG_MTD_CFI_BE_BYTE_SWAP=y
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
CONFIG_MTD_CFI_GEOMETRY=y
# CONFIG_MTD_MAP_BANK_WIDTH_1 is not set
CONFIG_MTD_MAP_BANK_WIDTH_2=y
# CONFIG_MTD_MAP_BANK_WIDTH_4 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
CONFIG_MTD_MAP_BANK_WIDTH_32=y
# CONFIG_MTD_CFI_I1 is not set
# CONFIG_MTD_CFI_I2 is not set
CONFIG_MTD_CFI_I4=y
# CONFIG_MTD_CFI_I8 is not set
# CONFIG_MTD_OTP is not set
CONFIG_MTD_CFI_INTELEXT=y
# CONFIG_MTD_CFI_AMDSTD is not set
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_PHYSMAP is not set
# CONFIG_MTD_TS5500 is not set
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=y
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
CONFIG_MTD_PLATRAM=y

#
# Self-contained MTD device drivers
#
CONFIG_MTD_SLRAM=y
# CONFIG_MTD_PHRAM is not set
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOC2000=y
# CONFIG_MTD_DOC2001 is not set
# CONFIG_MTD_DOC2001PLUS is not set
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_DOCPROBE=y
CONFIG_MTD_DOCECC=y
CONFIG_MTD_DOCPROBE_ADVANCED=y
CONFIG_MTD_DOCPROBE_ADDRESS=0x0
# CONFIG_MTD_DOCPROBE_HIGH is not set
# CONFIG_MTD_DOCPROBE_55AA is not set
CONFIG_MTD_NAND_ECC=y
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=y
CONFIG_MTD_NAND_VERIFY_WRITE=y
CONFIG_MTD_NAND_BCH=y
CONFIG_MTD_NAND_ECC_BCH=y
# CONFIG_MTD_SM_COMMON is not set
# CONFIG_MTD_NAND_MUSEUM_IDS is not set
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_NANDSIM is not set
# CONFIG_MTD_NAND_PLATFORM is not set
CONFIG_MTD_ONENAND=y
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
# CONFIG_MTD_ONENAND_GENERIC is not set
# CONFIG_MTD_ONENAND_OTP is not set
CONFIG_MTD_ONENAND_2X_PROGRAM=y
CONFIG_MTD_ONENAND_SIM=y

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_RESERVE=1
# CONFIG_MTD_UBI_GLUEBI is not set
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
# CONFIG_PARPORT_1284 is not set
CONFIG_BLK_DEV=y
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_APDS9802ALS=y
CONFIG_ISL29020=y
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=y
CONFIG_VMWARE_BALLOON=y
CONFIG_USB_SWITCH_FSA9480=y

#
# EEPROM support
#
CONFIG_EEPROM_93CX6=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_IDE_GD is not set
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_IDE_TASK_IOCTL is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEDMA is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
# CONFIG_SCSI is not set
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
# CONFIG_DUMMY is not set
CONFIG_EQUALIZER=y
CONFIG_MII=y
CONFIG_IFB=y
CONFIG_NETCONSOLE=y
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_TUN is not set
# CONFIG_VETH is not set

#
# CAIF transport drivers
#
CONFIG_CAIF_TTY=y
CONFIG_CAIF_SPI_SLAVE=y
CONFIG_CAIF_SPI_SYNC=y
CONFIG_CAIF_HSI=y
# CONFIG_ETHERNET is not set
# CONFIG_PHYLIB is not set
CONFIG_PLIP=y
CONFIG_PPP=y
# CONFIG_PPP_BSDCOMP is not set
CONFIG_PPP_DEFLATE=y
# CONFIG_PPP_FILTER is not set
# CONFIG_PPP_ASYNC is not set
# CONFIG_PPP_SYNC_TTY is not set
CONFIG_SLIP=y
CONFIG_SLHC=y
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLIP_SMART=y
# CONFIG_SLIP_MODE_SLIP6 is not set
CONFIG_WLAN=y
CONFIG_HOSTAP=y
CONFIG_HOSTAP_FIRMWARE=y
CONFIG_HOSTAP_FIRMWARE_NVRAM=y
CONFIG_WL_TI=y

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
CONFIG_WAN=y
CONFIG_HDLC=y
CONFIG_HDLC_RAW=y
CONFIG_HDLC_RAW_ETH=y
# CONFIG_HDLC_CISCO is not set
CONFIG_HDLC_FR=y
CONFIG_HDLC_PPP=y

#
# X.25/LAPB support is disabled
#
# CONFIG_DLCI is not set
CONFIG_SBNI=y
# CONFIG_SBNI_MULTILINE is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
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
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=y
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y

#
# Character devices
#
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_N_HDLC is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set
CONFIG_STALDRV=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_TIMBERDALE=y
CONFIG_SERIAL_ALTERA_JTAGUART=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_XILINX_PS_UART=y
CONFIG_SERIAL_XILINX_PS_UART_CONSOLE=y
CONFIG_TTY_PRINTK=y
# CONFIG_PRINTER is not set
CONFIG_PPDEV=y
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
CONFIG_RTC=y
CONFIG_R3964=y
CONFIG_MWAVE=y
# CONFIG_RAW_DRIVER is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=y

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_DEBUG_CORE=y
# CONFIG_I2C_DEBUG_ALGO is not set
CONFIG_I2C_DEBUG_BUS=y
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
# CONFIG_DEBUG_GPIO is not set

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_IT8761E=y

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
CONFIG_GPIO_SX150X=y
CONFIG_GPIO_STMPE=y
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_WM831X=y
CONFIG_GPIO_WM8350=y
CONFIG_GPIO_ADP5520=y
CONFIG_GPIO_ADP5588=y
# CONFIG_GPIO_ADP5588_IRQ is not set

#
# PCI GPIO expanders:
#

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
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
# CONFIG_W1_SLAVE_DS2433 is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
# CONFIG_MAX8925_POWER is not set
# CONFIG_WM831X_BACKUP is not set
CONFIG_WM831X_POWER=y
# CONFIG_WM8350_POWER is not set
CONFIG_TEST_POWER=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_SBS=y
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_DA9030=y
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_ISP1704=y
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_SMB347=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ADM1021=y
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=y
# CONFIG_SENSORS_DA9052_ADC is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_GPIO_FAN is not set
# CONFIG_SENSORS_IBMAEM is not set
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=y
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=y
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=y
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VT1211 is not set
CONFIG_SENSORS_W83781D=y
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_WM8350=y
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_SENSORS_MC13783_ADC is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
# CONFIG_MFD_LM3533 is not set
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
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
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_S5M_CORE is not set
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_AAT2870_CORE=y
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_PALMAS=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_DUMMY=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_AAT2870=y
# CONFIG_REGULATOR_DA903X is not set
# CONFIG_REGULATOR_DA9052 is not set
CONFIG_REGULATOR_MC13XXX_CORE=y
# CONFIG_REGULATOR_MC13783 is not set
CONFIG_REGULATOR_MC13892=y
# CONFIG_REGULATOR_ISL6271A is not set
CONFIG_REGULATOR_88PM8607=y
CONFIG_REGULATOR_MAX1586=y
# CONFIG_REGULATOR_MAX8649 is not set
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8925=y
# CONFIG_REGULATOR_MAX8952 is not set
# CONFIG_REGULATOR_MAX8997 is not set
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=y
# CONFIG_REGULATOR_LP872X is not set
CONFIG_REGULATOR_PALMAS=y
CONFIG_REGULATOR_TPS6105X=y
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65217=y
CONFIG_REGULATOR_TPS65912=y
CONFIG_REGULATOR_WM831X=y
CONFIG_REGULATOR_WM8350=y
CONFIG_REGULATOR_WM8400=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_COMMON=y
CONFIG_DVB_CORE=y
CONFIG_DVB_NET=y
CONFIG_VIDEO_MEDIA=y

#
# Multimedia drivers
#
# CONFIG_RC_CORE is not set
CONFIG_MEDIA_TUNER=y
CONFIG_MEDIA_TUNER_CUSTOMISE=y

#
# Customize TV tuners
#
# CONFIG_MEDIA_TUNER_SIMPLE is not set
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
# CONFIG_MEDIA_TUNER_MT2060 is not set
CONFIG_MEDIA_TUNER_MT2063=y
CONFIG_MEDIA_TUNER_MT2266=y
# CONFIG_MEDIA_TUNER_MT2131 is not set
CONFIG_MEDIA_TUNER_QT1010=y
# CONFIG_MEDIA_TUNER_XC2028 is not set
# CONFIG_MEDIA_TUNER_XC5000 is not set
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MXL5005S=y
# CONFIG_MEDIA_TUNER_MXL5007T is not set
CONFIG_MEDIA_TUNER_MC44S803=y
CONFIG_MEDIA_TUNER_MAX2165=y
CONFIG_MEDIA_TUNER_TDA18218=y
CONFIG_MEDIA_TUNER_FC0011=y
# CONFIG_MEDIA_TUNER_FC0012 is not set
CONFIG_MEDIA_TUNER_FC0013=y
# CONFIG_MEDIA_TUNER_TDA18212 is not set
CONFIG_MEDIA_TUNER_TUA9001=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y

#
# Audio decoders, processors and mixers
#

#
# RDS decoders
#

#
# Video decoders
#

#
# Video and audio decoders
#

#
# MPEG video encoders
#

#
# Video encoders
#

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#

#
# Miscelaneous helper chips
#
CONFIG_V4L_ISA_PARPORT_DRIVERS=y
# CONFIG_VIDEO_BWQCAM is not set
CONFIG_VIDEO_CQCAM=y
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_SI470X is not set
# CONFIG_I2C_SI4713 is not set
# CONFIG_RADIO_SI4713 is not set
# CONFIG_RADIO_TEA5764 is not set
CONFIG_RADIO_SAA7706H=y
# CONFIG_RADIO_TEF6862 is not set
# CONFIG_RADIO_WL1273 is not set

#
# Texas Instruments WL128x FM driver (ST based)
#
CONFIG_DVB_MAX_ADAPTERS=8
# CONFIG_DVB_DYNAMIC_MINORS is not set
# CONFIG_DVB_CAPTURE_DRIVERS is not set

#
# Graphics support
#
CONFIG_DRM=y
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
# CONFIG_FB_BIG_ENDIAN is not set
CONFIG_FB_LITTLE_ENDIAN=y
CONFIG_FB_SYS_FOPS=y
# CONFIG_FB_WMT_GE_ROPS is not set
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
CONFIG_FB_ARC=y
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
# CONFIG_FB_HGA is not set
CONFIG_FB_S1D13XXX=y
# CONFIG_FB_TMIO is not set
CONFIG_FB_SM501=y
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
CONFIG_FB_BROADSHEET=y
# CONFIG_FB_AUO_K190X is not set
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_DA903X is not set
# CONFIG_BACKLIGHT_DA9052 is not set
CONFIG_BACKLIGHT_MAX8925=y
CONFIG_BACKLIGHT_SAHARA=y
# CONFIG_BACKLIGHT_WM831X is not set
CONFIG_BACKLIGHT_ADP5520=y
CONFIG_BACKLIGHT_ADP8860=y
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_88PM860X=y
CONFIG_BACKLIGHT_AAT2870=y
CONFIG_BACKLIGHT_LP855X=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
# CONFIG_SOUND is not set

#
# HID support
#
# CONFIG_HID is not set
# CONFIG_USB_ARCH_HAS_OHCI is not set
# CONFIG_USB_ARCH_HAS_EHCI is not set
# CONFIG_USB_ARCH_HAS_XHCI is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
# CONFIG_USB_ARCH_HAS_HCD is not set
CONFIG_USB_OTG_WHITELIST=y
# CONFIG_USB_OTG_BLACKLIST_HUB is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# USB Physical Layer drivers
#
# CONFIG_USB_ISP1301 is not set
CONFIG_USB_GADGET=y
# CONFIG_USB_GADGET_DEBUG is not set
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_R8A66597=y
CONFIG_USB_MV_UDC=y
CONFIG_USB_M66592=y
CONFIG_USB_NET2272=y
CONFIG_USB_NET2272_DMA=y
CONFIG_USB_GADGET_DUALSPEED=y
# CONFIG_USB_ZERO is not set
CONFIG_USB_ETH=y
# CONFIG_USB_ETH_RNDIS is not set
CONFIG_USB_ETH_EEM=y
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_FILE_STORAGE is not set
# CONFIG_USB_MASS_STORAGE is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_NOKIA is not set
# CONFIG_USB_G_ACM_MS is not set
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
# CONFIG_USB_G_WEBCAM is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_USB_GPIO_VBUS=y
CONFIG_NOP_USB_XCEIV=y
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP5521=y
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA9633=y
CONFIG_LEDS_WM831X_STATUS=y
# CONFIG_LEDS_WM8350 is not set
CONFIG_LEDS_DA903X=y
# CONFIG_LEDS_DA9052 is not set
# CONFIG_LEDS_REGULATOR is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_LT3593=y
# CONFIG_LEDS_ADP5520 is not set
# CONFIG_LEDS_MC13783 is not set
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_MAX8997=y
# CONFIG_LEDS_LM3556 is not set
CONFIG_LEDS_OT200=y
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_ACCESSIBILITY=y
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_PDRV is not set
CONFIG_UIO_PDRV_GENIRQ=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_BALLOON is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_STAGING=y
# CONFIG_ECHO is not set
# CONFIG_PANEL is not set
# CONFIG_ZCACHE is not set
CONFIG_ZSMALLOC=y
# CONFIG_FB_SM7XX is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=y
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=y
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
CONFIG_ANDROID_LOGGER=y
# CONFIG_ANDROID_TIMED_OUTPUT is not set
# CONFIG_ANDROID_LOW_MEMORY_KILLER is not set
CONFIG_PHONE=y
# CONFIG_IPACK_BUS is not set
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_IOMMU_SUPPORT is not set

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
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
CONFIG_DEVFREQ_GOV_POWERSAVE=y
# CONFIG_DEVFREQ_GOV_USERSPACE is not set

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=y
CONFIG_EXTCON_MAX8997=y
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_PWM is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
CONFIG_DMIID=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
# CONFIG_GOOGLE_MEMCONSOLE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
# CONFIG_EXT4_USE_FOR_EXT23 is not set
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
# CONFIG_GFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_DEBUG=y
CONFIG_CACHEFILES=y
CONFIG_CACHEFILES_DEBUG=y

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
# CONFIG_SYSFS is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_HFSPLUS_FS is not set
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
# CONFIG_JFFS2_FS_WRITEBUFFER is not set
# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
CONFIG_UBIFS_FS=y
# CONFIG_UBIFS_FS_ADVANCED_COMPR is not set
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
# CONFIG_CRAMFS is not set
CONFIG_SQUASHFS=y
# CONFIG_SQUASHFS_XATTR is not set
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZO is not set
# CONFIG_SQUASHFS_XZ is not set
CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
CONFIG_SQUASHFS_EMBEDDED=y
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
CONFIG_HPFS_FS=y
CONFIG_QNX4FS_FS=y
CONFIG_QNX6FS_FS=y
# CONFIG_QNX6FS_DEBUG is not set
CONFIG_ROMFS_FS=y
# CONFIG_ROMFS_BACKED_BY_BLOCK is not set
# CONFIG_ROMFS_BACKED_BY_MTD is not set
CONFIG_ROMFS_BACKED_BY_BOTH=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_ROMFS_ON_MTD=y
# CONFIG_PSTORE is not set
CONFIG_SYSV_FS=y
# CONFIG_UFS_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
# CONFIG_NLS_MAC_CROATIAN is not set
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
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_LIST is not set
CONFIG_TEST_LIST_SORT=y
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_RCU_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST_RUNNABLE is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_LKDTM is not set
CONFIG_CPU_NOTIFIER_ERROR_INJECT=y
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
CONFIG_FAIL_MAKE_REQUEST=y
CONFIG_FAIL_IO_TIMEOUT=y
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_BUILD_DOCSRC is not set
CONFIG_DYNAMIC_DEBUG=y
CONFIG_DMA_API_DEBUG=y
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
CONFIG_IO_DELAY_UDELAY=y
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=2
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
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
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CTR is not set
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
# CONFIG_CRYPTO_SHA256 is not set
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
# CONFIG_BINARY_PRINTF is not set

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
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=y
CONFIG_DDR=y

--VS++wcV0S1rZb1Fb--
