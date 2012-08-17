Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab2HQFpF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 01:45:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:17649 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742Ab2HQFox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 01:44:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,783,1336374000"; 
   d="scan'208";a="203320889"
Date: Fri, 17 Aug 2012 13:44:41 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.de>,
        =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "Lan, Tianyu" <tianyu.lan@intel.com>
Subject: Re: BUG: unable to handle kernel paging request in usb_match_id()
Message-ID: <20120817054441.GA28434@localhost>
References: <20120805025938.GA8954@localhost>
 <20120805165826.GB13913@kroah.com>
 <20120817020046.GA24406@localhost>
 <20120817034825.GC7770@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <20120817034825.GC7770@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 16, 2012 at 08:48:25PM -0700, Greg KH wrote:
> On Fri, Aug 17, 2012 at 10:00:46AM +0800, Fengguang Wu wrote:
> > On Sun, Aug 05, 2012 at 09:58:26AM -0700, Greg KH wrote:
> > > On Sun, Aug 05, 2012 at 10:59:38AM +0800, Fengguang Wu wrote:
> > > > Hi all,
> > > > 
> > > > This line triggers an oops in kvm boot test:
> > > > 
> > > > usb_match_id():
> > > > ==>      748         for (; id->idVendor || id->idProduct || id->bDeviceClass ||
> > > >          749                id->bInterfaceClass || id->driver_info; id++) {
> > > >          750                 if (usb_match_one_id(interface, id))
> > > >          751                         return id;
> > > >          752         }
> > > > 
> > > > It's an old bug and happens also in linux 3.0. It's very reproducible
> > > > for the attached config. I can send the initrd (yocto-minimal-i386.cgz)
> > > > on your request in private email.
> > > 
> > > Odds are a driver without a terminating NULL for the device id list is
> > > causing this to fail.
> > > 
> > > What devices are in the system and what drivers are trying to be bound?
> > 
> > The last match is for: drivers/usb/misc/emi62.c
> > 
> > Located down by Tianyu's debug patch:
> > 
> > [    2.206708] usb_device_match: device 1-1:1.0, driver cytherm
> > [    2.207627] usb_device_match: device 1-1:1.0, driver emi62 - firmware loader
> > [    2.208769] BUG: unable to handle kernel paging request at c1f7478e
> > [    2.209726] IP: [<c14ac1c0>] usb_match_id+0x5b/0xcd
> > 
> > > --- a/drivers/usb/core/driver.c
> > > +++ b/drivers/usb/core/driver.c
> > > @@ -778,7 +778,8 @@ static int usb_device_match(struct device *dev, struct device_driver *drv)
> > >
> > >                 intf = to_usb_interface(dev);
> > >                 usb_drv = to_usb_driver(drv);
> > > -
> > > +
> > > +               pr_info("%s: device %s, driver %s \n", dev_name(dev), drv->name);
> > >                 id = usb_match_id(intf, usb_drv->id_table);
> > >                 if (id)
> > >                         return 1;
> 
> Odd that it takes so long after you call that function for it to fail.
> 
> And that driver has a proper termination, so we aren't walking off the
> end of the list, so it must be in the probe function itself.
> 
> Care to add some more debugging for that driver?
> 
> Also, I don't see the dev_info() message from the driver itself, in the
> probe function, so it must not be getting called properly.
> 
> Something weird is happening...

Very true. I find it related to timing: after adding these debug
printks, it becomes very hard to reproduce. And I confirmed that
emi62_probe() is never called.

Anyway, I managed to get one oops. For comparison, one non-failing
dmesg for the same kernel is also attached.

--- tip.orig/drivers/usb/core/driver.c	2012-08-16 09:27:20.063315545 +0800
+++ tip/drivers/usb/core/driver.c	2012-08-17 12:27:32.441761637 +0800
@@ -747,6 +747,7 @@ const struct usb_device_id *usb_match_id
 	   device and interface. */
 	for (; id->idVendor || id->idProduct || id->bDeviceClass ||
 	       id->bInterfaceClass || id->driver_info; id++) {
+		printk(KERN_ERR "usb_match_id: id=%p idVendor=%#x idProduct=%#x\n", id, id->idVendor, id->idProduct);
 		if (usb_match_one_id(interface, id))
 			return id;
 	}
@@ -779,6 +780,7 @@ static int usb_device_match(struct devic
 		intf = to_usb_interface(dev);
 		usb_drv = to_usb_driver(drv);
 
+               pr_info("%s: device %s, driver %s \n", __func__, dev_name(dev), drv->name);
 		id = usb_match_id(intf, usb_drv->id_table);
 		if (id)
 			return 1;
--- tip.orig/drivers/usb/misc/emi62.c	2012-07-29 18:22:35.256996861 +0800
+++ tip/drivers/usb/misc/emi62.c	2012-08-17 12:46:49.761743138 +0800
@@ -242,9 +242,9 @@ MODULE_DEVICE_TABLE (usb, id_table);
 static int emi62_probe(struct usb_interface *intf, const struct usb_device_id *id)
 {
 	struct usb_device *dev = interface_to_usbdev(intf);
-	dev_dbg(&intf->dev, "emi62_probe\n");
+	dev_err(&intf->dev, "emi62_probe\n");
 
-	dev_info(&intf->dev, "%s start\n", __func__);
+	printk(KERN_ERR "%s start\n", __func__);
 
 	emi62_load_firmware(dev);
 
Thanks,
Fengguang

--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm_bisect2-waimea-15754-2012-08-17-13-14-46-3.6.0-rc1-bisect2-dirty-4"

[    0.000000] Linux version 3.6.0-rc1-bisect2-dirty (wfg@bee) (gcc version 4.7.1 (Debian 4.7.1-5) ) #4 SMP Fri Aug 17 12:47:16 CST 2012
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x100000
[    0.000000] initial memory mapped: [mem 0x00000000-0x027fffff]
[    0.000000] Base memory trampoline at [c008f000] 8f000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffdfff]
[    0.000000]  [mem 0x00000000-0x0fffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffdfff @ [mem 0x027bd000-0x027fffff]
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 129348(98%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 0fffff40 00040
[    0.000000] ACPI: SSDT 0ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 0ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:1fa9601, boot clock
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00010000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65409
[    0.000000] free_area_init_node: node 0, pgdat c1e60bc0, node_mem_map cdcbf280
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
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 9 pages/cpu @cdcad000 s23872 r0 d12992 u36864
[    0.000000] pcpu-alloc: s23872 r0 d12992 u36864 alloc=9*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] kvm-clock: cpu 0, msr 0:dcb2601, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr dcaf6c0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64769
[    0.000000] Kernel command line: trinity=2m hung_task_panic=1 bisect-reboot i386-randconfig-b065 branch=signal/execve2 dyndbg="+p" log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw BOOT_IMAGE=i386/vmlinuz-bisect2
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 204784k/262136k available (10149k kernel code, 56852k reserved, 4584k data, 1296k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffe6e000 - 0xfffff000   (1604 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xff7fe000   ( 752 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc1e66000 - 0xc1faa000   (1296 kB)
[    0.000000]       .data : 0xc19e9727 - 0xc1e63740   (4584 kB)
[    0.000000]       .text : 0xc1000000 - 0xc19e9727   (10149 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=128, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Additional per-CPU info printed with stalls.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=2.
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=cfff6000 soft=cd400000
[    0.000000] console [ttyS0] enabled
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 3300.196 MHz processor
[    0.001999] Calibrating delay loop (skipped) preset value.. 6600.39 BogoMIPS (lpj=3300196)
[    0.002032] pid_max: default: 32768 minimum: 301
[    0.002592] Security Framework initialized
[    0.003025] AppArmor: AppArmor initialized
[    0.003497] Mount-cache hash table entries: 512
[    0.004187] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.004187] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.004187] tlb_flushall_shift is 0x6
[    0.007038] debug: unmapping init [mem 0xc1faa000-0xc1facfff]
[    0.008044] ACPI: Core revision 20120711
[    0.012081] Getting VERSION: 50014
[    0.012514] Getting VERSION: 50014
[    0.012891] Getting ID: 0
[    0.013011] Getting ID: f000000
[    0.013371] Getting LVT0: 8700
[    0.014006] Getting LVT1: 8400
[    0.014392] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.015047] enabled ExtINT on CPU#0
[    0.016236] ENABLING IO-APIC IRQs
[    0.016616] init IO_APIC IRQs
[    0.016971]  apic 2 pin 0 not connected
[    0.017009] IOAPIC[0]: Set routing entry (2-1 -> 0x41 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.018017] IOAPIC[0]: Set routing entry (2-2 -> 0x51 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.019013] IOAPIC[0]: Set routing entry (2-3 -> 0x61 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.020019] IOAPIC[0]: Set routing entry (2-4 -> 0x71 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.021012] IOAPIC[0]: Set routing entry (2-5 -> 0x81 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.022012] IOAPIC[0]: Set routing entry (2-6 -> 0x91 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.023012] IOAPIC[0]: Set routing entry (2-7 -> 0xa1 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.024011] IOAPIC[0]: Set routing entry (2-8 -> 0xb1 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.025020] IOAPIC[0]: Set routing entry (2-9 -> 0xc1 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.026021] IOAPIC[0]: Set routing entry (2-10 -> 0xd1 -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.027013] IOAPIC[0]: Set routing entry (2-11 -> 0xe1 -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.028010] IOAPIC[0]: Set routing entry (2-12 -> 0x22 -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.029011] IOAPIC[0]: Set routing entry (2-13 -> 0x42 -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.029917] IOAPIC[0]: Set routing entry (2-14 -> 0x52 -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.030010] IOAPIC[0]: Set routing entry (2-15 -> 0x62 -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.031008]  apic 2 pin 16 not connected
[    0.031999]  apic 2 pin 17 not connected
[    0.032429]  apic 2 pin 18 not connected
[    0.032998]  apic 2 pin 19 not connected
[    0.033425]  apic 2 pin 20 not connected
[    0.033998]  apic 2 pin 21 not connected
[    0.034432]  apic 2 pin 22 not connected
[    0.034998]  apic 2 pin 23 not connected
[    0.035592] ..TIMER: vector=0x51 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.035998] smpboot: CPU0: Intel Common KVM processor stepping 01
[    0.037289] Using local APIC timer interrupts.
[    0.037289] calibrating APIC timer ...
[    0.038994] ... lapic delta = 6437061
[    0.038994] ... PM-Timer delta = 368697
[    0.038994] APIC calibration not consistent with PM-Timer: 103ms instead of 100ms
[    0.038994] APIC delta adjusted to PM-Timer: 6249499 (6437061)
[    0.038994] TSC delta adjusted to PM-Timer: 330029621 (339934548)
[    0.038994] ..... delta 6249499
[    0.038994] ..... mult: 268454743
[    0.038994] ..... calibration result: 999919
[    0.038994] ..... CPU clock speed is 3300.0296 MHz.
[    0.038994] ..... host bus clock speed is 999.0919 MHz.
[    0.040051] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.042259] CPU 1 irqstacks, hard=cd464000 soft=cd466000
[    0.042997] smpboot: Booting Node   0, Processors  #1 OK
[    0.001999] Initializing CPU#1
[    0.001999] kvm-clock: cpu 1, msr 0:dcbb601, secondary cpu clock
[    0.001999] masked ExtINT on CPU#1
[    0.056991] TSC synchronization [CPU#0 -> CPU#1]:
[    0.056991] Measured 2860 cycles TSC warp between CPUs, turning off TSC clock.
[    0.056991] tsc: Marking TSC unstable due to check_tsc_sync_source failed
[    0.058104] Brought up 2 CPUs
[    0.058100] KVM setup async PF for cpu 1
[    0.058100] kvm-stealtime: cpu 1, msr dcb86c0
[    0.058997] smpboot: Total of 2 processors activated (13200.78 BogoMIPS)
[    0.061943] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.062057] NET: Registered protocol family 16
[    0.064050] EISA bus registered
[    0.065114] ACPI: bus type pci registered
[    0.065581] dca service started, version 1.12.1
[    0.066162] PCI: PCI BIOS revision 2.10 entry at 0xfc78c, last bus=0
[    0.066993] PCI: Using configuration type 1 for base access
[    0.071621] ACPI: Added _OSI(Module Device)
[    0.071994] ACPI: Added _OSI(Processor Device)
[    0.072495] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.072993] ACPI: Added _OSI(Processor Aggregator Device)
[    0.074515] ACPI: EC: Look up EC in DSDT
[    0.078609] ACPI: Interpreter enabled
[    0.078990] ACPI: (supports S0 S5)
[    0.079463] ACPI: Using IOAPIC for interrupt routing
[    0.084414] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.085020] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.086028] pci_root PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.087031] PCI host bridge to bus 0000:00
[    0.087994] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under domain [bus 00-ff]
[    0.088990] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.089657] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.089991] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.090989] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.091767] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebfffff]
[    0.091990] pci_bus 0000:00: scanning bus
[    0.093051] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.093700] pci 0000:00:00.0: calling quirk_mmio_always_on+0x0/0x17
[    0.094258] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.095380] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.098018] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    0.099388] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.100000] pci 0000:00:01.3: calling acpi_pm_check_blacklist+0x0/0x6a
[    0.101298] pci 0000:00:01.3: calling quirk_piix4_acpi+0x0/0x200
[    0.101956] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.101997] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.103026] pci 0000:00:01.3: calling pci_fixup_piix4_acpi+0x0/0x1d
[    0.104089] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.106124] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.109073] pci 0000:00:02.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    0.114766] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.116058] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.117304] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    0.118347] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.123029] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    0.124464] pci 0000:00:04.0: [8086:2668] type 00 class 0x040300
[    0.125267] pci 0000:00:04.0: reg 10: [mem 0xfebf0000-0xfebf3fff]
[    0.129721] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.131028] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[    0.133016] pci 0000:00:05.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    0.138363] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.139425] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[    0.141373] pci 0000:00:06.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    0.146257] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.147351] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.148500] pci 0000:00:07.0: reg 14: [mem 0xfebf7000-0xfebf7fff]
[    0.152482] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.154004] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[    0.155360] pci 0000:00:08.0: reg 14: [mem 0xfebf8000-0xfebf8fff]
[    0.161103] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.162372] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[    0.163503] pci 0000:00:09.0: reg 14: [mem 0xfebf9000-0xfebf9fff]
[    0.167485] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    0.168294] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[    0.169494] pci 0000:00:0a.0: reg 14: [mem 0xfebfa000-0xfebfafff]
[    0.174298] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    0.175217] pci 0000:00:0b.0: reg 10: [mem 0xfebfb000-0xfebfb00f]
[    0.179642] pci_bus 0000:00: fixups for bus
[    0.179982] pci_bus 0000:00: bus scan returning with max=00
[    0.180981] pci_bus 0000:00: on NUMA node 0
[    0.181485] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.183356]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x1e)
[    0.198320] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.199418] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.200339] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.201247] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.202108] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    0.203165] ACPI: bus type usb registered
[    0.203658] usbcore: registered new interface driver usbfs
[    0.203983] usbcore: registered new interface driver hub
[    0.205098] usbcore: registered new device driver usb
[    0.205714] Linux video capture interface: v2.00
[    0.206111] Advanced Linux Sound Architecture Driver Version 1.0.25.
[    0.206988] PCI: Using ACPI for IRQ routing
[    0.207446] PCI: pci_cache_line_size set to 64 bytes
[    0.208026] pci 0000:00:01.1: BAR 0: reserving [io  0x01f0-0x01f7 flags 0x110] (d=0, p=0)
[    0.209987] pci 0000:00:01.1: BAR 1: reserving [io  0x03f6 flags 0x110] (d=0, p=0)
[    0.210976] pci 0000:00:01.1: BAR 2: reserving [io  0x0170-0x0177 flags 0x110] (d=0, p=0)
[    0.211975] pci 0000:00:01.1: BAR 3: reserving [io  0x0376 flags 0x110] (d=0, p=0)
[    0.212975] pci 0000:00:01.1: BAR 4: reserving [io  0xc1c0-0xc1cf flags 0x40101] (d=0, p=0)
[    0.215005] pci 0000:00:02.0: BAR 0: reserving [mem 0xfc000000-0xfdffffff flags 0x42208] (d=0, p=0)
[    0.215975] pci 0000:00:02.0: BAR 1: reserving [mem 0xfebf4000-0xfebf4fff flags 0x40200] (d=0, p=0)
[    0.217984] pci 0000:00:03.0: BAR 0: reserving [mem 0xfeba0000-0xfebbffff flags 0x40200] (d=0, p=0)
[    0.218972] pci 0000:00:03.0: BAR 1: reserving [io  0xc000-0xc03f flags 0x40101] (d=0, p=0)
[    0.219982] pci 0000:00:04.0: BAR 0: reserving [mem 0xfebf0000-0xfebf3fff flags 0x40200] (d=0, p=0)
[    0.220980] pci 0000:00:05.0: BAR 0: reserving [io  0xc040-0xc07f flags 0x40101] (d=0, p=0)
[    0.221970] pci 0000:00:05.0: BAR 1: reserving [mem 0xfebf5000-0xfebf5fff flags 0x40200] (d=0, p=0)
[    0.222984] pci 0000:00:06.0: BAR 0: reserving [io  0xc080-0xc0bf flags 0x40101] (d=0, p=0)
[    0.223971] pci 0000:00:06.0: BAR 1: reserving [mem 0xfebf6000-0xfebf6fff flags 0x40200] (d=0, p=0)
[    0.224980] pci 0000:00:07.0: BAR 0: reserving [io  0xc0c0-0xc0ff flags 0x40101] (d=0, p=0)
[    0.225969] pci 0000:00:07.0: BAR 1: reserving [mem 0xfebf7000-0xfebf7fff flags 0x40200] (d=0, p=0)
[    0.226990] pci 0000:00:08.0: BAR 0: reserving [io  0xc100-0xc13f flags 0x40101] (d=0, p=0)
[    0.228972] pci 0000:00:08.0: BAR 1: reserving [mem 0xfebf8000-0xfebf8fff flags 0x40200] (d=0, p=0)
[    0.229990] pci 0000:00:09.0: BAR 0: reserving [io  0xc140-0xc17f flags 0x40101] (d=0, p=0)
[    0.231972] pci 0000:00:09.0: BAR 1: reserving [mem 0xfebf9000-0xfebf9fff flags 0x40200] (d=0, p=0)
[    0.232990] pci 0000:00:0a.0: BAR 0: reserving [io  0xc180-0xc1bf flags 0x40101] (d=0, p=0)
[    0.234972] pci 0000:00:0a.0: BAR 1: reserving [mem 0xfebfa000-0xfebfafff flags 0x40200] (d=0, p=0)
[    0.235989] pci 0000:00:0b.0: BAR 0: reserving [mem 0xfebfb000-0xfebfb00f flags 0x40200] (d=0, p=0)
[    0.238158] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    0.238973] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.243124] NET: Registered protocol family 23
[    0.243879] Bluetooth: Core ver 2.16
[    0.243997] NET: Registered protocol family 31
[    0.244966] Bluetooth: HCI device and connection manager initialized
[    0.245648] Bluetooth: HCI socket layer initialized
[    0.245972] Bluetooth: L2CAP socket layer initialized
[    0.246978] Bluetooth: SCO socket layer initialized
[    0.248521] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.248990] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.249583] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.255299] Switching to clocksource kvm-clock
[    0.256236] AppArmor: AppArmor Filesystem Enabled
[    0.257052] pnp: PnP ACPI init
[    0.257589] ACPI: bus type pnp registered
[    0.258372] pnp 00:00: [bus 00-ff]
[    0.258989] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.259681] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.260513] pnp 00:00: [io  0x0d00-0xffff window]
[    0.261337] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.262259] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    0.263217] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.264371] pnp 00:01: [io  0x0070-0x0071]
[    0.265131] pnp 00:01: [irq 8]
[    0.265642] pnp 00:01: [io  0x0072-0x0077]
[    0.266385] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.267605] pnp 00:02: [io  0x0060]
[    0.268240] pnp 00:02: [io  0x0064]
[    0.268842] pnp 00:02: [irq 1]
[    0.269444] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.270664] pnp 00:03: [irq 12]
[    0.271270] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.272437] pnp 00:04: [io  0x03f2-0x03f5]
[    0.273164] pnp 00:04: [io  0x03f7]
[    0.273751] pnp 00:04: [irq 6]
[    0.274314] pnp 00:04: [dma 2]
[    0.274881] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.276202] pnp 00:05: [io  0x0378-0x037f]
[    0.276919] pnp 00:05: [irq 7]
[    0.277469] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.278735] pnp 00:06: [io  0x03f8-0x03ff]
[    0.279471] pnp 00:06: [irq 4]
[    0.280084] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.281652] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    0.282538] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.283669] pnp: PnP ACPI: found 8 devices
[    0.284153] ACPI: ACPI bus type pnp unregistered
[    0.319641] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.320582] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.321505] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.322539] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[    0.323608] NET: Registered protocol family 1
[    0.324370] pci 0000:00:00.0: calling quirk_natoma+0x0/0x4f
[    0.325141] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.325790] pci 0000:00:00.0: calling quirk_passive_release+0x0/0xcb
[    0.326680] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.327541] pci 0000:00:01.0: calling quirk_isa_dma_hangs+0x0/0x52
[    0.328238] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.329003] pci 0000:00:02.0: calling pci_fixup_video+0x0/0xf4
[    0.329676] pci 0000:00:02.0: Boot video device
[    0.330235] pci 0000:00:03.0: calling quirk_e100_interrupt+0x0/0x23a
[    0.331033] PCI: CLS 0 bytes, default 64
[    0.331577] Unpacking initramfs...
[    1.137328] debug: unmapping init [mem 0xce73f000-0xcffeffff]
[    1.139208] kvm: no hardware support
[    1.141237] The force parameter has not been set to 1 so the Iris poweroff handler will not be installed.
[    1.142983] NatSemi SCx200 Driver
[    1.143772] audit: initializing netlink socket (disabled)
[    1.144736] type=2000 audit(1345180482.143:1): initialized
[    1.147174] fuse init (API version 7.19)
[    1.147816] msgmni has been set to 399
[    1.151462] NET: Registered protocol family 38
[    1.152487] progear_bl: ALI M7101 PMU not found.
[    1.153300] i2c-core: driver [adp8870_bl] using legacy suspend method
[    1.154076] i2c-core: driver [adp8870_bl] using legacy resume method
[    1.154818] rivafb_setup START
[    1.155270] usbcore: registered new interface driver udlfb
[    1.155957] usbcore: registered new interface driver smscufx
[    1.156679] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    1.157556] ACPI: Power Button [PWRF]
[    1.158118] pci_bus 0000:00: dev 01, created physical slot 1
[    1.158771] pci_bus 0000:00: dev 02, created physical slot 2
[    1.159574] pci_bus 0000:00: dev 03, created physical slot 3
[    1.160240] pci_bus 0000:00: dev 04, created physical slot 4
[    1.160873] pci_bus 0000:00: dev 05, created physical slot 5
[    1.161529] pci_bus 0000:00: dev 06, created physical slot 6
[    1.162193] pci_bus 0000:00: dev 07, created physical slot 7
[    1.162868] pci_bus 0000:00: dev 08, created physical slot 8
[    1.163527] pci_bus 0000:00: dev 09, created physical slot 9
[    1.164208] pci_bus 0000:00: dev 0a, created physical slot 10
[    1.164854] pci_bus 0000:00: dev 0b, created physical slot 11
[    1.165520] pci_bus 0000:00: dev 0c, created physical slot 12
[    1.166197] pci_bus 0000:00: dev 0d, created physical slot 13
[    1.166918] pci_bus 0000:00: dev 0e, created physical slot 14
[    1.167588] pci_bus 0000:00: dev 0f, created physical slot 15
[    1.168407] pci_bus 0000:00: dev 10, created physical slot 16
[    1.169088] pci_bus 0000:00: dev 11, created physical slot 17
[    1.169723] pci_bus 0000:00: dev 12, created physical slot 18
[    1.170379] pci_bus 0000:00: dev 13, created physical slot 19
[    1.171098] pci_bus 0000:00: dev 14, created physical slot 20
[    1.171739] pci_bus 0000:00: dev 15, created physical slot 21
[    1.172391] pci_bus 0000:00: dev 16, created physical slot 22
[    1.173065] pci_bus 0000:00: dev 17, created physical slot 23
[    1.173712] pci_bus 0000:00: dev 18, created physical slot 24
[    1.174371] pci_bus 0000:00: dev 19, created physical slot 25
[    1.175066] pci_bus 0000:00: dev 1a, created physical slot 26
[    1.175839] pci_bus 0000:00: dev 1b, created physical slot 27
[    1.176494] pci_bus 0000:00: dev 1c, created physical slot 28
[    1.177160] pci_bus 0000:00: dev 1d, created physical slot 29
[    1.177798] pci_bus 0000:00: dev 1e, created physical slot 30
[    1.178453] pci_bus 0000:00: dev 1f, created physical slot 31
[    1.179374] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    1.186040] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.209867] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.214802] DoubleTalk PC - not found
[    1.215338] Non-volatile memory driver v1.3
[    1.215872] scx200_gpio: no SCx200 gpio present
[    1.216406] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initializing
[    1.217213] platform pc8736x_gpio.0: no device found
[    1.217758] nsc_gpio initializing
[    1.218240] smapi::smapi_init, ERROR invalid usSmapiID
[    1.218905] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
[    1.219910] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
[    1.220683] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    1.221389] Linux agpgart interface v0.103
[    1.221932] ipmi message handler version 39.2
[    1.222417] IPMI Watchdog: driver initialized
[    1.222957] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    1.223935] Hangcheck: Using getrawmonotonic().
[    1.224542] i2c-core: driver [apds9802als] using legacy suspend method
[    1.225396] i2c-core: driver [apds9802als] using legacy resume method
[    1.226123] i2c-core: driver [tsl2550] using legacy suspend method
[    1.226838] i2c-core: driver [tsl2550] using legacy resume method
[    1.227570] Driver for timberdale has been successfully registered.
[    1.228388] mtdoops: mtd device (mtddev=name/number) must be supplied
[    1.229111] NetSc520 flash device: 0x100000 at 0x200000
[    1.229673] Failed to ioremap_nocache
[    1.230101] scx200_docflash: NatSemi SCx200 DOCCS Flash Driver
[    1.256835] No recognised DiskOnChip devices found
[    1.257382] slram: not enough parameters.
[    1.257827] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    1.258693] pmc551: not detected
[    1.259120] usbcore: registered new interface driver alauda
[    1.293691] onenand_wait: timeout! ctrl=0x0000 intr=0x0000
[    1.294340] OneNAND Manufacturer: Samsung (0xec)
[    1.294882] OneNAND 16MB 1.8V 16-bit (0x04)
[    1.295359] OneNAND version = 0x001e
[    1.295753] Lock scheme is Continuous Lock
[    1.296229] Scanning device for bad blocks
[    1.296868] Creating 1 MTD partitions on "OneNAND simulator":
[    1.297511] 0x000000000000-0x000001000000 : "OneNAND simulator partition"
[    1.298570] HSI/SSI char device loaded
[    1.299270] libphy: Fixed MDIO Bus: probed
[    1.299769] arcnet loaded.
[    1.300092] arcnet: raw mode (`r') encapsulation support loaded.
[    1.300742] arcnet: cap mode (`c') encapsulation support loaded.
[    1.301407] vcan: Virtual CAN interface driver
[    1.301913] slcan: serial line CAN interface driver
[    1.302439] slcan: 10 dynamic interface channels.
[    1.303037] mkiss: AX.25 Multikiss, Hans Albas PE1AYX
[    1.303583] AX.25: bpqether driver version 004
[    1.304091] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    1.304091] baycom_ser_hdx: version 0.10
[    1.305593] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[    1.306242] hdlcdrv: version 0.8
[    1.306942] airo(): Probing for PCI adapters
[    1.307413] airo(): Finished probing for PCI adapters
[    1.307996] usbcore: registered new interface driver kaweth
[    1.308599] pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
[    1.309423] usbcore: registered new interface driver pegasus
[    1.310059] hso: /c/wfg/tip/drivers/net/usb/hso.c: Option Wireless
[    1.310774] usbcore: registered new interface driver hso
[    1.311386] usbcore: registered new interface driver asix
[    1.311999] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[    1.312954] usbcore: registered new interface driver kalmia
[    1.313553] usbcore: registered new interface driver cx82310_eth
[    1.314222] usbcore: registered new interface driver cdc_ncm
[    1.314907] usbcore: registered new interface driver qmi_wwan
[    1.315733] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.316480] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.317185] driver u132_hcd
[    1.317603] usbcore: registered new interface driver usblp
[    1.318234] usbcore: registered new interface driver cdc_wdm
[    1.318915] usbcore: registered new interface driver usbtmc
[    1.319642] usbcore: registered new interface driver mdc800
[    1.320307] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Digital Camera
[    1.321156] usbcore: registered new interface driver cypress_cy7c63
[    1.321839] usbcore: registered new interface driver cytherm
[    1.322488] usbcore: registered new interface driver emi62 - firmware loader
[    1.323329] driver ftdi-elan
[    1.323906] usbcore: registered new interface driver ftdi-elan
[    1.324549] usbcore: registered new interface driver idmouse
[    1.325188] usbcore: registered new interface driver usbled
[    1.325829] usbcore: registered new interface driver legousbtower
[    1.326618] usbcore: registered new interface driver trancevibrator
[    1.327365] usbcore: registered new interface driver usbsevseg
[    1.328022] usbcore: registered new interface driver yurex
[    1.328688] dummy_hcd dummy_hcd: USB Host+Gadget Emulator, driver 02 May 2005
[    1.329496] dummy_hcd dummy_hcd: Dummy host controller
[    1.330080] dummy_hcd dummy_hcd: new USB bus registered, assigned bus number 1
[    1.331028] usb_device_match: device 1-0:1.0, driver usbfs 
[    1.331633] usb_device_match: device 1-0:1.0, driver hub 
[    1.332240] usb_match_id: id=c1a87214 idVendor=0x0 idProduct=0x0
[    1.332935] usb_match_id: id=c1a87214 idVendor=0x0 idProduct=0x0
[    1.333608] hub 1-0:1.0: USB hub found
[    1.334154] hub 1-0:1.0: 1 port detected
[    1.334794] udc dummy_udc: registering UDC driver [g_ether]
[    1.335448]  gadget: using random self ethernet address
[    1.336068]  gadget: using random host ethernet address
[    1.336731] usb0: MAC be:d8:e5:ad:06:09
[    1.337178] usb0: HOST MAC 32:01:96:68:2a:1b
[    1.337654]  gadget: adding config #2 'RNDIS'/c1d3d8b0
[    1.338246]  gadget: adding 'rndis'/c7891480 to config 'RNDIS'/c1d3d8b0
[    1.339051] rndis_register: configNr = 0
[    1.339480] rndis_set_param_medium: 0 0
[    1.339921]  gadget: RNDIS: super speed IN/ep-a OUT/ep-b NOTIFY/ep-c
[    1.340603]  gadget: cfg 2/c1d3d8b0 speeds: super high full
[    1.341352]  gadget:   interface 0 = rndis/c7891480
[    1.341899]  gadget:   interface 1 = rndis/c7891480
[    1.342445]  gadget: adding config #1 'CDC Ethernet (ECM)'/c1d3d840
[    1.343145]  gadget: adding 'cdc_ethernet'/c7891600 to config 'CDC Ethernet (ECM)'/c1d3d840
[    1.344058]  gadget: CDC Ethernet: super speed IN/ep-a OUT/ep-b NOTIFY/ep-c
[    1.344814]  gadget: cfg 1/c1d3d840 speeds: super high full
[    1.345433]  gadget:   interface 0 = cdc_ethernet/c7891600
[    1.346067]  gadget:   interface 1 = cdc_ethernet/c7891600
[    1.346664]  gadget: Ethernet Gadget, version: Memorial Day 2008
[    1.347342]  gadget: g_ether ready
[    1.347721] dummy_udc dummy_udc: binding gadget driver 'g_ether'
[    1.348380] dummy_udc dummy_udc: This device can perform faster if you connect it to a super-speed port...
[    1.349457] dummy_hcd dummy_hcd: port status 0x00010101 has changes
[    1.350208] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    1.351761] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.352340] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.353182] usb_device_match: device 1-0:1.0, driver xpad 
[    1.353798] usb_match_id: id=c1d454c4 idVendor=0x0 idProduct=0x0
[    1.354459] usb_match_id: id=c1d454dc idVendor=0x45e idProduct=0x0
[    1.355150] usb_match_id: id=c1d454f4 idVendor=0x45e idProduct=0x0
[    1.355844] usb_match_id: id=c1d4550c idVendor=0x46d idProduct=0x0
[    1.356520] usb_match_id: id=c1d45524 idVendor=0x46d idProduct=0x0
[    1.357201] usb_match_id: id=c1d4553c idVendor=0x738 idProduct=0x0
[    1.357871] usb_match_id: id=c1d45554 idVendor=0x738 idProduct=0x0
[    1.358550] usb_match_id: id=c1d4556c idVendor=0x738 idProduct=0x4540
[    1.359285] usb_match_id: id=c1d45584 idVendor=0xe6f idProduct=0x0
[    1.359972] usb_match_id: id=c1d4559c idVendor=0xe6f idProduct=0x0
[    1.360641] usb_match_id: id=c1d455b4 idVendor=0x12ab idProduct=0x0
[    1.361338] usb_match_id: id=c1d455cc idVendor=0x12ab idProduct=0x0
[    1.362035] usb_match_id: id=c1d455e4 idVendor=0x1430 idProduct=0x0
[    1.362735] usb_match_id: id=c1d455fc idVendor=0x1430 idProduct=0x0
[    1.363425] usb_match_id: id=c1d45614 idVendor=0x146b idProduct=0x0
[    1.364123] usb_match_id: id=c1d4562c idVendor=0x146b idProduct=0x0
[    1.364803] usb_match_id: id=c1d45644 idVendor=0x1bad idProduct=0x0
[    1.365490] usb_match_id: id=c1d4565c idVendor=0x1bad idProduct=0x0
[    1.366209] usb_match_id: id=c1d45674 idVendor=0xf0d idProduct=0x0
[    1.366881] usb_match_id: id=c1d4568c idVendor=0xf0d idProduct=0x0
[    1.367585] usb_match_id: id=c1d456a4 idVendor=0x1689 idProduct=0x0
[    1.368313] usb_match_id: id=c1d456bc idVendor=0x1689 idProduct=0x0
[    1.369076] usbcore: registered new interface driver xpad
[    1.369736] usb_device_match: device 1-0:1.0, driver ati_remote2 
[    1.370414] usb_match_id: id=c1d466f0 idVendor=0x471 idProduct=0x602
[    1.371144] usbcore: registered new interface driver ati_remote2
[    1.371919] wistron_btns: System unknown
[    1.372455] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    1.373551] rtc_cmos 00:01: RTC can wake from S4
[    1.374523] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
[    1.375323] rtc0: alarms up to one day, 114 bytes nvram, hpet irqs
[    1.376244] usb_device_match: device 1-0:1.0, driver i2c-diolan-u2c 
[    1.376978] usb_match_id: id=c1a8d820 idVendor=0xabf idProduct=0x3370
[    1.377666] usbcore: registered new interface driver i2c-diolan-u2c
[    1.378404] isa i2c-pca-isa.0: Please specify I/O base
[    1.379077] scx200_i2c: no SCx200 gpio pins available
[    1.379777] IR NEC protocol handler initialized
[    1.380297] IR RC6 protocol handler initialized
[    1.380794] IR JVC protocol handler initialized
[    1.381299] IR Sony protocol handler initialized
[    1.381800] IR MCE Keyboard/mouse protocol handler initialized
[    1.382571] saa7146: register extension 'budget dvb'
[    1.383151] saa7146: register extension 'budget_av'
[    1.383695] saa7146: register extension 'budget_patch dvb'
[    1.384312] saa7146: register extension 'av7110'
[    1.384835] usb_device_match: device 1-0:1.0, driver ttusb-dec 
[    1.385490] usb_match_id: id=c1d7ce74 idVendor=0xb48 idProduct=0x1006
[    1.386432] usb_match_id: id=c1d7ce8c idVendor=0xb48 idProduct=0x1008
[    1.387314] usb_match_id: id=c1d7cea4 idVendor=0xb48 idProduct=0x1009
[    1.388040] usbcore: registered new interface driver ttusb-dec
[    1.388699] usb_device_match: device 1-0:1.0, driver dvb_usb_dtt200u 
[    1.389437] usb_match_id: id=c1d80748 idVendor=0x14aa idProduct=0x201
[    1.390171] usb_match_id: id=c1d80760 idVendor=0x14aa idProduct=0x301
[    1.391126] usb_match_id: id=c1d80778 idVendor=0x14aa idProduct=0x222
[    1.391825] usb_match_id: id=c1d80790 idVendor=0x14aa idProduct=0x221
[    1.392552] usb_match_id: id=c1d807a8 idVendor=0x14aa idProduct=0x22a
[    1.393444] usb_match_id: id=c1d807c0 idVendor=0x14aa idProduct=0x22b
[    1.394522] usb_match_id: id=c1d807d8 idVendor=0x14aa idProduct=0x225
[    1.395602] usb_match_id: id=c1d807f0 idVendor=0x14aa idProduct=0x226
[    1.396672] usb_match_id: id=c1d80808 idVendor=0x14aa idProduct=0x220
[    1.397745] usb_match_id: id=c1d80820 idVendor=0x18f3 idProduct=0x220
[    1.398834] usbcore: registered new interface driver dvb_usb_dtt200u
[    1.399943] usb_device_match: device 1-0:1.0, driver dvb_usb_nova_t_usb2 
[    1.401095] usb_match_id: id=c1d81b6c idVendor=0x2040 idProduct=0x9300
[    1.402195] usb_match_id: id=c1d81b84 idVendor=0x2040 idProduct=0x9301
[    1.403270] usbcore: registered new interface driver dvb_usb_nova_t_usb2
[    1.404158] usb_device_match: device 1-0:1.0, driver dvb_usb_umt_010 
[    1.404861] usb_match_id: id=c1d824f4 idVendor=0x15f4 idProduct=0x1
[    1.405547] usb_match_id: id=c1d8250c idVendor=0x15f4 idProduct=0x15
[    1.406326] usbcore: registered new interface driver dvb_usb_umt_010
[    1.407190] usb_device_match: device 1-0:1.0, driver dvb_usb_gl861 
[    1.407869] usb_match_id: id=c1d82eb4 idVendor=0xdb0 idProduct=0x5581
[    1.408569] usb_match_id: id=c1d82ecc idVendor=0x5e3 idProduct=0xf170
[    1.409288] usbcore: registered new interface driver dvb_usb_gl861
[    1.410066] usb_device_match: device 1-0:1.0, driver dvb_usb_au6610 
[    1.411114] usb_match_id: id=c1d838b8 idVendor=0x58f idProduct=0x6610
[    1.412196] usbcore: registered new interface driver dvb_usb_au6610
[    1.413257] usb_device_match: device 1-0:1.0, driver dvb_usb_ttusb2 
[    1.414203] usb_match_id: id=c1d8522c idVendor=0x2304 idProduct=0x20f
[    1.414916] usb_match_id: id=c1d85244 idVendor=0x2304 idProduct=0x222
[    1.415602] usb_match_id: id=c1d8525c idVendor=0xb48 idProduct=0x3006
[    1.416312] usb_match_id: id=c1d85274 idVendor=0xb48 idProduct=0x300d
[    1.417035] usbcore: registered new interface driver dvb_usb_ttusb2
[    1.417719] usb_device_match: device 1-0:1.0, driver dvb_usb_dib0700 
[    1.418445] usb_match_id: id=c1d91b48 idVendor=0x10b8 idProduct=0x1e14
[    1.419176] usb_match_id: id=c1d91b60 idVendor=0x10b8 idProduct=0x1e78
[    1.419882] usb_match_id: id=c1d91b78 idVendor=0x2040 idProduct=0x9941
[    1.420596] usb_match_id: id=c1d91b90 idVendor=0x2040 idProduct=0x9950
[    1.421318] usb_match_id: id=c1d91ba8 idVendor=0x2040 idProduct=0x7050
[    1.422041] usb_match_id: id=c1d91bc0 idVendor=0x7ca idProduct=0xa807
[    1.422733] usb_match_id: id=c1d91bd8 idVendor=0x185b idProduct=0x1e78
[    1.423449] usb_match_id: id=c1d91bf0 idVendor=0x1584 idProduct=0x6003
[    1.424171] usb_match_id: id=c1d91c08 idVendor=0x413 idProduct=0x6f00
[    1.424863] usb_match_id: id=c1d91c20 idVendor=0x2040 idProduct=0x7060
[    1.425575] usb_match_id: id=c1d91c38 idVendor=0x7ca idProduct=0xb808
[    1.426291] usb_match_id: id=c1d91c50 idVendor=0x2304 idProduct=0x22c
[    1.427008] usb_match_id: id=c1d91c68 idVendor=0xccd idProduct=0x5a
[    1.427682] usb_match_id: id=c1d91c80 idVendor=0x2040 idProduct=0x9580
[    1.428394] usb_match_id: id=c1d91c98 idVendor=0x10b8 idProduct=0x1ef0
[    1.429120] usb_match_id: id=c1d91cb0 idVendor=0x10b8 idProduct=0x1ebc
[    1.429819] usb_match_id: id=c1d91cc8 idVendor=0x2304 idProduct=0x228
[    1.430530] usb_match_id: id=c1d91ce0 idVendor=0x10b8 idProduct=0x1ebe
[    1.431257] usb_match_id: id=c1d91cf8 idVendor=0x2304 idProduct=0x229
[    1.431969] usb_match_id: id=c1d91d10 idVendor=0x185b idProduct=0x1e80
[    1.432660] usb_match_id: id=c1d91d28 idVendor=0x7ca idProduct=0xb568
[    1.433367] usb_match_id: id=c1d91d40 idVendor=0x1044 idProduct=0x7001
[    1.434096] usb_match_id: id=c1d91d58 idVendor=0x5d8 idProduct=0x810f
[    1.434786] usb_match_id: id=c1d91d70 idVendor=0xb05 idProduct=0x171f
[    1.435494] usb_match_id: id=c1d91d88 idVendor=0xb05 idProduct=0x173f
[    1.436207] usb_match_id: id=c1d91da0 idVendor=0x2040 idProduct=0x7070
[    1.436929] usb_match_id: id=c1d91db8 idVendor=0x2040 idProduct=0x7080
[    1.437623] usb_match_id: id=c1d91dd0 idVendor=0xccd idProduct=0x58
[    1.438320] usb_match_id: id=c1d91de8 idVendor=0x2304 idProduct=0x22e
[    1.439035] usb_match_id: id=c1d91e00 idVendor=0x2304 idProduct=0x236
[    1.439726] usb_match_id: id=c1d91e18 idVendor=0x2304 idProduct=0x237
[    1.440433] usb_match_id: id=c1d91e30 idVendor=0x1164 idProduct=0x1edc
[    1.441153] usb_match_id: id=c1d91e48 idVendor=0xccd idProduct=0x60
[    1.441825] usb_match_id: id=c1d91e60 idVendor=0xccd idProduct=0x78
[    1.442512] usb_match_id: id=c1d91e78 idVendor=0x413 idProduct=0x6f01
[    1.443231] usb_match_id: id=c1d91e90 idVendor=0x2040 idProduct=0x5200
[    1.443960] usb_match_id: id=c1d91ea8 idVendor=0x2040 idProduct=0x8400
[    1.444651] usb_match_id: id=c1d91ec0 idVendor=0x1044 idProduct=0x7002
[    1.445374] usb_match_id: id=c1d91ed8 idVendor=0x1164 idProduct=0x1f08
[    1.446098] usb_match_id: id=c1d91ef0 idVendor=0xb05 idProduct=0x1736
[    1.446796] usb_match_id: id=c1d91f08 idVendor=0x2304 idProduct=0x23a
[    1.447503] usb_match_id: id=c1d91f20 idVendor=0x2304 idProduct=0x23b
[    1.448219] usb_match_id: id=c1d91f38 idVendor=0xccd idProduct=0x62
[    1.448921] usb_match_id: id=c1d91f50 idVendor=0xccd idProduct=0x81
[    1.449587] usb_match_id: id=c1d91f68 idVendor=0x1415 idProduct=0x3
[    1.450296] usb_match_id: id=c1d91f80 idVendor=0x1164 idProduct=0x2edc
[    1.451031] usb_match_id: id=c1d91f98 idVendor=0x2040 idProduct=0xb200
[    1.451728] usb_match_id: id=c1d91fb0 idVendor=0x2040 idProduct=0xb210
[    1.452449] usb_match_id: id=c1d91fc8 idVendor=0x1164 idProduct=0x871
[    1.453168] usb_match_id: id=c1d91fe0 idVendor=0xfd9 idProduct=0x21
[    1.453845] usb_match_id: id=c1d91ff8 idVendor=0xfd9 idProduct=0x20
[    1.454530] usb_match_id: id=c1d92010 idVendor=0x413 idProduct=0x60f6
[    1.455247] usb_match_id: id=c1d92028 idVendor=0xccd idProduct=0x10a0
[    1.455965] usb_match_id: id=c1d92040 idVendor=0xccd idProduct=0x10a1
[    1.456646] usb_match_id: id=c1d92058 idVendor=0x1164 idProduct=0x1efc
[    1.457369] usb_match_id: id=c1d92070 idVendor=0x1164 idProduct=0x1e8c
[    1.458097] usb_match_id: id=c1d92088 idVendor=0x2304 idProduct=0x243
[    1.458805] usb_match_id: id=c1d920a0 idVendor=0x2013 idProduct=0x245
[    1.459521] usb_match_id: id=c1d920b8 idVendor=0x2013 idProduct=0x248
[    1.460239] usb_match_id: id=c1d920d0 idVendor=0x10b8 idProduct=0x1e80
[    1.460970] usb_match_id: id=c1d920e8 idVendor=0xccd idProduct=0xab
[    1.461638] usb_match_id: id=c1d92100 idVendor=0x10b8 idProduct=0x1f98
[    1.462364] usb_match_id: id=c1d92118 idVendor=0x10b8 idProduct=0x1f90
[    1.463094] usb_match_id: id=c1d92130 idVendor=0x1554 idProduct=0x5010
[    1.463798] usb_match_id: id=c1d92148 idVendor=0x1e59 idProduct=0x2
[    1.464487] usb_match_id: id=c1d92160 idVendor=0x2304 idProduct=0x245
[    1.465209] usb_match_id: id=c1d92178 idVendor=0x2304 idProduct=0x248
[    1.465927] usb_match_id: id=c1d92190 idVendor=0x10b8 idProduct=0x1fa0
[    1.466622] usb_match_id: id=c1d921a8 idVendor=0xfd9 idProduct=0x11
[    1.467323] usb_match_id: id=c1d921c0 idVendor=0x10b8 idProduct=0x2383
[    1.468120] usb_match_id: id=c1d921d8 idVendor=0x10b8 idProduct=0x1fa8
[    1.468825] usb_match_id: id=c1d921f0 idVendor=0x10b8 idProduct=0x2384
[    1.469532] usb_match_id: id=c1d92208 idVendor=0x10b8 idProduct=0x1bb2
[    1.470254] usb_match_id: id=c1d92220 idVendor=0x10b8 idProduct=0x1bb4
[    1.470973] usb_match_id: id=c1d92238 idVendor=0x14f7 idProduct=0x4
[    1.471636] usb_match_id: id=c1d92250 idVendor=0x1660 idProduct=0x1921
[    1.472355] usb_match_id: id=c1d92268 idVendor=0x2304 idProduct=0x23d
[    1.473071] usb_match_id: id=c1d92280 idVendor=0x2304 idProduct=0x23e
[    1.473768] usb_match_id: id=c1d92298 idVendor=0x10b8 idProduct=0x1bb7
[    1.474482] usb_match_id: id=c1d922b0 idVendor=0x10b8 idProduct=0x1e6e
[    1.475210] usb_match_id: id=c1d922c8 idVendor=0x10b8 idProduct=0x1f9c
[    1.475931] usb_match_id: id=c1d922e0 idVendor=0xfd9 idProduct=0x3f
[    1.476637] dummy_hcd dummy_hcd: port status 0x00010101 has changes
[    1.476648] usbcore: registered new interface driver dvb_usb_dib0700
[    1.476691] usb_device_match: device 1-0:1.0, driver pctv452e 
[    1.476695] usb_match_id: id=c1d94c1c idVendor=0x2304 idProduct=0x21f
[    1.476696] usb_match_id: id=c1d94c34 idVendor=0xb48 idProduct=0x3007
[    1.476697] usb_match_id: id=c1d94c4c idVendor=0xb48 idProduct=0x300a
[    1.476699] usbcore: registered new interface driver pctv452e
[    1.476714] usb_device_match: device 1-0:1.0, driver dw2102 
[    1.476717] usb_match_id: id=c1d97af4 idVendor=0x4b4 idProduct=0x2102
[    1.476718] usb_match_id: id=c1d97b0c idVendor=0x4b4 idProduct=0x2101
[    1.476719] usb_match_id: id=c1d97b24 idVendor=0x4b4 idProduct=0x2104
[    1.476719] usb_match_id: id=c1d97b3c idVendor=0x9022 idProduct=0xd650
[    1.476720] usb_match_id: id=c1d97b54 idVendor=0xccd idProduct=0x64
[    1.476721] usb_match_id: id=c1d97b6c idVendor=0x4b4 idProduct=0x3101
[    1.476722] usb_match_id: id=c1d97b84 idVendor=0x9022 idProduct=0xd630
[    1.476723] usb_match_id: id=c1d97b9c idVendor=0x3011 idProduct=0xb012
[    1.476724] usb_match_id: id=c1d97bb4 idVendor=0x9022 idProduct=0xd660
[    1.476725] usb_match_id: id=c1d97bcc idVendor=0x3034 idProduct=0x7500
[    1.476725] usb_match_id: id=c1d97be4 idVendor=0x1f4d idProduct=0x3000
[    1.476726] usb_match_id: id=c1d97bfc idVendor=0xccd idProduct=0xa8
[    1.476727] usb_match_id: id=c1d97c14 idVendor=0x9022 idProduct=0xd481
[    1.476728] usb_match_id: id=c1d97c2c idVendor=0x9022 idProduct=0xd482
[    1.476729] usb_match_id: id=c1d97c44 idVendor=0x1f4d idProduct=0x3100
[    1.476730] usbcore: registered new interface driver dw2102
[    1.476737] usb_device_match: device 1-0:1.0, driver dvb_usb_af9015 
[    1.476739] usb_match_id: id=c1d99d24 idVendor=0x15a4 idProduct=0x9015
[    1.476740] usb_match_id: id=c1d99d3c idVendor=0x15a4 idProduct=0x9016
[    1.476740] usb_match_id: id=c1d99d54 idVendor=0x413 idProduct=0x6029
[    1.476741] usb_match_id: id=c1d99d6c idVendor=0x2304 idProduct=0x22b
[    1.476742] usb_match_id: id=c1d99d84 idVendor=0x1b80 idProduct=0xe399
[    1.476743] usb_match_id: id=c1d99d9c idVendor=0x13d3 idProduct=0x3226
[    1.476744] usb_match_id: id=c1d99db4 idVendor=0x13d3 idProduct=0x3237
[    1.476745] usb_match_id: id=c1d99dcc idVendor=0xccd idProduct=0x69
[    1.476745] usb_match_id: id=c1d99de4 idVendor=0x1b80 idProduct=0xc160
[    1.476746] usb_match_id: id=c1d99dfc idVendor=0x7ca idProduct=0xa815
[    1.476747] usb_match_id: id=c1d99e14 idVendor=0x1ae7 idProduct=0x381
[    1.476748] usb_match_id: id=c1d99e2c idVendor=0x1462 idProduct=0x8801
[    1.476749] usb_match_id: id=c1d99e44 idVendor=0x7ca idProduct=0x8150
[    1.476749] usb_match_id: id=c1d99e5c idVendor=0x10b9 idProduct=0x8000
[    1.476750] usb_match_id: id=c1d99e74 idVendor=0x7ca idProduct=0xa309
[    1.476751] usb_match_id: id=c1d99e8c idVendor=0x1462 idProduct=0x8807
[    1.476752] usb_match_id: id=c1d99ea4 idVendor=0x1b80 idProduct=0xe396
[    1.476753] usb_match_id: id=c1d99ebc idVendor=0x1b80 idProduct=0xe39b
[    1.476755] usb_match_id: id=c1d99ed4 idVendor=0x1b80 idProduct=0xe395
[    1.476756] usb_match_id: id=c1d99eec idVendor=0x15a4 idProduct=0x901b
[    1.476757] usb_match_id: id=c1d99f04 idVendor=0x7ca idProduct=0x850a
[    1.476757] usb_match_id: id=c1d99f1c idVendor=0x7ca idProduct=0xa805
[    1.476758] usb_match_id: id=c1d99f34 idVendor=0x1b80 idProduct=0xe397
[    1.476759] usb_match_id: id=c1d99f4c idVendor=0x1b80 idProduct=0xc810
[    1.476760] usb_match_id: id=c1d99f64 idVendor=0x458 idProduct=0x4012
[    1.476761] usb_match_id: id=c1d99f7c idVendor=0x1b80 idProduct=0xe400
[    1.476762] usb_match_id: id=c1d99f94 idVendor=0x1b80 idProduct=0xc161
[    1.476762] usb_match_id: id=c1d99fac idVendor=0x1b80 idProduct=0xe39d
[    1.476763] usb_match_id: id=c1d99fc4 idVendor=0x1b80 idProduct=0xe402
[    1.476764] usb_match_id: id=c1d99fdc idVendor=0x413 idProduct=0x6a04
[    1.476765] usb_match_id: id=c1d99ff4 idVendor=0x1b80 idProduct=0xe383
[    1.476767] usb_match_id: id=c1d9a00c idVendor=0x1b80 idProduct=0xe39a
[    1.476768] usb_match_id: id=c1d9a024 idVendor=0x7ca idProduct=0x815a
[    1.476768] usb_match_id: id=c1d9a03c idVendor=0xccd idProduct=0x97
[    1.476769] usb_match_id: id=c1d9a054 idVendor=0xccd idProduct=0x99
[    1.476770] usb_match_id: id=c1d9a06c idVendor=0x7ca idProduct=0x850b
[    1.476771] usb_match_id: id=c1d9a084 idVendor=0x1f4d idProduct=0x9016
[    1.476772] usb_match_id: id=c1d9a09c idVendor=0x1b80 idProduct=0xe401
[    1.476773] usbcore: registered new interface driver dvb_usb_af9015
[    1.476776] usb_device_match: device 1-0:1.0, driver cinergyT2 
[    1.476777] usb_match_id: id=c1d9ad3c idVendor=0xccd idProduct=0x38
[    1.476779] usbcore: registered new interface driver cinergyT2
[    1.476783] usb_device_match: device 1-0:1.0, driver dvb_usb_ce6230 
[    1.476784] usb_match_id: id=c1d9b9e0 idVendor=0x8086 idProduct=0x9500
[    1.476785] usb_match_id: id=c1d9b9f8 idVendor=0x7ca idProduct=0xa310
[    1.476787] usbcore: registered new interface driver dvb_usb_ce6230
[    1.476790] usb_device_match: device 1-0:1.0, driver dvb_usb_friio 
[    1.476792] usb_match_id: id=c1d9c418 idVendor=0x7a69 idProduct=0x1
[    1.476794] usbcore: registered new interface driver dvb_usb_friio
[    1.476798] usb_device_match: device 1-0:1.0, driver dvb_usb_ec168 
[    1.476800] usb_match_id: id=c1d9d07c idVendor=0x18b4 idProduct=0x1689
[    1.476801] usb_match_id: id=c1d9d094 idVendor=0x18b4 idProduct=0xfffa
[    1.476802] usb_match_id: id=c1d9d0ac idVendor=0x18b4 idProduct=0xfffb
[    1.476803] usb_match_id: id=c1d9d0c4 idVendor=0x18b4 idProduct=0x1001
[    1.476803] usb_match_id: id=c1d9d0dc idVendor=0x18b4 idProduct=0x1002
[    1.476805] usbcore: registered new interface driver dvb_usb_ec168
[    1.476808] usb_device_match: device 1-0:1.0, driver dvb_usb_az6007 
[    1.476809] usb_match_id: id=c1d9db3c idVendor=0x13d3 idProduct=0xccd
[    1.476813] usb_match_id: id=c1d9db54 idVendor=0xccd idProduct=0x10b4
[    1.476821] usb_match_id: id=c1d9db6c idVendor=0xccd idProduct=0x10a3
[    1.476823] usbcore: registered new interface driver dvb_usb_az6007
[    1.476829] usb_device_match: device 1-0:1.0, driver dvb_usb_az6027 
[    1.476831] usb_match_id: id=c1d9e828 idVendor=0x13d3 idProduct=0x3275
[    1.476832] usb_match_id: id=c1d9e840 idVendor=0xccd idProduct=0x10a4
[    1.476833] usb_match_id: id=c1d9e858 idVendor=0xccd idProduct=0x10ac
[    1.476833] usb_match_id: id=c1d9e870 idVendor=0x14f7 idProduct=0x1
[    1.476834] usb_match_id: id=c1d9e888 idVendor=0x14f7 idProduct=0x2
[    1.476835] usb_match_id: id=c1d9e8a0 idVendor=0xfd9 idProduct=0x2a
[    1.476837] usbcore: registered new interface driver dvb_usb_az6027
[    1.476841] usb_device_match: device 1-0:1.0, driver LME2510C_DVB-S 
[    1.476843] usb_match_id: id=c1d9fd50 idVendor=0x3344 idProduct=0x1122
[    1.476844] usb_match_id: id=c1d9fd68 idVendor=0x3344 idProduct=0x1120
[    1.476845] usb_match_id: id=c1d9fd80 idVendor=0x3344 idProduct=0x22f0
[    1.476848] usbcore: registered new interface driver LME2510C_DVB-S
[    1.476852] usb_device_match: device 1-0:1.0, driver dvb_usb_af9035 
[    1.476853] usb_match_id: id=c1da0434 idVendor=0x15a4 idProduct=0x9035
[    1.476854] usb_match_id: id=c1da044c idVendor=0x15a4 idProduct=0x1000
[    1.476854] usb_match_id: id=c1da0464 idVendor=0x15a4 idProduct=0x1001
[    1.476855] usb_match_id: id=c1da047c idVendor=0x15a4 idProduct=0x1002
[    1.476856] usb_match_id: id=c1da0494 idVendor=0x15a4 idProduct=0x1003
[    1.476857] usb_match_id: id=c1da04ac idVendor=0xccd idProduct=0x93
[    1.476858] usb_match_id: id=c1da04c4 idVendor=0x7ca idProduct=0xa835
[    1.476859] usb_match_id: id=c1da04dc idVendor=0x7ca idProduct=0xb835
[    1.476859] usb_match_id: id=c1da04f4 idVendor=0x7ca idProduct=0x1867
[    1.476860] usb_match_id: id=c1da050c idVendor=0x7ca idProduct=0xa867
[    1.476861] usb_match_id: id=c1da0524 idVendor=0x7ca idProduct=0x825
[    1.476862] usbcore: registered new interface driver dvb_usb_af9035
[    1.476879] nGene PCIE bridge driver, Copyright (C) 2005-2007 Micronas
[    1.476909] Digital Devices PCIE bridge driver, Copyright (C) 2010-11 Digital Devices GmbH
[    1.476938] Driver for 1-wire Dallas network protocol.
[    1.476984] usb_device_match: device 1-0:1.0, driver DS9490R 
[    1.476986] usb_match_id: id=c1da56d8 idVendor=0x4fa idProduct=0x2490
[    1.476989] usbcore: registered new interface driver DS9490R
[    1.476993] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    1.477066] power_supply test_ac: power_supply_changed
[    1.477075] power_supply test_ac: power_supply_changed_work
[    1.477080] power_supply test_ac: power_supply_update_gen_leds 1
[    1.477147] power_supply test_battery: power_supply_changed
[    1.477151] power_supply test_battery: power_supply_changed_work
[    1.477153] power_supply test_battery: power_supply_update_bat_leds 2
[    1.477166] power_supply test_usb: power_supply_changed
[    1.477171] power_supply test_usb: power_supply_changed_work
[    1.477173] power_supply test_usb: power_supply_update_gen_leds 1
[    1.477340] usb_device_match: device 1-0:1.0, driver pcwd_usb 
[    1.477341] usb_match_id: id=c1daa624 idVendor=0xc98 idProduct=0x1140
[    1.477343] usbcore: registered new interface driver pcwd_usb
[    1.477349] advantechwdt: WDT driver for Advantech single board computer initialising
[    1.477412] advantechwdt: initialized. timeout=60 sec (nowayout=1)
[    1.477416] alim7101_wdt: Steve Hill <steve@navaho.co.uk>
[    1.477420] alim7101_wdt: ALi M7101 PMU not present - WDT not set
[    1.477422] sp5100_tco: SP5100 TCO WatchDog Timer Driver v0.01
[    1.477467] sc520_wdt: cannot register miscdev on minor=130 (err=-16)
[    1.572959] ib700wdt: WDT driver for IB700 single board computer initialising
[    1.574226] ib700wdt: START method I/O 443 is not available
[    1.575172] ib700wdt: probe of ib700wdt failed with error -5
[    1.576115] wafer5823wdt: WDT driver for Wafer 5823 single board computer initialising
[    1.577284] wafer5823wdt: I/O address 0x0443 already in use
[    1.577943] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[    1.578704] i6300esb: cannot register miscdev on minor=130 (err=-16)
[    1.579489] i6300ESB timer: probe of 0000:00:0b.0 failed with error -16
[    1.580279] pc87413_wdt: Version 1.1 at io 0x2E
[    1.580767] pc87413_wdt: cannot register miscdev on minor=130 (err=-16)
[    1.581644] sbc60xxwdt: I/O address 0x0443 already in use
[    1.582530] cpu5wdt: misc_register failed
[    1.583317] w83627hf_wdt: WDT driver for the Winbond(TM) W83627HF/THF/HG/DHG Super I/O chip initialising
[    1.584819] w83627hf_wdt: Watchdog already running. Resetting timeout to 60 sec
[    1.585635] w83627hf_wdt: cannot register miscdev on minor=130 (err=-16)
[    1.586375] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Super I/O chip initialising
[    1.587429] w83697ug_wdt: No W83697UG/UF could be found
[    1.588250] w83877f_wdt: I/O address 0x0443 already in use
[    1.589120] machzwd: MachZ ZF-Logic Watchdog driver initializing
[    1.589940] machzwd: no ZF-Logic found
[    1.590376] Bluetooth: HCI UART driver ver 2.2
[    1.590936] Bluetooth: HCILL protocol initialized
[    1.591535] usb_device_match: device 1-0:1.0, driver bfusb 
[    1.592368] usb_match_id: id=c1daeb08 idVendor=0x57c idProduct=0x2200
[    1.593419] usbcore: registered new interface driver bfusb
[    1.594337] usb_device_match: device 1-0:1.0, driver btusb 
[    1.595253] usb_match_id: id=c1daf384 idVendor=0x0 idProduct=0x0
[    1.596061] usb_match_id: id=c1daf39c idVendor=0xa5c idProduct=0x21e1
[    1.596745] usb_match_id: id=c1daf3b4 idVendor=0x5ac idProduct=0x8213
[    1.597464] usb_match_id: id=c1daf3cc idVendor=0x5ac idProduct=0x8215
[    1.598187] usb_match_id: id=c1daf3e4 idVendor=0x5ac idProduct=0x8218
[    1.599083] usb_match_id: id=c1daf3fc idVendor=0x5ac idProduct=0x821b
[    1.600128] usb_match_id: id=c1daf414 idVendor=0x5ac idProduct=0x821f
[    1.601101] usb_match_id: id=c1daf42c idVendor=0x5ac idProduct=0x821a
[    1.601788] usb_match_id: id=c1daf444 idVendor=0x5ac idProduct=0x8281
[    1.602509] usb_match_id: id=c1daf45c idVendor=0x57c idProduct=0x3800
[    1.603236] usb_match_id: id=c1daf474 idVendor=0x4bf idProduct=0x30a
[    1.603940] usb_match_id: id=c1daf48c idVendor=0x44e idProduct=0x3001
[    1.604629] usb_match_id: id=c1daf4a4 idVendor=0x44e idProduct=0x3002
[    1.605353] usb_match_id: id=c1daf4bc idVendor=0xbdb idProduct=0x1002
[    1.606067] usb_match_id: id=c1daf4d4 idVendor=0xc10 idProduct=0x0
[    1.606726] usb_match_id: id=c1daf4ec idVendor=0x489 idProduct=0xe042
[    1.607445] usb_match_id: id=c1daf504 idVendor=0xa5c idProduct=0x21e3
[    1.608164] usb_match_id: id=c1daf51c idVendor=0xa5c idProduct=0x21e6
[    1.608854] usb_match_id: id=c1daf534 idVendor=0xa5c idProduct=0x21e8
[    1.609565] usb_match_id: id=c1daf54c idVendor=0xa5c idProduct=0x21f3
[    1.610283] usb_match_id: id=c1daf564 idVendor=0x413c idProduct=0x8197
[    1.611010] usb_match_id: id=c1daf57c idVendor=0x489 idProduct=0xe033
[    1.611709] usbcore: registered new interface driver btusb
[    1.612337] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
[    1.612998] usb_device_match: device 1-0:1.0, driver ath3k 
[    1.613597] usb_match_id: id=c1db0048 idVendor=0xcf3 idProduct=0x3000
[    1.614322] usb_match_id: id=c1db0060 idVendor=0xcf3 idProduct=0x3002
[    1.615047] usb_match_id: id=c1db0078 idVendor=0xcf3 idProduct=0xe019
[    1.615733] usb_match_id: id=c1db0090 idVendor=0x13d3 idProduct=0x3304
[    1.616467] usb_match_id: id=c1db00a8 idVendor=0x930 idProduct=0x215
[    1.617183] usb_match_id: id=c1db00c0 idVendor=0x489 idProduct=0xe03d
[    1.617881] usb_match_id: id=c1db00d8 idVendor=0x3f0 idProduct=0x311d
[    1.618591] usb_match_id: id=c1db00f0 idVendor=0xcf3 idProduct=0x3004
[    1.619305] usb_match_id: id=c1db0108 idVendor=0xcf3 idProduct=0x311d
[    1.620025] usb_match_id: id=c1db0120 idVendor=0x13d3 idProduct=0x3375
[    1.620716] usb_match_id: id=c1db0138 idVendor=0x4ca idProduct=0x3005
[    1.621437] usb_match_id: id=c1db0150 idVendor=0x13d3 idProduct=0x3362
[    1.622164] usb_match_id: id=c1db0168 idVendor=0xcf3 idProduct=0xe004
[    1.622852] usb_match_id: id=c1db0180 idVendor=0x930 idProduct=0x219
[    1.623550] usb_match_id: id=c1db0198 idVendor=0x489 idProduct=0xe02c
[    1.624270] usb_match_id: id=c1db01b0 idVendor=0x489 idProduct=0xe03c
[    1.624990] usbcore: registered new interface driver ath3k
[    1.625611] sdhci: Secure Digital Host Controller Interface driver
[    1.626305] sdhci: Copyright(c) Pierre Ossman
[    1.626772] wbsd: Winbond W83L51xD SD/MMC card interface driver
[    1.627436] wbsd: Copyright(c) Pierre Ossman
[    1.627951] via_sdmmc: VIA SD/MMC Card Reader driver (C) 2008 VIA Technologies, Inc.
[    1.628790] VUB300 Driver rom wait states = 1C irqpoll timeout = 0400
[    1.629710] usb_device_match: device 1-0:1.0, driver vub300 
[    1.630378] usb_match_id: id=c1db6b04 idVendor=0x2201 idProduct=0x12c
[    1.631097] usb_match_id: id=c1db6b1c idVendor=0x424 idProduct=0x12c
[    1.631774] usbcore: registered new interface driver vub300
[    1.632410] usb_device_match: device 1-0:1.0, driver ushc 
[    1.633038] usb_match_id: id=c1db72a4 idVendor=0xa12 idProduct=0x5d10
[    1.633735] usbcore: registered new interface driver ushc
[    1.634352] sdhci-pltfm: SDHCI platform and OF driver helper
[    1.635097] Driver for HIFN 795x crypto accelerator chip has been successfully registered.
[    1.636071] usb_device_match: device 1-0:1.0, driver usbmouse 
[    1.636703] usb_match_id: id=c1dc0aa8 idVendor=0x0 idProduct=0x0
[    1.637380] usbcore: registered new interface driver usbmouse
[    1.638099] msi_laptop: driver 0.5 successfully loaded
[    1.638706] hdaps: supported laptop not found!
[    1.639224] hdaps: driver init failed (ret=-19)!
[    1.639748] intel_oaktrail: Platform not recognized (You could try the module's force-parameter)Audio Excel DSP 16 init driver Copyright (C) Riccardo Facchetti 1995-98
[    1.641503] aedsp16: I/O, IRQ and DMA are mandatory
[    1.642065] ad1848/cs4248 codec driver Copyright (C) by Hannu Savolainen 1993-1996
[    1.642903] ad1848: No ISAPnP cards found, trying standard ones...
[    1.643571] Pro Audio Spectrum driver Copyright (C) by Hannu Savolainen 1993-1996
[    1.644396] I/O, IRQ, DMA and type are mandatory
[    1.644920] sb: Init: Starting Probe...
[    1.645349] sb: Init: Done
[    1.645663] MIDI Loopback device driver
[    1.646497] usb_device_match: device 1-0:1.0, driver snd-usb-audio 
[    1.647209] usb_match_id: id=c1e16d8c idVendor=0x403 idProduct=0xb8d8
[    1.647930] usb_match_id: id=c1e16da4 idVendor=0x41e idProduct=0x3048
[    1.648610] usb_match_id: id=c1e16dbc idVendor=0x41e idProduct=0x3010
[    1.649332] usb_match_id: id=c1e16dd4 idVendor=0x41e idProduct=0x3f02
[    1.650054] usb_match_id: id=c1e16dec idVendor=0x41e idProduct=0x3f04
[    1.650739] usb_match_id: id=c1e16e04 idVendor=0x41e idProduct=0x3f0a
[    1.651462] usb_match_id: id=c1e16e1c idVendor=0x41e idProduct=0x3f19
[    1.652182] usb_match_id: id=c1e16e34 idVendor=0x46d idProduct=0x850
[    1.652863] usb_match_id: id=c1e16e4c idVendor=0x46d idProduct=0x8ae
[    1.653563] usb_match_id: id=c1e16e64 idVendor=0x46d idProduct=0x8c6
[    1.654272] usb_match_id: id=c1e16e7c idVendor=0x46d idProduct=0x8f0
[    1.654993] usb_match_id: id=c1e16e94 idVendor=0x46d idProduct=0x8f5
[    1.655669] usb_match_id: id=c1e16eac idVendor=0x46d idProduct=0x8f6
[    1.656377] usb_match_id: id=c1e16ec4 idVendor=0x46d idProduct=0x990
[    1.657090] usb_match_id: id=c1e16edc idVendor=0x499 idProduct=0x1000
[    1.657773] usb_match_id: id=c1e16ef4 idVendor=0x499 idProduct=0x1001
[    1.658494] usb_match_id: id=c1e16f0c idVendor=0x499 idProduct=0x1002
[    1.659221] usb_match_id: id=c1e16f24 idVendor=0x499 idProduct=0x1003
[    1.659937] usb_match_id: id=c1e16f3c idVendor=0x499 idProduct=0x1004
[    1.660624] usb_match_id: id=c1e16f54 idVendor=0x499 idProduct=0x1005
[    1.661340] usb_match_id: id=c1e16f6c idVendor=0x499 idProduct=0x1006
[    1.662057] usb_match_id: id=c1e16f84 idVendor=0x499 idProduct=0x1007
[    1.662745] usb_match_id: id=c1e16f9c idVendor=0x499 idProduct=0x1008
[    1.663462] usb_match_id: id=c1e16fb4 idVendor=0x499 idProduct=0x1009
[    1.664192] usb_match_id: id=c1e16fcc idVendor=0x499 idProduct=0x100a
[    1.664879] usb_match_id: id=c1e16fe4 idVendor=0x499 idProduct=0x100c
[    1.665589] usb_match_id: id=c1e16ffc idVendor=0x499 idProduct=0x100d
[    1.666308] usb_match_id: id=c1e17014 idVendor=0x499 idProduct=0x100e
[    1.667044] usb_match_id: id=c1e1702c idVendor=0x499 idProduct=0x100f
[    1.667728] usb_match_id: id=c1e17044 idVendor=0x499 idProduct=0x1010
[    1.668446] usb_match_id: id=c1e1705c idVendor=0x499 idProduct=0x1011
[    1.669166] usb_match_id: id=c1e17074 idVendor=0x499 idProduct=0x1012
[    1.669863] usb_match_id: id=c1e1708c idVendor=0x499 idProduct=0x1013
[    1.670560] usb_match_id: id=c1e170a4 idVendor=0x499 idProduct=0x1014
[    1.671279] usb_match_id: id=c1e170bc idVendor=0x499 idProduct=0x1015
[    1.671990] usb_match_id: id=c1e170d4 idVendor=0x499 idProduct=0x1016
[    1.672674] usb_match_id: id=c1e170ec idVendor=0x499 idProduct=0x1017
[    1.673401] usb_match_id: id=c1e17104 idVendor=0x499 idProduct=0x1018
[    1.674119] usb_match_id: id=c1e1711c idVendor=0x499 idProduct=0x1019
[    1.674812] usb_match_id: id=c1e17134 idVendor=0x499 idProduct=0x101a
[    1.675535] usb_match_id: id=c1e1714c idVendor=0x499 idProduct=0x101b
[    1.676255] usb_match_id: id=c1e17164 idVendor=0x499 idProduct=0x101c
[    1.676979] usb_match_id: id=c1e1717c idVendor=0x499 idProduct=0x101d
[    1.677666] usb_match_id: id=c1e17194 idVendor=0x499 idProduct=0x101e
[    1.678381] usb_match_id: id=c1e171ac idVendor=0x499 idProduct=0x101f
[    1.679102] usb_match_id: id=c1e171c4 idVendor=0x499 idProduct=0x1020
[    1.679785] usb_match_id: id=c1e171dc idVendor=0x499 idProduct=0x1021
[    1.680509] usb_match_id: id=c1e171f4 idVendor=0x499 idProduct=0x1022
[    1.681232] usb_match_id: id=c1e1720c idVendor=0x499 idProduct=0x1023
[    1.681950] usb_match_id: id=c1e17224 idVendor=0x499 idProduct=0x1024
[    1.682635] usb_match_id: id=c1e1723c idVendor=0x499 idProduct=0x1025
[    1.683359] usb_match_id: id=c1e17254 idVendor=0x499 idProduct=0x1026
[    1.684082] usb_match_id: id=c1e1726c idVendor=0x499 idProduct=0x1027
[    1.684767] usb_match_id: id=c1e17284 idVendor=0x499 idProduct=0x1028
[    1.685494] usb_match_id: id=c1e1729c idVendor=0x499 idProduct=0x1029
[    1.686211] usb_match_id: id=c1e172b4 idVendor=0x499 idProduct=0x102a
[    1.686929] usb_match_id: id=c1e172cc idVendor=0x499 idProduct=0x102b
[    1.687613] usb_match_id: id=c1e172e4 idVendor=0x499 idProduct=0x102e
[    1.688329] usb_match_id: id=c1e172fc idVendor=0x499 idProduct=0x1030
[    1.689050] usb_match_id: id=c1e17314 idVendor=0x499 idProduct=0x1031
[    1.689736] usb_match_id: id=c1e1732c idVendor=0x499 idProduct=0x1032
[    1.690454] usb_match_id: id=c1e17344 idVendor=0x499 idProduct=0x1033
[    1.691175] usb_match_id: id=c1e1735c idVendor=0x499 idProduct=0x1034
[    1.691862] usb_match_id: id=c1e17374 idVendor=0x499 idProduct=0x1035
[    1.692577] usb_match_id: id=c1e1738c idVendor=0x499 idProduct=0x1036
[    1.693303] usb_match_id: id=c1e173a4 idVendor=0x499 idProduct=0x1037
[    1.694015] usb_match_id: id=c1e173bc idVendor=0x499 idProduct=0x1038
[    1.694734] usb_match_id: id=c1e173d4 idVendor=0x499 idProduct=0x1039
[    1.695466] usb_match_id: id=c1e173ec idVendor=0x499 idProduct=0x103a
[    1.696187] usb_match_id: id=c1e17404 idVendor=0x499 idProduct=0x103b
[    1.696933] usb_match_id: id=c1e1741c idVendor=0x499 idProduct=0x103c
[    1.697630] usb_match_id: id=c1e17434 idVendor=0x499 idProduct=0x103d
[    1.698345] usb_match_id: id=c1e1744c idVendor=0x499 idProduct=0x103e
[    1.699072] usb_match_id: id=c1e17464 idVendor=0x499 idProduct=0x103f
[    1.699759] usb_match_id: id=c1e1747c idVendor=0x499 idProduct=0x1040
[    1.700478] usb_match_id: id=c1e17494 idVendor=0x499 idProduct=0x1041
[    1.701195] usb_match_id: id=c1e174ac idVendor=0x499 idProduct=0x1042
[    1.701888] usb_match_id: id=c1e174c4 idVendor=0x499 idProduct=0x1043
[    1.702581] usb_match_id: id=c1e174dc idVendor=0x499 idProduct=0x1044
[    1.703357] usb_match_id: id=c1e174f4 idVendor=0x499 idProduct=0x1045
[    1.704111] usb_match_id: id=c1e1750c idVendor=0x499 idProduct=0x104e
[    1.704835] usb_match_id: id=c1e17524 idVendor=0x499 idProduct=0x104f
[    1.705547] usb_match_id: id=c1e1753c idVendor=0x499 idProduct=0x1050
[    1.706276] usb_match_id: id=c1e17554 idVendor=0x499 idProduct=0x1051
[    1.706996] usb_match_id: id=c1e1756c idVendor=0x499 idProduct=0x1052
[    1.707678] usb_match_id: id=c1e17584 idVendor=0x499 idProduct=0x1053
[    1.708454] usb_match_id: id=c1e1759c idVendor=0x499 idProduct=0x1054
[    1.709211] usb_match_id: id=c1e175b4 idVendor=0x499 idProduct=0x1055
[    1.709988] usb_match_id: id=c1e175cc idVendor=0x499 idProduct=0x1056
[    1.710679] usb_match_id: id=c1e175e4 idVendor=0x499 idProduct=0x1057
[    1.711406] usb_match_id: id=c1e175fc idVendor=0x499 idProduct=0x1058
[    1.712129] usb_match_id: id=c1e17614 idVendor=0x499 idProduct=0x1059
[    1.712820] usb_match_id: id=c1e1762c idVendor=0x499 idProduct=0x105a
[    1.713568] usb_match_id: id=c1e17644 idVendor=0x499 idProduct=0x105b
[    1.714290] usb_match_id: id=c1e1765c idVendor=0x499 idProduct=0x105c
[    1.715013] usb_match_id: id=c1e17674 idVendor=0x499 idProduct=0x105d
[    1.715698] usb_match_id: id=c1e1768c idVendor=0x499 idProduct=0x1503
[    1.716419] usb_match_id: id=c1e176a4 idVendor=0x499 idProduct=0x2000
[    1.717146] usb_match_id: id=c1e176bc idVendor=0x499 idProduct=0x2001
[    1.717845] usb_match_id: id=c1e176d4 idVendor=0x499 idProduct=0x2002
[    1.718558] usb_match_id: id=c1e176ec idVendor=0x499 idProduct=0x2003
[    1.719278] usb_match_id: id=c1e17704 idVendor=0x499 idProduct=0x5000
[    1.719997] usb_match_id: id=c1e1771c idVendor=0x499 idProduct=0x5001
[    1.720679] usb_match_id: id=c1e17734 idVendor=0x499 idProduct=0x5002
[    1.721398] usb_match_id: id=c1e1774c idVendor=0x499 idProduct=0x5003
[    1.722115] usb_match_id: id=c1e17764 idVendor=0x499 idProduct=0x5004
[    1.722810] usb_match_id: id=c1e1777c idVendor=0x499 idProduct=0x5005
[    1.723524] usb_match_id: id=c1e17794 idVendor=0x499 idProduct=0x5006
[    1.724246] usb_match_id: id=c1e177ac idVendor=0x499 idProduct=0x5007
[    1.724968] usb_match_id: id=c1e177c4 idVendor=0x499 idProduct=0x5008
[    1.725652] usb_match_id: id=c1e177dc idVendor=0x499 idProduct=0x5009
[    1.726372] usb_match_id: id=c1e177f4 idVendor=0x499 idProduct=0x500a
[    1.727098] usb_match_id: id=c1e1780c idVendor=0x499 idProduct=0x500b
[    1.727795] usb_match_id: id=c1e17824 idVendor=0x499 idProduct=0x500c
[    1.728506] usb_match_id: id=c1e1783c idVendor=0x499 idProduct=0x500d
[    1.729224] usb_match_id: id=c1e17854 idVendor=0x499 idProduct=0x500e
[    1.729939] usb_match_id: id=c1e1786c idVendor=0x499 idProduct=0x500f
[    1.730623] usb_match_id: id=c1e17884 idVendor=0x499 idProduct=0x7000
[    1.731342] usb_match_id: id=c1e1789c idVendor=0x499 idProduct=0x7010
[    1.732059] usb_match_id: id=c1e178b4 idVendor=0x582 idProduct=0x0
[    1.732720] usb_match_id: id=c1e178cc idVendor=0x582 idProduct=0x2
[    1.733411] usb_match_id: id=c1e178e4 idVendor=0x582 idProduct=0x3
[    1.734107] usb_match_id: id=c1e178fc idVendor=0x582 idProduct=0x4
[    1.734767] usb_match_id: id=c1e17914 idVendor=0x582 idProduct=0x5
[    1.735500] usb_match_id: id=c1e1792c idVendor=0x582 idProduct=0x7
[    1.736223] usb_match_id: id=c1e17944 idVendor=0x582 idProduct=0x8
[    1.736958] usb_match_id: id=c1e1795c idVendor=0x582 idProduct=0x9
[    1.737676] usb_match_id: id=c1e17974 idVendor=0x582 idProduct=0xb
[    1.738396] usb_match_id: id=c1e1798c idVendor=0x582 idProduct=0xc
[    1.739094] usb_match_id: id=c1e179a4 idVendor=0x582 idProduct=0x10
[    1.739812] usb_match_id: id=c1e179bc idVendor=0x582 idProduct=0x12
[    1.740534] usb_match_id: id=c1e179d4 idVendor=0x582 idProduct=0x14
[    1.741237] usb_match_id: id=c1e179ec idVendor=0x582 idProduct=0x16
[    1.741948] usb_match_id: id=c1e17a04 idVendor=0x582 idProduct=0x1b
[    1.742615] usb_match_id: id=c1e17a1c idVendor=0x582 idProduct=0x1d
[    1.743320] usb_match_id: id=c1e17a34 idVendor=0x582 idProduct=0x23
[    1.744018] usb_match_id: id=c1e17a4c idVendor=0x582 idProduct=0x25
[    1.744687] usb_match_id: id=c1e17a64 idVendor=0x582 idProduct=0x27
[    1.745388] usb_match_id: id=c1e17a7c idVendor=0x582 idProduct=0x29
[    1.746088] usb_match_id: id=c1e17a94 idVendor=0x582 idProduct=0x2b
[    1.746753] usb_match_id: id=c1e17aac idVendor=0x582 idProduct=0x2d
[    1.747447] usb_match_id: id=c1e17ac4 idVendor=0x582 idProduct=0x2f
[    1.748150] usb_match_id: id=c1e17adc idVendor=0x582 idProduct=0x33
[    1.748815] usb_match_id: id=c1e17af4 idVendor=0x582 idProduct=0x37
[    1.749511] usb_match_id: id=c1e17b0c idVendor=0x582 idProduct=0x3b
[    1.750215] usb_match_id: id=c1e17b24 idVendor=0x582 idProduct=0x40
[    1.750985] usb_match_id: id=c1e17b3c idVendor=0x582 idProduct=0x42
[    1.751687] usb_match_id: id=c1e17b54 idVendor=0x582 idProduct=0x47
[    1.752389] usb_match_id: id=c1e17b6c idVendor=0x582 idProduct=0x48
[    1.752686]  gadget: resume
[    1.752691] dummy_hcd dummy_hcd: port status 0x00100503 has changes
[    1.754091] usb_match_id: id=c1e17b84 idVendor=0x582 idProduct=0x4c
[    1.754762] usb_match_id: id=c1e17b9c idVendor=0x582 idProduct=0x4d
[    1.755457] usb_match_id: id=c1e17bb4 idVendor=0x582 idProduct=0x50
[    1.756163] usb_match_id: id=c1e17bcc idVendor=0x582 idProduct=0x52
[    1.756838] usb_match_id: id=c1e17be4 idVendor=0x582 idProduct=0x60
[    1.757533] usb_match_id: id=c1e17bfc idVendor=0x582 idProduct=0x64
[    1.758231] usb_match_id: id=c1e17c14 idVendor=0x582 idProduct=0x65
[    1.758931] usb_match_id: id=c1e17c2c idVendor=0x582 idProduct=0x6a
[    1.759605] usb_match_id: id=c1e17c44 idVendor=0x582 idProduct=0x6d
[    1.760302] usb_match_id: id=c1e17c5c idVendor=0x582 idProduct=0x74
[    1.761007] usb_match_id: id=c1e17c74 idVendor=0x582 idProduct=0x75
[    1.761676] usb_match_id: id=c1e17c8c idVendor=0x582 idProduct=0x7a
[    1.762377] usb_match_id: id=c1e17ca4 idVendor=0x582 idProduct=0x80
[    1.763081] usb_match_id: id=c1e17cbc idVendor=0x582 idProduct=0x8b
[    1.763746] usb_match_id: id=c1e17cd4 idVendor=0x582 idProduct=0x96
[    1.764439] usb_match_id: id=c1e17cec idVendor=0x582 idProduct=0x9a
[    1.765142] usb_match_id: id=c1e17d04 idVendor=0x582 idProduct=0xa3
[    1.765817] usb_match_id: id=c1e17d1c idVendor=0x582 idProduct=0xa6
[    1.766513] usb_match_id: id=c1e17d34 idVendor=0x582 idProduct=0xad
[    1.767218] usb_match_id: id=c1e17d4c idVendor=0x582 idProduct=0xc2
[    1.767922] usb_match_id: id=c1e17d64 idVendor=0x582 idProduct=0xc4
[    1.768589] usb_match_id: id=c1e17d7c idVendor=0x582 idProduct=0xda
[    1.769293] usb_match_id: id=c1e17d94 idVendor=0x582 idProduct=0xe6
[    1.769998] usb_match_id: id=c1e17dac idVendor=0x582 idProduct=0xe9
[    1.770674] usb_match_id: id=c1e17dc4 idVendor=0x582 idProduct=0x104
[    1.771390] usb_match_id: id=c1e17ddc idVendor=0x582 idProduct=0x108
[    1.772097] usb_match_id: id=c1e17df4 idVendor=0x582 idProduct=0x109
[    1.772774] usb_match_id: id=c1e17e0c idVendor=0x582 idProduct=0x10f
[    1.773476] usb_match_id: id=c1e17e24 idVendor=0x582 idProduct=0x111
[    1.774181] usb_match_id: id=c1e17e3c idVendor=0x582 idProduct=0x113
[    1.774860] usb_match_id: id=c1e17e54 idVendor=0x582 idProduct=0x127
[    1.775568] usb_match_id: id=c1e17e6c idVendor=0x582 idProduct=0x12a
[    1.776281] usb_match_id: id=c1e17e84 idVendor=0x582 idProduct=0x11e
[    1.776991] usb_match_id: id=c1e17e9c idVendor=0x582 idProduct=0x130
[    1.777663] usb_match_id: id=c1e17eb4 idVendor=0x582 idProduct=0x14d
[    1.778370] usb_match_id: id=c1e17ecc idVendor=0x6f8 idProduct=0xb000
[    1.779095] usb_match_id: id=c1e17ee4 idVendor=0x763 idProduct=0x1002
[    1.779784] usb_match_id: id=c1e17efc idVendor=0x763 idProduct=0x1011
[    1.780496] usb_match_id: id=c1e17f14 idVendor=0x763 idProduct=0x1015
[    1.781218] usb_match_id: id=c1e17f2c idVendor=0x763 idProduct=0x1021
[    1.781947] usb_match_id: id=c1e17f44 idVendor=0x763 idProduct=0x1031
[    1.782630] usb_match_id: id=c1e17f5c idVendor=0x763 idProduct=0x1033
[    1.783349] usb_match_id: id=c1e17f74 idVendor=0x763 idProduct=0x1041
[    1.784063] usb_match_id: id=c1e17f8c idVendor=0x763 idProduct=0x2001
[    1.784751] usb_match_id: id=c1e17fa4 idVendor=0x763 idProduct=0x2003
[    1.785466] usb_match_id: id=c1e17fbc idVendor=0x763 idProduct=0x2008
[    1.786182] usb_match_id: id=c1e17fd4 idVendor=0x763 idProduct=0x200d
[    1.786873] usb_match_id: id=c1e17fec idVendor=0x763 idProduct=0x2019
[    1.787591] usb_match_id: id=c1e18004 idVendor=0x763 idProduct=0x2080
[    1.788298] usb_match_id: id=c1e1801c idVendor=0x763 idProduct=0x2081
[    1.789016] usb_match_id: id=c1e18034 idVendor=0x7cf idProduct=0x6801
[    1.789694] usb_match_id: id=c1e1804c idVendor=0x7cf idProduct=0x6802
[    1.790415] usb_match_id: id=c1e18064 idVendor=0x7fd idProduct=0x1
[    1.791126] usb_match_id: id=c1e1807c idVendor=0x86a idProduct=0x1
[    1.791795] usb_match_id: id=c1e18094 idVendor=0x86a idProduct=0x2
[    1.792473] usb_match_id: id=c1e180ac idVendor=0x86a idProduct=0x3
[    1.793173] usb_match_id: id=c1e180c4 idVendor=0x944 idProduct=0x200
[    1.793853] usb_match_id: id=c1e180dc idVendor=0x944 idProduct=0x201
[    1.794554] usb_match_id: id=c1e180f4 idVendor=0x9e8 idProduct=0x62
[    1.795270] usb_match_id: id=c1e1810c idVendor=0xccd idProduct=0x12
[    1.795971] usb_match_id: id=c1e18124 idVendor=0xccd idProduct=0x13
[    1.796635] usb_match_id: id=c1e1813c idVendor=0xccd idProduct=0x14
[    1.797335] usb_match_id: id=c1e18154 idVendor=0xccd idProduct=0x28
[    1.798037] usb_match_id: id=c1e1816c idVendor=0xccd idProduct=0x35
[    1.798708] usb_match_id: id=c1e18184 idVendor=0x103d idProduct=0x100
[    1.799430] usb_match_id: id=c1e1819c idVendor=0x103d idProduct=0x101
[    1.800150] usb_match_id: id=c1e181b4 idVendor=0x1235 idProduct=0x1
[    1.800815] usb_match_id: id=c1e181cc idVendor=0x1235 idProduct=0x2
[    1.801504] usb_match_id: id=c1e181e4 idVendor=0x1235 idProduct=0xe
[    1.802208] usb_match_id: id=c1e181fc idVendor=0x1235 idProduct=0x4661
[    1.802930] usb_match_id: id=c1e18214 idVendor=0x133e idProduct=0x815
[    1.803619] usb_match_id: id=c1e1822c idVendor=0x13e5 idProduct=0x1
[    1.803688] usb 1-1: new high-speed USB device number 2 using dummy_hcd
[    1.805040] usb_match_id: id=c1e18244 idVendor=0x17cc idProduct=0x1000
[    1.805737] usb_match_id: id=c1e1825c idVendor=0x17cc idProduct=0x1010
[    1.806462] usb_match_id: id=c1e18274 idVendor=0x17cc idProduct=0x1020
[    1.807190] usb_match_id: id=c1e1828c idVendor=0x1f38 idProduct=0x1
[    1.807865] usb_match_id: id=c1e182a4 idVendor=0x4752 idProduct=0x11
[    1.808568] usb_match_id: id=c1e182bc idVendor=0x7104 idProduct=0x2202
[    1.809296] usb_match_id: id=c1e182d4 idVendor=0x2040 idProduct=0x7200
[    1.810029] usb_match_id: id=c1e182ec idVendor=0x2040 idProduct=0x7240
[    1.810720] usb_match_id: id=c1e18304 idVendor=0x2040 idProduct=0x7210
[    1.811455] usb_match_id: id=c1e1831c idVendor=0x2040 idProduct=0x7217
[    1.812181] usb_match_id: id=c1e18334 idVendor=0x2040 idProduct=0x721b
[    1.812878] usb_match_id: id=c1e1834c idVendor=0x2040 idProduct=0x721e
[    1.813605] usb_match_id: id=c1e18364 idVendor=0x2040 idProduct=0x721f
[    1.814333] usb_match_id: id=c1e1837c idVendor=0x2040 idProduct=0x7280
[    1.815068] usb_match_id: id=c1e18394 idVendor=0xfd9 idProduct=0x8
[    1.815730] usb_match_id: id=c1e183ac idVendor=0xdba idProduct=0x1000
[    1.816446] usb_match_id: id=c1e183c4 idVendor=0x0 idProduct=0x0
[    1.817130] usb_match_id: id=c1e183dc idVendor=0x0 idProduct=0x0
[    1.817788] usbcore: registered new interface driver snd-usb-audio
[    1.818496] usb_device_match: device 1-0:1.0, driver snd-ua101 
[    1.819167] usb_match_id: id=c1e1d12c idVendor=0x582 idProduct=0x44
[    1.819846] usb_match_id: id=c1e1d144 idVendor=0x582 idProduct=0x7d
[    1.820540] usb_match_id: id=c1e1d15c idVendor=0x582 idProduct=0x8d
[    1.821248] usbcore: registered new interface driver snd-ua101
[    1.821909] usb_device_match: device 1-0:1.0, driver snd-usb-usx2y 
[    1.822613] usb_match_id: id=c1e1d944 idVendor=0x1604 idProduct=0x8001
[    1.823342] usb_match_id: id=c1e1d95c idVendor=0x1604 idProduct=0x8007
[    1.824075] usb_match_id: id=c1e1d974 idVendor=0x1604 idProduct=0x8005
[    1.824772] usbcore: registered new interface driver snd-usb-usx2y
[    1.825478] usb_device_match: device 1-0:1.0, driver snd-usb-caiaq 
[    1.826183] usb_match_id: id=c1e1e654 idVendor=0x17cc idProduct=0x1969
[    1.826881] usb_match_id: id=c1e1e66c idVendor=0x17cc idProduct=0x1940
[    1.827595] usb_match_id: id=c1e1e684 idVendor=0x17cc idProduct=0x4711
[    1.828367] usb_match_id: id=c1e1e69c idVendor=0x17cc idProduct=0x4712
[    1.829118] usb_match_id: id=c1e1e6b4 idVendor=0x17cc idProduct=0x815
[    1.829811] usb_match_id: id=c1e1e6cc idVendor=0x17cc idProduct=0x1978
[    1.830535] usb_match_id: id=c1e1e6e4 idVendor=0x17cc idProduct=0x1915
[    1.831269] usb_match_id: id=c1e1e6fc idVendor=0x17cc idProduct=0xd8d
[    1.832022] usb_match_id: id=c1e1e714 idVendor=0x17cc idProduct=0x839
[    1.832751] usb_match_id: id=c1e1e72c idVendor=0x17cc idProduct=0x41c
[    1.833461] usb_match_id: id=c1e1e744 idVendor=0x17cc idProduct=0x2305
[    1.834192] usb_match_id: id=c1e1e75c idVendor=0x17cc idProduct=0xbaff
[    1.834928] usb_match_id: id=c1e1e774 idVendor=0x17cc idProduct=0x41d
[    1.835645] usb_match_id: id=c1e1e78c idVendor=0x17cc idProduct=0x808
[    1.836438] usbcore: registered new interface driver snd-usb-caiaq
[    1.837193] NET: Registered protocol family 26
[    1.837757] netem: version 1.3
[    1.838180] NET: Registered protocol family 17
[    1.841518] NET: Registered protocol family 11
[    1.842139] NET: Registered protocol family 3
[    1.842626] can: controller area network core (rev 20120528 abi 9)
[    1.843369] can: failed to create /proc/net/can . CONFIG_PROC_FS missing?
[    1.844130] NET: Registered protocol family 29
[    1.844612] can: broadcast manager protocol (rev 20120528 t)
[    1.845246] can: netlink gateway (rev 20101209)
[    1.845778] IrCOMM protocol (Dag Brattli)
[    1.846751] Bluetooth: RFCOMM TTY layer initialized
[    1.847316] Bluetooth: RFCOMM socket layer initialized
[    1.847935] Bluetooth: RFCOMM ver 1.11
[    1.848344] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    1.848945] Bluetooth: BNEP filters: protocol multicast
[    1.849508] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    1.850177] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[    1.851181] DECnet: Routing cache hash table of 1024 buckets, 8Kbytes
[    1.851909] NET: Registered protocol family 12
[    1.852398] 8021q: 802.1Q VLAN Support v1.8
[    1.852869] lib80211: common routines for IEEE802.11 drivers
[    1.853504] lib80211_crypt: registered algorithm 'NULL'
[    1.854098] lib80211_crypt: registered algorithm 'WEP'
[    1.854652] lib80211_crypt: registered algorithm 'CCMP'
[    1.855246] lib80211_crypt: registered algorithm 'TKIP'
[    1.855707]  gadget: resume
[    1.855712] dummy_hcd dummy_hcd: port status 0x00100503 has changes
[    1.856840] Key type dns_resolver registered
[    1.857469] batman_adv: B.A.T.M.A.N. advanced 2012.3.0 (compatibility version 14) loaded
[    1.859032] 
[    1.859032] printing PIC contents
[    1.859559] ... PIC  IMR: ffff
[    1.859778] ... PIC  IRR: 1113
[    1.860268] ... PIC  ISR: 0000
[    1.860604] ... PIC ELCR: 0c00
[    1.861002] printing local APIC contents on CPU#0/0:
[    1.861642] ... APIC ID:      00000000 (0)
[    1.861642] ... APIC VERSION: 00050014
[    1.861642] ... APIC TASKPRI: 00000000 (00)
[    1.861642] ... APIC PROCPRI: 00000000
[    1.861642] ... APIC LDR: 01000000
[    1.861642] ... APIC DFR: ffffffff
[    1.861642] ... APIC SPIV: 000001ff
[    1.861642] ... APIC ISR field:
[    1.861642] 0000000000000000000000000000000000000000000000000000000000000000
[    1.861642] ... APIC TMR field:
[    1.861642] 0000000000000000000000000000000000000000000000000000000000000000
[    1.861642] ... APIC IRR field:
[    1.861642] 0000000000000000000000000000000000000000000000000000000000008000
[    1.861642] ... APIC ESR: 00000000
[    1.861642] ... APIC ICR: 000008fd
[    1.861642] ... APIC ICR2: 02000000
[    1.861642] ... APIC LVTT: 000200ef
[    1.861642] ... APIC LVTPC: 00010000
[    1.861642] ... APIC LVT0: 00010700
[    1.861642] ... APIC LVT1: 00000400
[    1.861642] ... APIC LVTERR: 000000fe
[    1.861642] ... APIC TMICT: 0000f41e
[    1.861642] ... APIC TMCCT: 000065a8
[    1.861642] ... APIC TDCR: 00000003
[    1.861642] 
[    1.876188] number of MP IRQ sources: 15.
[    1.876630] number of IO-APIC #2 registers: 24.
[    1.877165] testing the IO APIC.......................
[    1.877734] IO APIC #2......
[    1.878084] .... register #00: 00000000
[    1.878499] .......    : physical APIC id: 00
[    1.879021] .......    : Delivery Type: 0
[    1.879452] .......    : LTS          : 0
[    1.879958] .... register #01: 00170011
[    1.880372] .......     : max redirection entries: 17
[    1.880949] .......     : PRQ implemented: 0
[    1.881405] .......     : IO APIC version: 11
[    1.881877] .... register #02: 00000000
[    1.882335] .......     : arbitration: 00
[    1.882769] .... IRQ redirection table:
[    1.883219]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    1.883855]  00 00  1    0    0   0   0    0    0    00
[    1.884511]  01 03  0    0    0   0   0    1    1    41
[    1.885123]  02 03  0    0    0   0   0    1    1    51
[    1.885724]  03 01  0    0    0   0   0    1    1    61
[    1.886343]  04 01  1    0    0   0   0    1    1    71
[    1.886966]  05 01  1    1    0   0   0    1    1    81
[    1.887564]  06 01  0    0    0   0   0    1    1    91
[    1.888210]  07 01  0    0    0   0   0    1    1    A1
[    1.888803]  08 01  0    0    0   0   0    1    1    B1
[    1.889426]  09 01  0    1    0   0   0    1    1    C1
[    1.890047]  0a 01  1    1    0   0   0    1    1    D1
[    1.890631]  0b 01  1    1    0   0   0    1    1    E1
[    1.891247]  0c 03  0    0    0   0   0    1    1    22
[    1.891877]  0d 01  0    0    0   0   0    1    1    42
[    1.892575]  0e 01  0    0    0   0   0    1    1    52
[    1.893219]  0f 01  0    0    0   0   0    1    1    62
[    1.893846]  10 00  1    0    0   0   0    0    0    00
[    1.894487]  11 00  1    0    0   0   0    0    0    00
[    1.895121]  12 00  1    0    0   0   0    0    0    00
[    1.895752]  13 00  1    0    0   0   0    0    0    00
[    1.896370]  14 00  1    0    0   0   0    0    0    00
[    1.896986]  15 00  1    0    0   0   0    0    0    00
[    1.897581]  16 00  1    0    0   0   0    0    0    00
[    1.898236]  17 00  1    0    0   0   0    0    0    00
[    1.898840] IRQ to pin mappings:
[    1.899258] IRQ0 -> 0:2
[    1.899604] IRQ1 -> 0:1
[    1.899930] IRQ3 -> 0:3
[    1.900227] IRQ4 -> 0:4
[    1.900523] IRQ5 -> 0:5
[    1.900832] IRQ6 -> 0:6
[    1.901159] IRQ7 -> 0:7
[    1.901458] IRQ8 -> 0:8
[    1.901756] IRQ9 -> 0:9
[    1.902088] IRQ10 -> 0:10
[    1.902421] IRQ11 -> 0:11
[    1.902741] IRQ12 -> 0:12
[    1.903098] IRQ13 -> 0:13
[    1.903420] IRQ14 -> 0:14
[    1.903783] IRQ15 -> 0:15
[    1.904124] .................................... done.
[    1.904725] Using IPI Shortcut mode
[    1.905277] registered taskstats version 1
[    1.905974] Key type encrypted registered
[    1.906562] IMA: No TPM chip found, activating TPM-bypass!
[    1.907742] dmaengine: __dma_request_channel: fail ((null))
[    1.908569] rtc_cmos 00:01: setting system clock to 2012-08-17 05:14:41 UTC (1345180481)
[ 2200.432808] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[ 2200.433509] EDD information not available.
[ 2200.433963] ALSA device list:
[ 2200.434327]   No soundcards found.
[ 2200.435101] debug: unmapping init [mem 0xc1e66000-0xc1fa9fff]
[ 2200.436073] Write protecting the kernel text: 10152k
[ 2200.436706] Write protecting the kernel read-only data: 2220k
[ 2200.443893] dummy_udc dummy_udc: set_address = 2
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
[ 2200.465890]  gadget: high-speed config #1: CDC Ethernet (ECM)
[ 2200.466880] dummy_udc dummy_udc: enabled ep-c (ep3in-intr) maxpacket 16 stream disabled
[ 2200.466880]  gadget: init ecm
[ 2200.466880]  gadget: notify connect false
[ 2200.466880]  gadget: notify speed 425984000
[ 2200.469903] usb_device_match: device 1-1:1.0, driver usbfs 
[ 2200.470602] usb_device_match: device 1-1:1.0, driver hub 
[ 2200.471285] usb_match_id: id=c1a87214 idVendor=0x0 idProduct=0x0
[ 2200.471985] usb_match_id: id=c1a8722c idVendor=0x0 idProduct=0x0
[ 2200.472727] usb_device_match: device 1-1:1.0, driver udlfb 
[ 2200.473423] usb_match_id: id=c1ccbc68 idVendor=0x17e9 idProduct=0x0
[ 2200.474180] usb_device_match: device 1-1:1.0, driver smscufx 
[ 2200.474834] usb_match_id: id=c1ccc5dc idVendor=0x424 idProduct=0x9d00
[ 2200.475646] usb_match_id: id=c1ccc5f4 idVendor=0x424 idProduct=0x9d01
[ 2200.476453] usb_device_match: device 1-1:1.0, driver alauda 
[ 2200.477132] usb_match_id: id=c1a810a4 idVendor=0x584 idProduct=0x8
[ 2200.477874] usb_match_id: id=c1a810bc idVendor=0x7b4 idProduct=0x10a
[ 2200.478668] usb_device_match: device 1-1:1.0, driver kaweth 
[ 2200.479390] usb_match_id: id=c1d1e1e4 idVendor=0x3e8 idProduct=0x8
[ 2200.480083] usb_match_id: id=c1d1e1fc idVendor=0x4bb idProduct=0x901
[ 2200.480792] usb_match_id: id=c1d1e214 idVendor=0x506 idProduct=0x3e8
[ 2200.481539] usb_match_id: id=c1d1e22c idVendor=0x506 idProduct=0x11f8
[ 2200.482309] usb_match_id: id=c1d1e244 idVendor=0x557 idProduct=0x2002
[ 2200.483014] usb_match_id: id=c1d1e25c idVendor=0x557 idProduct=0x4000
[ 2200.483744] usb_match_id: id=c1d1e274 idVendor=0x565 idProduct=0x2
[ 2200.484455] usb_match_id: id=c1d1e28c idVendor=0x565 idProduct=0x3
[ 2200.485160] usb_match_id: id=c1d1e2a4 idVendor=0x565 idProduct=0x5
[ 2200.485896] usb_match_id: id=c1d1e2bc idVendor=0x5e9 idProduct=0x8
[ 2200.486649] usb_match_id: id=c1d1e2d4 idVendor=0x5e9 idProduct=0x9
[ 2200.487447] usb_match_id: id=c1d1e2ec idVendor=0x66b idProduct=0x2202
[ 2200.488250] usb_match_id: id=c1d1e304 idVendor=0x6e1 idProduct=0x8
[ 2200.489085] usb_match_id: id=c1d1e31c idVendor=0x6e1 idProduct=0x9
[ 2200.489829] usb_match_id: id=c1d1e334 idVendor=0x707 idProduct=0x100
[ 2200.490611] usb_match_id: id=c1d1e34c idVendor=0x7aa idProduct=0x1
[ 2200.491356] usb_match_id: id=c1d1e364 idVendor=0x7b8 idProduct=0x4000
[ 2200.492185] usb_match_id: id=c1d1e37c idVendor=0x7c9 idProduct=0xb010
[ 2200.492930] usb_match_id: id=c1d1e394 idVendor=0x846 idProduct=0x1001
[ 2200.493865] usb_match_id: id=c1d1e3ac idVendor=0x846 idProduct=0x1002
[ 2200.494820] usb_match_id: id=c1d1e3c4 idVendor=0x85a idProduct=0x8
[ 2200.495615] usb_match_id: id=c1d1e3dc idVendor=0x85a idProduct=0x9
[ 2200.496419] usb_match_id: id=c1d1e3f4 idVendor=0x87d idProduct=0x5704
[ 2200.497282] usb_match_id: id=c1d1e40c idVendor=0x951 idProduct=0x8
[ 2200.498048] usb_match_id: id=c1d1e424 idVendor=0x95a idProduct=0x3003
[ 2200.498782] usb_match_id: id=c1d1e43c idVendor=0x10bd idProduct=0x1427
[ 2200.499576] usb_match_id: id=c1d1e454 idVendor=0x1342 idProduct=0x204
[ 2200.500357] usb_match_id: id=c1d1e46c idVendor=0x13d2 idProduct=0x400
[ 2200.501185] usb_match_id: id=c1d1e484 idVendor=0x1485 idProduct=0x1
[ 2200.501864] usb_match_id: id=c1d1e49c idVendor=0x1485 idProduct=0x2
[ 2200.502780] usb_match_id: id=c1d1e4b4 idVendor=0x1645 idProduct=0x5
[ 2200.503694] usb_match_id: id=c1d1e4cc idVendor=0x1645 idProduct=0x8
[ 2200.504588] usb_match_id: id=c1d1e4e4 idVendor=0x1645 idProduct=0x8005
[ 2200.505462] usb_match_id: id=c1d1e4fc idVendor=0x1668 idProduct=0x323
[ 2200.506312] usb_match_id: id=c1d1e514 idVendor=0x2001 idProduct=0x4000
[ 2200.507188] usb_device_match: device 1-1:1.0, driver pegasus 
[ 2200.507881] usb_match_id: id=c1d1ebd8 idVendor=0x506 idProduct=0x4601
[ 2200.508719] usb_match_id: id=c1d1ebf0 idVendor=0x557 idProduct=0x2007
[ 2200.509478] usb_match_id: id=c1d1ec08 idVendor=0x7b8 idProduct=0x110c
[ 2200.510222] usb_match_id: id=c1d1ec20 idVendor=0x7b8 idProduct=0x4104
[ 2200.510926] usb_match_id: id=c1d1ec38 idVendor=0x7b8 idProduct=0x4004
[ 2200.511681] usb_match_id: id=c1d1ec50 idVendor=0x7b8 idProduct=0x4007
/bin/sh: /proc/s[ 2200.512438] usb_match_id: id=c1d1ec68 idVendor=0x7b8 idProduct=0x4102
elf/fd/9: No suc[ 2200.513349] usb_match_id: id=c1d1ec80 idVendor=0x7b8 idProduct=0x4002
h file or direct[ 2200.514297] usb_match_id: id=c1d1ec98 idVendor=0x7b8 idProduct=0x400b
ory[ 2200.515236] usb_match_id: id=c1d1ecb0 idVendor=0x7b8 idProduct=0x400c

[ 2200.516032] usb_match_id: id=c1d1ecc8 idVendor=0x7b8 idProduct=0xabc1
[ 2200.516753] usb_match_id: id=c1d1ece0 idVendor=0x7b8 idProduct=0x200c
[ 2200.517496] usb_match_id: id=c1d1ecf8 idVendor=0x83a idProduct=0x1046
[ 2200.518285] usb_match_id: id=c1d1ed10 idVendor=0x83a idProduct=0x5046
[ 2200.518994] usb_match_id: id=c1d1ed28 idVendor=0x83a idProduct=0xb004
[ 2200.519729] usb_match_id: id=c1d1ed40 idVendor=0x7a6 idProduct=0x8511
[ 2200.520524] usb_match_id: id=c1d1ed58 idVendor=0x7a6 idProduct=0x8513
[ 2200.521252] usb_match_id: id=c1d1ed70 idVendor=0x7a6 idProduct=0x8515
[ 2200.521948] usb_match_id: id=c1d1ed88 idVendor=0x7a6 idProduct=0x986
[ 2200.522938] usb_match_id: id=c1d1eda0 idVendor=0x7a6 idProduct=0x7c2
[ 2200.523980] usb_match_id: id=c1d1edb8 idVendor=0x3334 idProduct=0x1701
[ 2200.525067] usb_match_id: id=c1d1edd0 idVendor=0x7c9 idProduct=0xb100
[ 2200.526136] usb_match_id: id=c1d1ede8 idVendor=0x50d idProduct=0x121
[ 2200.527000] usb_match_id: id=c1d1ee00 idVendor=0x50d idProduct=0x122
[ 2200.527726] usb_match_id: id=c1d1ee18 idVendor=0x8dd idProduct=0x986
[ 2200.528438] usb_match_id: id=c1d1ee30 idVendor=0x8dd idProduct=0x987
[ 2200.529124] usb_match_id: id=c1d1ee48 idVendor=0x49f idProduct=0x8511
[ 2200.529835] usb_match_id: id=c1d1ee60 idVendor=0x8dd idProduct=0x988
[ 2200.530566] usb_match_id: id=c1d1ee78 idVendor=0x8dd idProduct=0x8511
[ 2200.531295] usb_match_id: id=c1d1ee90 idVendor=0x7aa idProduct=0x4
[ 2200.531962] usb_match_id: id=c1d1eea8 idVendor=0x7aa idProduct=0xd
[ 2200.532773] usb_match_id: id=c1d1eec0 idVendor=0x2001 idProduct=0x4001
[ 2200.533816] usb_match_id: id=c1d1eed8 idVendor=0x2001 idProduct=0x4002
[ 2200.534919] usb_match_id: id=c1d1eef0 idVendor=0x2001 idProduct=0x4102
[ 2200.535986] usb_match_id: id=c1d1ef08 idVendor=0x2001 idProduct=0x400b
[ 2200.536818] usb_match_id: id=c1d1ef20 idVendor=0x2001 idProduct=0x200c
[ 2200.537552] usb_match_id: id=c1d1ef38 idVendor=0x2001 idProduct=0x4003
[ 2200.538311] usb_match_id: id=c1d1ef50 idVendor=0x2001 idProduct=0xabc1
[ 2200.539031] usb_match_id: id=c1d1ef68 idVendor=0xdb7 idProduct=0x2
[ 2200.539706] usb_match_id: id=c1d1ef80 idVendor=0x56e idProduct=0x4010
[ 2200.540560] usb_match_id: id=c1d1ef98 idVendor=0x1342 idProduct=0x304
[ 2200.541276] usb_match_id: id=c1d1efb0 idVendor=0x5cc idProduct=0x3000
[ 2200.542019] usb_match_id: id=c1d1efc8 idVendor=0x1044 idProduct=0x8002
[ 2200.542738] usb_match_id: id=c1d1efe0 idVendor=0xe66 idProduct=0x400c
[ 2200.543445] usb_match_id: id=c1d1eff8 idVendor=0x3f0 idProduct=0x811c
[ 2200.544155] usb_match_id: id=c1d1f010 idVendor=0x4bb idProduct=0x904
[ 2200.544836] usb_match_id: id=c1d1f028 idVendor=0x4bb idProduct=0x913
[ 2200.545543] usb_match_id: id=c1d1f040 idVendor=0x4bb idProduct=0x93a
[ 2200.546335] usb_match_id: id=c1d1f058 idVendor=0x951 idProduct=0xa
[ 2200.547181] usb_match_id: id=c1d1f070 idVendor=0x56e idProduct=0x4002
[ 2200.547920] usb_match_id: id=c1d1f088 idVendor=0x56e idProduct=0x4005
[ 2200.548625] usb_match_id: id=c1d1f0a0 idVendor=0x56e idProduct=0x400b
[ 2200.549334] usb_match_id: id=c1d1f0b8 idVendor=0x56e idProduct=0xabc1
[ 2200.550080] usb_match_id: id=c1d1f0d0 idVendor=0x56e idProduct=0x200c
[ 2200.550792] usb_match_id: id=c1d1f0e8 idVendor=0x66b idProduct=0x2202
[ 2200.551502] usb_match_id: id=c1d1f100 idVendor=0x66b idProduct=0x2203
[ 2200.552219] usb_match_id: id=c1d1f118 idVendor=0x66b idProduct=0x2204
[ 2200.552916] usb_match_id: id=c1d1f130 idVendor=0x66b idProduct=0x2206
[ 2200.553755] usb_match_id: id=c1d1f148 idVendor=0x77b idProduct=0x8b4
[ 2200.554502] usb_match_id: id=c1d1f160 idVendor=0x66b idProduct=0x400b
[ 2200.555217] usb_match_id: id=c1d1f178 idVendor=0x66b idProduct=0x200c
[ 2200.555922] usb_match_id: id=c1d1f190 idVendor=0x411 idProduct=0x1
[ 2200.556636] usb_match_id: id=c1d1f1a8 idVendor=0x411 idProduct=0x5
[ 2200.557321] usb_match_id: id=c1d1f1c0 idVendor=0x411 idProduct=0x9
[ 2200.558019] usb_match_id: id=c1d1f1d8 idVendor=0x45e idProduct=0x7a
[ 2200.558706] usb_match_id: id=c1d1f1f0 idVendor=0x846 idProduct=0x1020
[ 2200.559427] usb_match_id: id=c1d1f208 idVendor=0xb39 idProduct=0x109
[ 2200.560175] usb_match_id: id=c1d1f220 idVendor=0xb39 idProduct=0x901
[ 2200.561009] usb_match_id: id=c1d1f238 idVendor=0x8d1 idProduct=0x3
[ 2200.561681] usb_match_id: id=c1d1f250 idVendor=0x707 idProduct=0x200
[ 2200.562444] usb_match_id: id=c1d1f268 idVendor=0x707 idProduct=0x201
[ 2200.563127] usb_match_id: id=c1d1f280 idVendor=0x15e8 idProduct=0x9100
[ 2200.563836] usb_match_id: id=c1d1f298 idVendor=0x15e8 idProduct=0x9110
[ 2200.564549] usb_match_id: id=c1d1f2b0 idVendor=0x67c idProduct=0x1001
[ 2200.565262] usb_device_match: device 1-1:1.0, driver hso 
[ 2200.565885] usb_match_id: id=c1a84c64 idVendor=0xaf0 idProduct=0x6711
[ 2200.566640] usb_match_id: id=c1a84c7c idVendor=0xaf0 idProduct=0x6731
[ 2200.567420] usb_match_id: id=c1a84c94 idVendor=0xaf0 idProduct=0x6751
[ 2200.568204] usb_match_id: id=c1a84cac idVendor=0xaf0 idProduct=0x6771
[ 2200.568914] usb_match_id: id=c1a84cc4 idVendor=0xaf0 idProduct=0x6791
[ 2200.569620] usb_match_id: id=c1a84cdc idVendor=0xaf0 idProduct=0x6811
[ 2200.570385] usb_match_id: id=c1a84cf4 idVendor=0xaf0 idProduct=0x6911
[ 2200.571081] usb_match_id: id=c1a84d0c idVendor=0xaf0 idProduct=0x6951
[ 2200.571803] usb_match_id: id=c1a84d24 idVendor=0xaf0 idProduct=0x6971
[ 2200.572544] usb_match_id: id=c1a84d3c idVendor=0xaf0 idProduct=0x7011
[ 2200.573265] usb_match_id: id=c1a84d54 idVendor=0xaf0 idProduct=0x7031
[ 2200.573989] usb_match_id: id=c1a84d6c idVendor=0xaf0 idProduct=0x7051
[ 2200.574824] usb_match_id: id=c1a84d84 idVendor=0xaf0 idProduct=0x7071
[ 2200.575543] usb_match_id: id=c1a84d9c idVendor=0xaf0 idProduct=0x7111
[ 2200.576314] usb_match_id: id=c1a84db4 idVendor=0xaf0 idProduct=0x7211
[ 2200.577012] usb_match_id: id=c1a84dcc idVendor=0xaf0 idProduct=0x7251
[ 2200.577715] usb_match_id: id=c1a84de4 idVendor=0xaf0 idProduct=0x7271
[ 2200.578467] usb_match_id: id=c1a84dfc idVendor=0xaf0 idProduct=0x7311
[ 2200.579210] usb_match_id: id=c1a84e14 idVendor=0xaf0 idProduct=0xc031
[ 2200.579903] usb_match_id: id=c1a84e2c idVendor=0xaf0 idProduct=0xd013
[ 2200.580604] usb_match_id: id=c1a84e44 idVendor=0xaf0 idProduct=0xd031
[ 2200.581457] usb_match_id: id=c1a84e5c idVendor=0xaf0 idProduct=0xd033
[ 2200.582217] usb_match_id: id=c1a84e74 idVendor=0xaf0 idProduct=0x7301
[ 2200.582922] usb_match_id: id=c1a84e8c idVendor=0xaf0 idProduct=0x7361
[ 2200.583629] usb_match_id: id=c1a84ea4 idVendor=0xaf0 idProduct=0x7381
[ 2200.584386] usb_match_id: id=c1a84ebc idVendor=0xaf0 idProduct=0x7401
[ 2200.585084] usb_match_id: id=c1a84ed4 idVendor=0xaf0 idProduct=0x7501
[ 2200.585783] usb_match_id: id=c1a84eec idVendor=0xaf0 idProduct=0x7601
[ 2200.586586] usb_match_id: id=c1a84f04 idVendor=0xaf0 idProduct=0x7701
[ 2200.587310] usb_match_id: id=c1a84f1c idVendor=0xaf0 idProduct=0x7706
[ 2200.588136] usb_match_id: id=c1a84f34 idVendor=0xaf0 idProduct=0x7801
[ 2200.588841] usb_match_id: id=c1a84f4c idVendor=0xaf0 idProduct=0x7901
[ 2200.589552] usb_match_id: id=c1a84f64 idVendor=0xaf0 idProduct=0x7a01
[ 2200.590316] usb_match_id: id=c1a84f7c idVendor=0xaf0 idProduct=0x7a05
[ 2200.591108] usb_match_id: id=c1a84f94 idVendor=0xaf0 idProduct=0x8200
[ 2200.591814] usb_match_id: id=c1a84fac idVendor=0xaf0 idProduct=0x8201
[ 2200.592527] usb_match_id: id=c1a84fc4 idVendor=0xaf0 idProduct=0x8300
[ 2200.593238] usb_match_id: id=c1a84fdc idVendor=0xaf0 idProduct=0x8302
[ 2200.593969] usb_match_id: id=c1a84ff4 idVendor=0xaf0 idProduct=0x8304
[ 2200.594685] usb_match_id: id=c1a8500c idVendor=0xaf0 idProduct=0x8400
[ 2200.595534] usb_match_id: id=c1a85024 idVendor=0xaf0 idProduct=0x8600
[ 2200.596344] usb_match_id: id=c1a8503c idVendor=0xaf0 idProduct=0x8800
[ 2200.597040] usb_match_id: id=c1a85054 idVendor=0xaf0 idProduct=0x8900
[ 2200.597887] usb_match_id: id=c1a8506c idVendor=0xaf0 idProduct=0x9000
[ 2200.598605] usb_match_id: id=c1a85084 idVendor=0xaf0 idProduct=0xd035
[ 2200.599319] usb_match_id: id=c1a8509c idVendor=0xaf0 idProduct=0xd055
[ 2200.600013] usb_match_id: id=c1a850b4 idVendor=0xaf0 idProduct=0xd155
[ 2200.600714] usb_match_id: id=c1a850cc idVendor=0xaf0 idProduct=0xd255
[ 2200.601516] usb_match_id: id=c1a850e4 idVendor=0xaf0 idProduct=0xd057
[ 2200.602339] usb_match_id: id=c1a850fc idVendor=0xaf0 idProduct=0xd157
[ 2200.603036] usb_match_id: id=c1a85114 idVendor=0xaf0 idProduct=0xd257
[ 2200.603761] usb_match_id: id=c1a8512c idVendor=0xaf0 idProduct=0xd357
[ 2200.604471] usb_match_id: id=c1a85144 idVendor=0xaf0 idProduct=0xd058
[ 2200.605182] usb_match_id: id=c1a8515c idVendor=0xaf0 idProduct=0xc100
[ 2200.605923] usb_device_match: device 1-1:1.0, driver asix 
[ 2200.606565] usb_match_id: id=c1a85594 idVendor=0x77b idProduct=0x2226
[ 2200.607292] usb_match_id: id=c1a855ac idVendor=0x846 idProduct=0x1040
[ 2200.608031] usb_match_id: id=c1a855c4 idVendor=0x2001 idProduct=0x1a00
[ 2200.608933] usb_match_id: id=c1a855dc idVendor=0xb95 idProduct=0x1720
[ 2200.609741] usb_match_id: id=c1a855f4 idVendor=0x7b8 idProduct=0x420a
[ 2200.610506] usb_match_id: id=c1a8560c idVendor=0x8dd idProduct=0x90ff
[ 2200.611221] usb_match_id: id=c1a85624 idVendor=0x557 idProduct=0x2009
[ 2200.611918] usb_match_id: id=c1a8563c idVendor=0x411 idProduct=0x3d
[ 2200.612609] usb_match_id: id=c1a85654 idVendor=0x411 idProduct=0x6e
[ 2200.613310] usb_match_id: id=c1a8566c idVendor=0x6189 idProduct=0x182d
[ 2200.614059] usb_match_id: id=c1a85684 idVendor=0xdf6 idProduct=0x56
[ 2200.614753] usb_match_id: id=c1a8569c idVendor=0x7aa idProduct=0x17
[ 2200.615509] usb_match_id: id=c1a856b4 idVendor=0x1189 idProduct=0x893
[ 2200.616389] usb_match_id: id=c1a856cc idVendor=0x1631 idProduct=0x6200
[ 2200.617095] usb_match_id: id=c1a856e4 idVendor=0x4f1 idProduct=0x3008
[ 2200.617807] usb_match_id: id=c1a856fc idVendor=0xb95 idProduct=0x772b
[ 2200.618561] usb_match_id: id=c1a85714 idVendor=0xb95 idProduct=0x7720
[ 2200.619277] usb_match_id: id=c1a8572c idVendor=0xb95 idProduct=0x1780
[ 2200.620016] usb_match_id: id=c1a85744 idVendor=0x789 idProduct=0x160
[ 2200.620714] usb_match_id: id=c1a8575c idVendor=0x13b1 idProduct=0x18
[ 2200.621419] usb_match_id: id=c1a85774 idVendor=0x1557 idProduct=0x7720
[ 2200.622169] usb_match_id: id=c1a8578c idVendor=0x7d1 idProduct=0x3c05
[ 2200.622994] usb_match_id: id=c1a857a4 idVendor=0x2001 idProduct=0x3c05
[ 2200.623708] usb_match_id: id=c1a857bc idVendor=0x1737 idProduct=0x39
[ 2200.624412] usb_match_id: id=c1a857d4 idVendor=0x4bb idProduct=0x930
[ 2200.625095] usb_match_id: id=c1a857ec idVendor=0x50d idProduct=0x5055
[ 2200.625808] usb_match_id: id=c1a85804 idVendor=0x5ac idProduct=0x1402
[ 2200.626602] usb_match_id: id=c1a8581c idVendor=0xb95 idProduct=0x772a
[ 2200.627318] usb_match_id: id=c1a85834 idVendor=0x14ea idProduct=0xab11
[ 2200.628032] usb_match_id: id=c1a8584c idVendor=0xdb0 idProduct=0xa877
[ 2200.628736] usb_match_id: id=c1a85864 idVendor=0xb95 idProduct=0x7e2b
[ 2200.629580] usb_match_id: id=c1a8587c idVendor=0xb95 idProduct=0x172a
[ 2200.630384] usb_device_match: device 1-1:1.0, driver MOSCHIP usb-ethernet driver 
[ 2200.631223] usb_match_id: id=c1a85d5c idVendor=0x9710 idProduct=0x7832
[ 2200.631971] usb_match_id: id=c1a85d74 idVendor=0x9710 idProduct=0x7830
[ 2200.632706] usb_match_id: id=c1a85d8c idVendor=0x9710 idProduct=0x7730
[ 2200.633441] usb_match_id: id=c1a85da4 idVendor=0xdf6 idProduct=0x21
[ 2200.634184] usb_device_match: device 1-1:1.0, driver kalmia 
[ 2200.634793] usb_match_id: id=c1a85fec idVendor=0x4e8 idProduct=0x689a
[ 2200.635521] usb_match_id: id=c1a86004 idVendor=0x4e8 idProduct=0x6889
[ 2200.636406] usb_device_match: device 1-1:1.0, driver cx82310_eth 
[ 2200.637069] usb_match_id: id=c1a86078 idVendor=0x572 idProduct=0xcb01
[ 2200.637775] usb_device_match: device 1-1:1.0, driver cdc_ncm 
[ 2200.638466] usb_match_id: id=c1a861a4 idVendor=0xbdb idProduct=0x0
[ 2200.639135] usb_match_id: id=c1a861bc idVendor=0x0 idProduct=0x0
[ 2200.639793] usb_device_match: device 1-1:1.0, driver qmi_wwan 
[ 2200.640480] usb_match_id: id=c1a862b8 idVendor=0x12d1 idProduct=0x0
[ 2200.641177] usb_match_id: id=c1a862d0 idVendor=0x12d1 idProduct=0x0
[ 2200.641883] usb_match_id: id=c1a862e8 idVendor=0x12d1 idProduct=0x0
[ 2200.642583] usb_match_id: id=c1a86300 idVendor=0x106c idProduct=0x3718
[ 2200.643309] usb_match_id: id=c1a86318 idVendor=0x19d2 idProduct=0x167
[ 2200.644185] usb_match_id: id=c1a86330 idVendor=0x19d2 idProduct=0x326
[ 2200.644876] usb_match_id: id=c1a86348 idVendor=0x19d2 idProduct=0x55
[ 2200.645572] usb_match_id: id=c1a86360 idVendor=0x19d2 idProduct=0x63
[ 2200.646356] usb_match_id: id=c1a86378 idVendor=0x19d2 idProduct=0x1008
[ 2200.647063] usb_match_id: id=c1a86390 idVendor=0x19d2 idProduct=0x1010
[ 2200.647774] usb_match_id: id=c1a863a8 idVendor=0x19d2 idProduct=0x2002
[ 2200.648495] usb_match_id: id=c1a863c0 idVendor=0x19d2 idProduct=0x104
[ 2200.649233] usb_match_id: id=c1a863d8 idVendor=0x19d2 idProduct=0x1402
[ 2200.649965] usb_match_id: id=c1a863f0 idVendor=0x1199 idProduct=0x68a2
[ 2200.650779] usb_match_id: id=c1a86408 idVendor=0x5c6 idProduct=0x9212
[ 2200.651521] usb_match_id: id=c1a86420 idVendor=0x3f0 idProduct=0x1f1d
[ 2200.652240] usb_match_id: id=c1a86438 idVendor=0x3f0 idProduct=0x371d
[ 2200.652938] usb_match_id: id=c1a86450 idVendor=0x4da idProduct=0x250d
[ 2200.653641] usb_match_id: id=c1a86468 idVendor=0x413c idProduct=0x8172
[ 2200.654404] usb_match_id: id=c1a86480 idVendor=0x1410 idProduct=0xa001
[ 2200.655111] usb_match_id: id=c1a86498 idVendor=0xb05 idProduct=0x1776
[ 2200.655846] usb_match_id: id=c1a864b0 idVendor=0x19d2 idProduct=0xfff3
[ 2200.656630] usb_match_id: id=c1a864c8 idVendor=0x5c6 idProduct=0x9001
[ 2200.657359] usb_match_id: id=c1a864e0 idVendor=0x5c6 idProduct=0x9002
[ 2200.658238] usb_match_id: id=c1a864f8 idVendor=0x5c6 idProduct=0x9202
[ 2200.658932] usb_match_id: id=c1a86510 idVendor=0x5c6 idProduct=0x9203
[ 2200.659639] usb_match_id: id=c1a86528 idVendor=0x5c6 idProduct=0x9222
[ 2200.660352] usb_match_id: id=c1a86540 idVendor=0x5c6 idProduct=0x9009
[ 2200.661046] usb_match_id: id=c1a86558 idVendor=0x413c idProduct=0x8186
[ 2200.661757] usb_match_id: id=c1a86570 idVendor=0x5c6 idProduct=0x920b
[ 2200.662503] usb_match_id: id=c1a86588 idVendor=0x5c6 idProduct=0x9225
[ 2200.663221] usb_match_id: id=c1a865a0 idVendor=0x5c6 idProduct=0x9245
[ 2200.663914] usb_match_id: id=c1a865b8 idVendor=0x3f0 idProduct=0x251d
[ 2200.664753] usb_match_id: id=c1a865d0 idVendor=0x5c6 idProduct=0x9215
[ 2200.665464] usb_match_id: id=c1a865e8 idVendor=0x5c6 idProduct=0x9265
[ 2200.666273] usb_match_id: id=c1a86600 idVendor=0x5c6 idProduct=0x9235
[ 2200.666966] usb_match_id: id=c1a86618 idVendor=0x5c6 idProduct=0x9275
[ 2200.667668] usb_match_id: id=c1a86630 idVendor=0x1199 idProduct=0x9001
[ 2200.668437] usb_match_id: id=c1a86648 idVendor=0x1199 idProduct=0x9002
[ 2200.669160] usb_match_id: id=c1a86660 idVendor=0x1199 idProduct=0x9003
[ 2200.669889] usb_match_id: id=c1a86678 idVendor=0x1199 idProduct=0x9004
[ 2200.670613] usb_match_id: id=c1a86690 idVendor=0x1199 idProduct=0x9005
[ 2200.671400] usb_match_id: id=c1a866a8 idVendor=0x1199 idProduct=0x9006
[ 2200.672197] usb_match_id: id=c1a866c0 idVendor=0x1199 idProduct=0x9007
[ 2200.672898] usb_match_id: id=c1a866d8 idVendor=0x1199 idProduct=0x9008
[ 2200.673611] usb_match_id: id=c1a866f0 idVendor=0x1199 idProduct=0x9009
[ 2200.674376] usb_match_id: id=c1a86708 idVendor=0x1199 idProduct=0x900a
[ 2200.675079] usb_match_id: id=c1a86720 idVendor=0x1199 idProduct=0x9011
[ 2200.675789] usb_match_id: id=c1a86738 idVendor=0x16d8 idProduct=0x8002
[ 2200.676560] usb_match_id: id=c1a86750 idVendor=0x5c6 idProduct=0x9205
[ 2200.677278] usb_match_id: id=c1a86768 idVendor=0x1199 idProduct=0x9013
[ 2200.678016] usb_match_id: id=c1a86780 idVendor=0x1199 idProduct=0x9015
[ 2200.678872] usb_match_id: id=c1a86798 idVendor=0x1199 idProduct=0x9019
[ 2200.679584] usb_device_match: device 1-1:1.0, driver usblp 
[ 2200.680255] usb_match_id: id=c1a89540 idVendor=0x0 idProduct=0x0
[ 2200.680900] usb_match_id: id=c1a89558 idVendor=0x0 idProduct=0x0
[ 2200.681562] usb_match_id: id=c1a89570 idVendor=0x0 idProduct=0x0
[ 2200.682288] usb_match_id: id=c1a89588 idVendor=0x0 idProduct=0x0
[ 2200.682944] usb_match_id: id=c1a895a0 idVendor=0x0 idProduct=0x0
[ 2200.683604] usb_match_id: id=c1a895b8 idVendor=0x0 idProduct=0x0
[ 2200.684277] usb_match_id: id=c1a895d0 idVendor=0x4b8 idProduct=0x202
[ 2200.685056] usb_device_match: device 1-1:1.0, driver cdc_wdm 
[ 2200.685718] usb_match_id: id=c1a8967c idVendor=0x0 idProduct=0x0
[ 2200.686471] usb_device_match: device 1-1:1.0, driver usbtmc 
[ 2200.687089] usb_match_id: id=c1a89730 idVendor=0x0 idProduct=0x0
[ 2200.687750] usb_match_id: id=c1a89748 idVendor=0x0 idProduct=0x0
[ 2200.688417] usb_device_match: device 1-1:1.0, driver mdc800 
[ 2200.689030] usb_match_id: id=c1a897e0 idVendor=0x55f idProduct=0xa800
[ 2200.689735] usb_device_match: device 1-1:1.0, driver cypress_cy7c63 
[ 2200.690482] usb_match_id: id=c1a89878 idVendor=0xa2c idProduct=0x8
[ 2200.691239] usb_device_match: device 1-1:1.0, driver cytherm 
[ 2200.691908] usb_match_id: id=c1a898a8 idVendor=0x4b4 idProduct=0x2
[ 2200.692655] usb_device_match: device 1-1:1.0, driver emi62 - firmware loader 
[ 2200.693520] BUG: unable to handle kernel paging request at c1f85ca2
[ 2200.694294] IP: [<c14be7c9>] usb_match_id+0x81/0x100
[ 2200.694506] *pde = 023d0067 *pte = 01f85162 
[ 2200.694506] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[ 2200.694506] Pid: 17, comm: khubd Not tainted 3.6.0-rc1-bisect2-dirty #4  
[ 2200.694506] EIP: 0060:[<c14be7c9>] EFLAGS: 00010246 CPU: 0
[ 2200.694506] EIP is at usb_match_id+0x81/0x100
[ 2200.694506] EAX: c69dc800 EBX: c1f85ca0 ECX: c1c4f798 EDX: c1f85ca0
[ 2200.694506] ESI: c69dc800 EDI: 00000000 EBP: cd4d9d5c ESP: cd4d9d54
[ 2200.694506]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[ 2200.694506] CR0: 8005003b CR2: c1f85ca2 CR3: 01fb0000 CR4: 00000690
[ 2200.694506] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 2200.694506] DR6: ffff0ff0 DR7: 00000400
[ 2200.694506] Process khubd (pid: 17, ti=cd4d8000 task=cd4d4000 task.ti=cd4d8000)
[ 2200.694506] Stack:
[ 2200.694506]  c1d36790 c69dc800 cd4d9d7c c14be906 c1bab043 c1a873a0 c7888c68 c1bb18e9
[ 2200.694506]  c69dc81c c69dc81c cd4d9d88 c13bc354 c1d36790 cd4d9d98 c13bd499 cd4d9da0
[ 2200.694506]  c69dc81c cd4d9db4 c13ba9f7 cd48976c c694bbd8 c69dc81c c1d2a2b4 c69dc81c
[ 2200.694506] Call Trace:
[ 2200.694506]  [<c14be906>] usb_device_match+0xbe/0x119
[ 2200.694506]  [<c13bc354>] driver_match_device+0x32/0x4a
[ 2200.694506]  [<c13bd499>] __device_attach+0x1c/0x5b
[ 2200.694506]  [<c13ba9f7>] bus_for_each_drv+0x82/0x11e
[ 2200.694506]  [<c13bcb2a>] device_attach+0xb4/0xf8
[ 2200.694506]  [<c13bd47d>] ? __driver_attach+0xed/0xed
[ 2200.694506]  [<c13bad3d>] bus_probe_device+0x50/0x116
[ 2200.694506]  [<c13b856e>] device_add+0x849/0xaf9
[ 2200.694506]  [<c19e34af>] ? mutex_lock+0x39/0x6e
[ 2200.694506]  [<c14bd8d9>] usb_set_configuration+0xa07/0xa91
[ 2200.694506]  [<c14c9b95>] generic_probe+0xaa/0x109
[ 2200.694506]  [<c14bdc34>] usb_probe_device+0x1a/0x2a
[ 2200.694506]  [<c13bd14f>] driver_probe_device+0x180/0x3c1
[ 2200.694506]  [<c13bd4c2>] __device_attach+0x45/0x5b
[ 2200.694506]  [<c13ba9f7>] bus_for_each_drv+0x82/0x11e
[ 2200.694506]  [<c13bcb2a>] device_attach+0xb4/0xf8
[ 2200.694506]  [<c13bd47d>] ? __driver_attach+0xed/0xed
[ 2200.694506]  [<c13bad3d>] bus_probe_device+0x50/0x116
[ 2200.694506]  [<c13b856e>] device_add+0x849/0xaf9
[ 2200.694506]  [<c1391783>] ? add_device_randomness+0xa1/0xb5
[ 2200.694506]  [<c14b0c01>] usb_new_device+0x329/0x488
[ 2200.694506]  [<c14b43ad>] hub_thread+0x1239/0x196e
[ 2200.694506]  [<c19e65b6>] ? _raw_spin_unlock_irqrestore+0x66/0xab
[ 2200.694506]  [<c10c8e33>] ? abort_exclusive_wait+0xd6/0xd6
[ 2200.694506]  [<c10c7e61>] kthread+0xa2/0xb5
[ 2200.694506]  [<c14b3174>] ? usb_reset_device+0x217/0x217
[ 2200.694506]  [<c10c7dbf>] ? list_del_init+0x2f/0x2f
[ 2200.694506]  [<c19e7b76>] kernel_thread_helper+0x6/0xd
[ 2200.694506] Code: ff 83 05 30 54 1e c2 01 83 15 34 54 1e c2 00 83 c4 10 85 c0 0f 85 87 00 00 00 83 c3 18 83 05 38 54 1e c2 01 83 15 3c 54 1e c2 00 <0f> b7 53 02 66 85 d2 75 a5 83 05 40 54 1e c2 01 83 15 44 54 1e
[ 2200.694506] EIP: [<c14be7c9>] usb_match_id+0x81/0x100 SS:ESP 0068:cd4d9d54
[ 2200.694506] CR2: 00000000c1f85ca2
[ 2200.694506] ---[ end trace 3fe97ced620e07c4 ]---

--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm_bisect2-waimea-15754-2012-08-17-13-41-50-3.6.0-rc1-bisect2-dirty-4"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Linux version 3.6.0-rc1-bisect2-dirty (wfg@bee) (gcc version=
 4.7.1 (Debian 4.7.1-5) ) #4 SMP Fri Aug 17 12:47:16 CST 2012=0D
[    0.000000] KERNEL supported cpus:=0D
[    0.000000]   Intel GenuineIntel=0D
[    0.000000]   AMD AuthenticAMD=0D
[    0.000000]   Centaur CentaurHauls=0D
[    0.000000]   Transmeta GenuineTMx86=0D
[    0.000000]   Transmeta TransmetaCPU=0D
[    0.000000] e820: BIOS-provided physical RAM map:=0D
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usabl=
e=0D
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reser=
ved=0D
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved=0D
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usabl=
e=0D
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved=0D
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved=0D
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved=0D
[    0.000000] debug: ignoring loglevel setting.=0D
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!=0D
[    0.000000] Hypervisor detected: KVM=0D
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable =3D=3D> rese=
rved=0D
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable=0D
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x100000=0D
[    0.000000] initial memory mapped: [mem 0x00000000-0x027fffff]=0D
[    0.000000] Base memory trampoline at [c008f000] 8f000 size 16384=0D
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffdfff]=0D
[    0.000000]  [mem 0x00000000-0x0fffdfff] page 4k=0D
[    0.000000] kernel direct mapping tables up to 0xfffdfff @ [mem 0x027bd0=
00-0x027fffff]=0D
[    0.000000] log_buf_len: 8388608=0D
[    0.000000] early log buf free: 129348(98%)=0D
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]=0D
[    0.000000] ACPI: RSDP 000fd920 00014 (v00 BOCHS )=0D
[    0.000000] ACPI: RSDT 0fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC=
 00000001)=0D
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC=
 00000001)=0D
[    0.000000] ACPI: DSDT 0fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL=
 20100528)=0D
[    0.000000] ACPI: FACS 0fffff40 00040=0D
[    0.000000] ACPI: SSDT 0ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC=
 00000001)=0D
[    0.000000] ACPI: APIC 0ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC=
 00000001)=0D
[    0.000000] ACPI: HPET 0ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC=
 00000001)=0D
[    0.000000] ACPI: SSDT 0ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL=
 20100528)=0D
[    0.000000] ACPI: Local APIC address 0xfee00000=0D
[    0.000000] mapped APIC to         ffffb000 (        fee00000)=0D
[    0.000000] 0MB HIGHMEM available.=0D
[    0.000000] 255MB LOWMEM available.=0D
[    0.000000]   mapped low ram: 0 - 0fffe000=0D
[    0.000000]   low ram: 0 - 0fffe000=0D
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00=0D
[    0.000000] kvm-clock: cpu 0, msr 0:1fa9601, boot clock=0D
[    0.000000] Zone ranges:=0D
[    0.000000]   Normal   [mem 0x00010000-0x0fffdfff]=0D
[    0.000000]   HighMem  empty=0D
[    0.000000] Movable zone start for each node=0D
[    0.000000] Early memory node ranges=0D
[    0.000000]   node   0: [mem 0x00010000-0x00092fff]=0D
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]=0D
[    0.000000] On node 0 totalpages: 65409=0D
[    0.000000] free_area_init_node: node 0, pgdat c1e60bc0, node_mem_map cd=
cbf280=0D
[    0.000000]   Normal zone: 640 pages used for memmap=0D
[    0.000000]   Normal zone: 0 pages reserved=0D
[    0.000000]   Normal zone: 64769 pages, LIFO batch:15=0D
[    0.000000] Using APIC driver default=0D
[    0.000000] ACPI: PM-Timer IO Port: 0xb008=0D
[    0.000000] ACPI: Local APIC address 0xfee00000=0D
[    0.000000] mapped APIC to         ffffb000 (        fee00000)=0D
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)=0D
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)=0D
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])=0D
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])=0D
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-=
23=0D
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)=0D
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC =
INT 02=0D
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)=
=0D
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC =
INT 05=0D
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)=
=0D
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC =
INT 09=0D
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level=
)=0D
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC =
INT 0a=0D
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level=
)=0D
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC =
INT 0b=0D
[    0.000000] ACPI: IRQ0 used by override.=0D
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC =
INT 01=0D
[    0.000000] ACPI: IRQ2 used by override.=0D
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC =
INT 03=0D
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC =
INT 04=0D
[    0.000000] ACPI: IRQ5 used by override.=0D
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC =
INT 06=0D
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC =
INT 07=0D
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC =
INT 08=0D
[    0.000000] ACPI: IRQ9 used by override.=0D
[    0.000000] ACPI: IRQ10 used by override.=0D
[    0.000000] ACPI: IRQ11 used by override.=0D
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC =
INT 0c=0D
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC =
INT 0d=0D
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC =
INT 0e=0D
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC =
INT 0f=0D
[    0.000000] Using ACPI (MADT) for SMP configuration information=0D
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000=0D
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs=0D
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)=0D
[    0.000000] nr_irqs_gsi: 40=0D
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices=
=0D
[    0.000000] Booting paravirtualized kernel on KVM=0D
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1=0D
[    0.000000] PERCPU: Embedded 9 pages/cpu @cdcad000 s23872 r0 d12992 u368=
64=0D
[    0.000000] pcpu-alloc: s23872 r0 d12992 u36864 alloc=3D9*4096=0D
[    0.000000] pcpu-alloc: [0] 0 [0] 1 =0D
[    0.000000] kvm-clock: cpu 0, msr 0:dcb2601, primary cpu clock=0D
[    0.000000] KVM setup async PF for cpu 0=0D
[    0.000000] kvm-stealtime: cpu 0, msr dcaf6c0=0D
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64769=0D
[    0.000000] Kernel command line: trinity=3D2m hung_task_panic=3D1 bisect=
-reboot i386-randconfig-b065 branch=3Dsignal/execve2 dyndbg=3D"+p" log_buf_=
len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dynamic_printk sysr=
q_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,115200 cons=
ole=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw BOOT_IMAGE=3Di386/vmlinuz-bise=
ct2=0D
[    0.000000] sysrq: sysrq always enabled.=0D
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)=0D
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)=0D
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes=
)=0D
[    0.000000] __ex_table already sorted, skipping sort=0D
[    0.000000] Initializing CPU#0=0D
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)=0D
[    0.000000] Memory: 204784k/262136k available (10149k kernel code, 56852=
k reserved, 4584k data, 1296k init, 0k highmem)=0D
[    0.000000] virtual kernel memory layout:=0D
[    0.000000]     fixmap  : 0xffe6e000 - 0xfffff000   (1604 kB)=0D
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)=0D
[    0.000000]     vmalloc : 0xd07fe000 - 0xff7fe000   ( 752 MB)=0D
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)=0D
[    0.000000]       .init : 0xc1e66000 - 0xc1faa000   (1296 kB)=0D
[    0.000000]       .data : 0xc19e9727 - 0xc1e63740   (4584 kB)=0D
[    0.000000]       .text : 0xc1000000 - 0xc19e9727   (10149 kB)=0D
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.=0D
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D128, Order=3D0-3, MinObjects=
=3D0, CPUs=3D2, Nodes=3D1=0D
[    0.000000] Hierarchical RCU implementation.=0D
[    0.000000] 	Additional per-CPU info printed with stalls.=0D
[    0.000000] 	RCU restricting CPUs from NR_CPUS=3D8 to nr_cpu_ids=3D2.=0D
[    0.000000] NR_IRQS:2304 nr_irqs:512 16=0D
[    0.000000] CPU 0 irqstacks, hard=3Dcfff6000 soft=3Dcd400000=0D
[    0.000000] console [ttyS0] enabled=0D
[    0.000000] ODEBUG: 0 of 0 active objects replaced=0D
[    0.000000] ODEBUG: selftest passed=0D
[    0.000000] hpet clockevent registered=0D
[    0.000000] tsc: Detected 3300.196 MHz processor=0D
[    0.001999] Calibrating delay loop (skipped) preset value.. 6600.39 Bogo=
MIPS (lpj=3D3300196)=0D
[    0.002005] pid_max: default: 32768 minimum: 301=0D
[    0.002578] Security Framework initialized=0D
[    0.003042] AppArmor: AppArmor initialized=0D
[    0.003513] Mount-cache hash table entries: 512=0D
[    0.004186] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0=0D
[    0.004186] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0=0D
[    0.004186] tlb_flushall_shift is 0x6=0D
[    0.006013] debug: unmapping init [mem 0xc1faa000-0xc1facfff]=0D
[    0.006680] ACPI: Core revision 20120711=0D
[    0.009374] Getting VERSION: 50014=0D
[    0.009753] Getting VERSION: 50014=0D
[    0.010007] Getting ID: 0=0D
[    0.010305] Getting ID: f000000=0D
[    0.010652] Getting LVT0: 8700=0D
[    0.011005] Getting LVT1: 8400=0D
[    0.011341] Enabling APIC mode:  Flat.  Using 1 I/O APICs=0D
[    0.012045] enabled ExtINT on CPU#0=0D
[    0.013382] ENABLING IO-APIC IRQs=0D
[    0.013761] init IO_APIC IRQs=0D
[    0.014003]  apic 2 pin 0 not connected=0D
[    0.014432] IOAPIC[0]: Set routing entry (2-1 -> 0x41 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)=0D
[    0.015015] IOAPIC[0]: Set routing entry (2-2 -> 0x51 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)=0D
[    0.016013] IOAPIC[0]: Set routing entry (2-3 -> 0x61 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)=0D
[    0.017018] IOAPIC[0]: Set routing entry (2-4 -> 0x71 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)=0D
[    0.018012] IOAPIC[0]: Set routing entry (2-5 -> 0x81 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)=0D
[    0.019012] IOAPIC[0]: Set routing entry (2-6 -> 0x91 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)=0D
[    0.020012] IOAPIC[0]: Set routing entry (2-7 -> 0xa1 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)=0D
[    0.021011] IOAPIC[0]: Set routing entry (2-8 -> 0xb1 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)=0D
[    0.022012] IOAPIC[0]: Set routing entry (2-9 -> 0xc1 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)=0D
[    0.023011] IOAPIC[0]: Set routing entry (2-10 -> 0xd1 -> IRQ 10 Mode:1 =
Active:0 Dest:1)=0D
[    0.024011] IOAPIC[0]: Set routing entry (2-11 -> 0xe1 -> IRQ 11 Mode:1 =
Active:0 Dest:1)=0D
[    0.025011] IOAPIC[0]: Set routing entry (2-12 -> 0x22 -> IRQ 12 Mode:0 =
Active:0 Dest:1)=0D
[    0.026011] IOAPIC[0]: Set routing entry (2-13 -> 0x42 -> IRQ 13 Mode:0 =
Active:0 Dest:1)=0D
[    0.027029] IOAPIC[0]: Set routing entry (2-14 -> 0x52 -> IRQ 14 Mode:0 =
Active:0 Dest:1)=0D
[    0.028010] IOAPIC[0]: Set routing entry (2-15 -> 0x62 -> IRQ 15 Mode:0 =
Active:0 Dest:1)=0D
[    0.029008]  apic 2 pin 16 not connected=0D
[    0.029467]  apic 2 pin 17 not connected=0D
[    0.029999]  apic 2 pin 18 not connected=0D
[    0.030452]  apic 2 pin 19 not connected=0D
[    0.030898]  apic 2 pin 20 not connected=0D
[    0.030999]  apic 2 pin 21 not connected=0D
[    0.031437]  apic 2 pin 22 not connected=0D
[    0.031999]  apic 2 pin 23 not connected=0D
[    0.032567] ..TIMER: vector=3D0x51 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1=0D
[    0.032999] smpboot: CPU0: Intel Common KVM processor stepping 01=0D
[    0.034243] Using local APIC timer interrupts.=0D
[    0.034243] calibrating APIC timer ...=0D
[    0.035994] ... lapic delta =3D 6249935=0D
[    0.035994] ... PM-Timer delta =3D 357924=0D
[    0.035994] ... PM-Timer result ok=0D
[    0.035994] ..... delta 6249935=0D
[    0.035994] ..... mult: 268473472=0D
[    0.035994] ..... calibration result: 999989=0D
[    0.035994] ..... CPU clock speed is 3299.0809 MHz.=0D
[    0.035994] ..... host bus clock speed is 999.0989 MHz.=0D
[    0.036042] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.=0D
[    0.038193] CPU 1 irqstacks, hard=3Dcd464000 soft=3Dcd466000=0D
[    0.038998] smpboot: Booting Node   0, Processors  #1 OK=0D
[    0.001999] Initializing CPU#1=0D
[    0.001999] kvm-clock: cpu 1, msr 0:dcbb601, secondary cpu clock=0D
[    0.001999] masked ExtINT on CPU#1=0D
[    0.052991] TSC synchronization [CPU#0 -> CPU#1]:=0D
[    0.052991] Measured 623 cycles TSC warp between CPUs, turning off TSC c=
lock.=0D
[    0.052991] tsc: Marking TSC unstable due to check_tsc_sync_source faile=
d=0D
[    0.054085] Brought up 2 CPUs=0D
[    0.054082] KVM setup async PF for cpu 1=0D
[    0.054082] kvm-stealtime: cpu 1, msr dcb86c0=0D
[    0.054995] smpboot: Total of 2 processors activated (13200.78 BogoMIPS)=
=0D
[    0.057911] atomic64 test passed for i586+ platform with CX8 and with SS=
E=0D
[    0.058055] NET: Registered protocol family 16=0D
[    0.060056] EISA bus registered=0D
[    0.061102] ACPI: bus type pci registered=0D
[    0.061595] dca service started, version 1.12.1=0D
[    0.062163] PCI: PCI BIOS revision 2.10 entry at 0xfc78c, last bus=3D0=0D
[    0.062993] PCI: Using configuration type 1 for base access=0D
[    0.067649] ACPI: Added _OSI(Module Device)=0D
[    0.067993] ACPI: Added _OSI(Processor Device)=0D
[    0.068555] ACPI: Added _OSI(3.0 _SCP Extensions)=0D
[    0.068993] ACPI: Added _OSI(Processor Aggregator Device)=0D
[    0.070522] ACPI: EC: Look up EC in DSDT=0D
[    0.074549] ACPI: Interpreter enabled=0D
[    0.074960] ACPI: (supports S0 S5)=0D
[    0.075091] ACPI: Using IOAPIC for interrupt routing=0D
[    0.080283] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug=0D
[    0.081020] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])=0D
[    0.082016] pci_root PNP0A03:00: fail to add MMCONFIG information, can't=
 access extended PCI configuration space under this bridge.=0D
[    0.083029] PCI host bridge to bus 0000:00=0D
[    0.083491] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under dom=
ain [bus 00-ff]=0D
[    0.083991] pci_bus 0000:00: root bus resource [bus 00-ff]=0D
[    0.084992] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]=0D
[    0.085991] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]=0D
[    0.086669] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]=0D
[    0.086990] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebffff=
f]=0D
[    0.087990] pci_bus 0000:00: scanning bus=0D
[    0.088991] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000=0D
[    0.089660] pci 0000:00:00.0: calling quirk_mmio_always_on+0x0/0x17=0D
[    0.090262] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100=0D
[    0.091384] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180=0D
[    0.093886] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]=0D
[    0.095279] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000=0D
[    0.096000] pci 0000:00:01.3: calling acpi_pm_check_blacklist+0x0/0x6a=0D
[    0.097116] pci 0000:00:01.3: calling quirk_piix4_acpi+0x0/0x200=0D
[    0.097787] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI=0D
[    0.097998] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB=0D
[    0.099025] pci 0000:00:01.3: calling pci_fixup_piix4_acpi+0x0/0x1d=0D
[    0.100104] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000=0D
[    0.101943] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]=0D
[    0.103459] pci 0000:00:02.0: reg 14: [mem 0xfebf4000-0xfebf4fff]=0D
[    0.108499] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]=0D
[    0.110053] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000=0D
[    0.111017] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]=0D
[    0.112289] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]=0D
[    0.115559] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]=0D
[    0.116335] pci 0000:00:04.0: [8086:2668] type 00 class 0x040300=0D
[    0.117187] pci 0000:00:04.0: reg 10: [mem 0xfebf0000-0xfebf3fff]=0D
[    0.120674] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000=0D
[    0.121339] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]=0D
[    0.123015] pci 0000:00:05.0: reg 14: [mem 0xfebf5000-0xfebf5fff]=0D
[    0.127069] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000=0D
[    0.128013] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]=0D
[    0.129312] pci 0000:00:06.0: reg 14: [mem 0xfebf6000-0xfebf6fff]=0D
[    0.133245] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000=0D
[    0.134329] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]=0D
[    0.135543] pci 0000:00:07.0: reg 14: [mem 0xfebf7000-0xfebf7fff]=0D
[    0.139744] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000=0D
[    0.140317] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]=0D
[    0.142014] pci 0000:00:08.0: reg 14: [mem 0xfebf8000-0xfebf8fff]=0D
[    0.146161] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000=0D
[    0.147011] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]=0D
[    0.148284] pci 0000:00:09.0: reg 14: [mem 0xfebf9000-0xfebf9fff]=0D
[    0.152236] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000=0D
[    0.153364] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]=0D
[    0.154536] pci 0000:00:0a.0: reg 14: [mem 0xfebfa000-0xfebfafff]=0D
[    0.158475] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000=0D
[    0.159148] pci 0000:00:0b.0: reg 10: [mem 0xfebfb000-0xfebfb00f]=0D
[    0.162353] pci_bus 0000:00: fixups for bus=0D
[    0.162823] pci_bus 0000:00: bus scan returning with max=3D00=0D
[    0.162984] pci_bus 0000:00: on NUMA node 0=0D
[    0.164022] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]=0D
[    0.165612]  pci0000:00: Unable to request _OSC control (_OSC support ma=
sk: 0x1e)=0D
[    0.176333] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)=0D
[    0.177251] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)=0D
[    0.178148] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)=0D
[    0.179058] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)=0D
[    0.179869] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0=0D
[    0.180356] ACPI: bus type usb registered=0D
[    0.181001] usbcore: registered new interface driver usbfs=0D
[    0.181989] usbcore: registered new interface driver hub=0D
[    0.182776] usbcore: registered new device driver usb=0D
[    0.183045] Linux video capture interface: v2.00=0D
[    0.184079] Advanced Linux Sound Architecture Driver Version 1.0.25.=0D
[    0.184810] PCI: Using ACPI for IRQ routing=0D
[    0.184980] PCI: pci_cache_line_size set to 64 bytes=0D
[    0.186008] pci 0000:00:01.1: BAR 0: reserving [io  0x01f0-0x01f7 flags =
0x110] (d=3D0, p=3D0)=0D
[    0.186984] pci 0000:00:01.1: BAR 1: reserving [io  0x03f6 flags 0x110] =
(d=3D0, p=3D0)=0D
[    0.187841] pci 0000:00:01.1: BAR 2: reserving [io  0x0170-0x0177 flags =
0x110] (d=3D0, p=3D0)=0D
[    0.187976] pci 0000:00:01.1: BAR 3: reserving [io  0x0376 flags 0x110] =
(d=3D0, p=3D0)=0D
[    0.188976] pci 0000:00:01.1: BAR 4: reserving [io  0xc1c0-0xc1cf flags =
0x40101] (d=3D0, p=3D0)=0D
[    0.189994] pci 0000:00:02.0: BAR 0: reserving [mem 0xfc000000-0xfdfffff=
f flags 0x42208] (d=3D0, p=3D0)=0D
[    0.190976] pci 0000:00:02.0: BAR 1: reserving [mem 0xfebf4000-0xfebf4ff=
f flags 0x40200] (d=3D0, p=3D0)=0D
[    0.191987] pci 0000:00:03.0: BAR 0: reserving [mem 0xfeba0000-0xfebbfff=
f flags 0x40200] (d=3D0, p=3D0)=0D
[    0.192978] pci 0000:00:03.0: BAR 1: reserving [io  0xc000-0xc03f flags =
0x40101] (d=3D0, p=3D0)=0D
[    0.193986] pci 0000:00:04.0: BAR 0: reserving [mem 0xfebf0000-0xfebf3ff=
f flags 0x40200] (d=3D0, p=3D0)=0D
[    0.194986] pci 0000:00:05.0: BAR 0: reserving [io  0xc040-0xc07f flags =
0x40101] (d=3D0, p=3D0)=0D
[    0.195975] pci 0000:00:05.0: BAR 1: reserving [mem 0xfebf5000-0xfebf5ff=
f flags 0x40200] (d=3D0, p=3D0)=0D
[    0.197976] pci 0000:00:06.0: BAR 0: reserving [io  0xc080-0xc0bf flags =
0x40101] (d=3D0, p=3D0)=0D
[    0.198891] pci 0000:00:06.0: BAR 1: reserving [mem 0xfebf6000-0xfebf6ff=
f flags 0x40200] (d=3D0, p=3D0)=0D
[    0.198985] pci 0000:00:07.0: BAR 0: reserving [io  0xc0c0-0xc0ff flags =
0x40101] (d=3D0, p=3D0)=0D
[    0.199974] pci 0000:00:07.0: BAR 1: reserving [mem 0xfebf7000-0xfebf7ff=
f flags 0x40200] (d=3D0, p=3D0)=0D
[    0.201988] pci 0000:00:08.0: BAR 0: reserving [io  0xc100-0xc13f flags =
0x40101] (d=3D0, p=3D0)=0D
[    0.202950] pci 0000:00:08.0: BAR 1: reserving [mem 0xfebf8000-0xfebf8ff=
f flags 0x40200] (d=3D0, p=3D0)=0D
[    0.203983] pci 0000:00:09.0: BAR 0: reserving [io  0xc140-0xc17f flags =
0x40101] (d=3D0, p=3D0)=0D
[    0.204919] pci 0000:00:09.0: BAR 1: reserving [mem 0xfebf9000-0xfebf9ff=
f flags 0x40200] (d=3D0, p=3D0)=0D
[    0.205984] pci 0000:00:0a.0: BAR 0: reserving [io  0xc180-0xc1bf flags =
0x40101] (d=3D0, p=3D0)=0D
[    0.206973] pci 0000:00:0a.0: BAR 1: reserving [mem 0xfebfa000-0xfebfaff=
f flags 0x40200] (d=3D0, p=3D0)=0D
[    0.207984] pci 0000:00:0b.0: BAR 0: reserving [mem 0xfebfb000-0xfebfb00=
f flags 0x40200] (d=3D0, p=3D0)=0D
[    0.209096] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]=0D
[    0.209975] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]=0D
[    0.214058] NET: Registered protocol family 23=0D
[    0.214599] Bluetooth: Core ver 2.16=0D
[    0.214986] NET: Registered protocol family 31=0D
[    0.215545] Bluetooth: HCI device and connection manager initialized=0D
[    0.215976] Bluetooth: HCI socket layer initialized=0D
[    0.216505] Bluetooth: L2CAP socket layer initialized=0D
[    0.216981] Bluetooth: SCO socket layer initialized=0D
[    0.218711] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer=0D
[    0.218997] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0=0D
[    0.220152] hpet0: 3 comparators, 64-bit 100.000000 MHz counter=0D
[    0.224312] Switching to clocksource kvm-clock=0D
[    0.224844] AppArmor: AppArmor Filesystem Enabled=0D
[    0.224844] pnp: PnP ACPI init=0D
[    0.225149] ACPI: bus type pnp registered=0D
[    0.225658] pnp 00:00: [bus 00-ff]=0D
[    0.226035] pnp 00:00: [io  0x0cf8-0x0cff]=0D
[    0.226569] pnp 00:00: [io  0x0000-0x0cf7 window]=0D
[    0.227110] pnp 00:00: [io  0x0d00-0xffff window]=0D
[    0.227655] pnp 00:00: [mem 0x000a0000-0x000bffff window]=0D
[    0.228289] pnp 00:00: [mem 0xe0000000-0xfebfffff window]=0D
[    0.228991] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)=0D
[    0.229823] pnp 00:01: [io  0x0070-0x0071]=0D
[    0.230326] pnp 00:01: [irq 8]=0D
[    0.230738] pnp 00:01: [io  0x0072-0x0077]=0D
[    0.231261] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)=0D
[    0.232107] pnp 00:02: [io  0x0060]=0D
[    0.232581] pnp 00:02: [io  0x0064]=0D
[    0.233010] pnp 00:02: [irq 1]=0D
[    0.233436] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)=0D
[    0.234219] pnp 00:03: [irq 12]=0D
[    0.234621] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)=0D
[    0.235471] pnp 00:04: [io  0x03f2-0x03f5]=0D
[    0.235930] pnp 00:04: [io  0x03f7]=0D
[    0.236403] pnp 00:04: [irq 6]=0D
[    0.236776] pnp 00:04: [dma 2]=0D
[    0.237181] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)=0D
[    0.238002] pnp 00:05: [io  0x0378-0x037f]=0D
[    0.238552] pnp 00:05: [irq 7]=0D
[    0.238904] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)=0D
[    0.239766] pnp 00:06: [io  0x03f8-0x03ff]=0D
[    0.240243] pnp 00:06: [irq 4]=0D
[    0.240719] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)=0D
[    0.241726] pnp 00:07: [mem 0xfed00000-0xfed003ff]=0D
[    0.242312] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)=0D
[    0.243343] pnp: PnP ACPI: found 8 devices=0D
[    0.243800] ACPI: ACPI bus type pnp unregistered=0D
[    0.279244] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]=0D
[    0.279911] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]=0D
[    0.280622] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]=0D
[    0.281349] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]=0D
[    0.282098] NET: Registered protocol family 1=0D
[    0.282642] pci 0000:00:00.0: calling quirk_natoma+0x0/0x4f=0D
[    0.283326] pci 0000:00:00.0: Limiting direct PCI/PCI transfers=0D
[    0.284129] pci 0000:00:00.0: calling quirk_passive_release+0x0/0xcb=0D
[    0.285022] pci 0000:00:01.0: PIIX3: Enabling Passive Release=0D
[    0.285820] pci 0000:00:01.0: calling quirk_isa_dma_hangs+0x0/0x52=0D
[    0.286654] pci 0000:00:01.0: Activating ISA DMA hang workarounds=0D
[    0.287404] pci 0000:00:02.0: calling pci_fixup_video+0x0/0xf4=0D
[    0.288019] pci 0000:00:02.0: Boot video device=0D
[    0.288669] pci 0000:00:03.0: calling quirk_e100_interrupt+0x0/0x23a=0D
[    0.289555] PCI: CLS 0 bytes, default 64=0D
[    0.290154] Unpacking initramfs...=0D
[    1.036791] debug: unmapping init [mem 0xce73f000-0xcffeffff]=0D
[    1.038848] kvm: no hardware support=0D
[    1.040835] The force parameter has not been set to 1 so the Iris powero=
ff handler will not be installed.=0D
[    1.041997] NatSemi SCx200 Driver=0D
[    1.042564] audit: initializing netlink socket (disabled)=0D
[    1.043197] type=3D2000 audit(1345182041.042:1): initialized=0D
[    1.045240] fuse init (API version 7.19)=0D
[    1.045802] msgmni has been set to 399=0D
[    1.049664] NET: Registered protocol family 38=0D
[    1.050409] progear_bl: ALI M7101 PMU not found.=0D
[    1.050955] i2c-core: driver [adp8870_bl] using legacy suspend method=0D
[    1.051814] i2c-core: driver [adp8870_bl] using legacy resume method=0D
[    1.052617] rivafb_setup START=0D
[    1.053015] usbcore: registered new interface driver udlfb=0D
[    1.053804] usbcore: registered new interface driver smscufx=0D
[    1.054622] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0=0D
[    1.055496] ACPI: Power Button [PWRF]=0D
[    1.056002] pci_bus 0000:00: dev 01, created physical slot 1=0D
[    1.056691] pci_bus 0000:00: dev 02, created physical slot 2=0D
[    1.057382] pci_bus 0000:00: dev 03, created physical slot 3=0D
[    1.058068] pci_bus 0000:00: dev 04, created physical slot 4=0D
[    1.058752] pci_bus 0000:00: dev 05, created physical slot 5=0D
[    1.059466] pci_bus 0000:00: dev 06, created physical slot 6=0D
[    1.060095] pci_bus 0000:00: dev 07, created physical slot 7=0D
[    1.060830] pci_bus 0000:00: dev 08, created physical slot 8=0D
[    1.061529] pci_bus 0000:00: dev 09, created physical slot 9=0D
[    1.062181] pci_bus 0000:00: dev 0a, created physical slot 10=0D
[    1.062838] pci_bus 0000:00: dev 0b, created physical slot 11=0D
[    1.063517] pci_bus 0000:00: dev 0c, created physical slot 12=0D
[    1.064170] pci_bus 0000:00: dev 0d, created physical slot 13=0D
[    1.064878] pci_bus 0000:00: dev 0e, created physical slot 14=0D
[    1.065668] pci_bus 0000:00: dev 0f, created physical slot 15=0D
[    1.066379] pci_bus 0000:00: dev 10, created physical slot 16=0D
[    1.067028] pci_bus 0000:00: dev 11, created physical slot 17=0D
[    1.067764] pci_bus 0000:00: dev 12, created physical slot 18=0D
[    1.068532] pci_bus 0000:00: dev 13, created physical slot 19=0D
[    1.069178] pci_bus 0000:00: dev 14, created physical slot 20=0D
[    1.069851] pci_bus 0000:00: dev 15, created physical slot 21=0D
[    1.070517] pci_bus 0000:00: dev 16, created physical slot 22=0D
[    1.071209] pci_bus 0000:00: dev 17, created physical slot 23=0D
[    1.071895] pci_bus 0000:00: dev 18, created physical slot 24=0D
[    1.072784] pci_bus 0000:00: dev 19, created physical slot 25=0D
[    1.073592] pci_bus 0000:00: dev 1a, created physical slot 26=0D
[    1.074291] pci_bus 0000:00: dev 1b, created physical slot 27=0D
[    1.074985] pci_bus 0000:00: dev 1c, created physical slot 28=0D
[    1.075666] pci_bus 0000:00: dev 1d, created physical slot 29=0D
[    1.076352] pci_bus 0000:00: dev 1e, created physical slot 30=0D
[    1.077008] pci_bus 0000:00: dev 1f, created physical slot 31=0D
[    1.077917] ioatdma: Intel(R) QuickData Technology Driver 4.00=0D
[    1.084556] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled=0D
[    1.109210] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A=0D
[    1.113843] DoubleTalk PC - not found=0D
[    1.114406] Non-volatile memory driver v1.3=0D
[    1.114931] scx200_gpio: no SCx200 gpio present=0D
[    1.115502] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing=0D
[    1.116322] platform pc8736x_gpio.0: no device found=0D
[    1.116880] nsc_gpio initializing=0D
[    1.117275] smapi::smapi_init, ERROR invalid usSmapiID=0D
[    1.117892] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine=0D
[    1.118911] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data=0D
[    1.119715] mwave: mwavedd::mwave_init: Error: Failed to initialize=0D
[    1.120474] Linux agpgart interface v0.103=0D
[    1.121014] ipmi message handler version 39.2=0D
[    1.121551] IPMI Watchdog: driver initialized=0D
[    1.122025] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).=0D
[    1.122994] Hangcheck: Using getrawmonotonic().=0D
[    1.123631] i2c-core: driver [apds9802als] using legacy suspend method=0D
[    1.124445] i2c-core: driver [apds9802als] using legacy resume method=0D
[    1.125148] i2c-core: driver [tsl2550] using legacy suspend method=0D
[    1.125847] i2c-core: driver [tsl2550] using legacy resume method=0D
[    1.126580] Driver for timberdale has been successfully registered.=0D
[    1.127386] mtdoops: mtd device (mtddev=3Dname/number) must be supplied=
=0D
[    1.128124] NetSc520 flash device: 0x100000 at 0x200000=0D
[    1.128717] Failed to ioremap_nocache=0D
[    1.129121] scx200_docflash: NatSemi SCx200 DOCCS Flash Driver=0D
[    1.155831] No recognised DiskOnChip devices found=0D
[    1.156437] slram: not enough parameters.=0D
[    1.156869] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel =
Networks.=0D
[    1.157747] pmc551: not detected=0D
[    1.158148] usbcore: registered new interface driver alauda=0D
[    1.193068] onenand_wait: timeout! ctrl=3D0x0000 intr=3D0x0000=0D
[    1.193723] OneNAND Manufacturer: Samsung (0xec)=0D
[    1.194266] OneNAND 16MB 1.8V 16-bit (0x04)=0D
[    1.194745] OneNAND version =3D 0x001e=0D
[    1.195162] Lock scheme is Continuous Lock=0D
[    1.195645] Scanning device for bad blocks=0D
[    1.196308] Creating 1 MTD partitions on "OneNAND simulator":=0D
[    1.196965] 0x000000000000-0x000001000000 : "OneNAND simulator partition=
"=0D
[    1.197917] HSI/SSI char device loaded=0D
[    1.198636] libphy: Fixed MDIO Bus: probed=0D
[    1.199146] arcnet loaded.=0D
[    1.199499] arcnet: raw mode (`r') encapsulation support loaded.=0D
[    1.200174] arcnet: cap mode (`c') encapsulation support loaded.=0D
[    1.200860] vcan: Virtual CAN interface driver=0D
[    1.201399] slcan: serial line CAN interface driver=0D
[    1.201906] slcan: 10 dynamic interface channels.=0D
[    1.202473] mkiss: AX.25 Multikiss, Hans Albas PE1AYX=0D
[    1.203017] AX.25: bpqether driver version 004=0D
[    1.203545] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA=0D
[    1.203545] baycom_ser_hdx: version 0.10=0D
[    1.205003] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA=0D
[    1.205683] hdlcdrv: version 0.8=0D
[    1.206330] airo(): Probing for PCI adapters=0D
[    1.206875] airo(): Finished probing for PCI adapters=0D
[    1.207489] usbcore: registered new interface driver kaweth=0D
[    1.208103] pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethern=
et driver=0D
[    1.208951] usbcore: registered new interface driver pegasus=0D
[    1.209626] hso: /c/wfg/tip/drivers/net/usb/hso.c: Option Wireless=0D
[    1.210332] usbcore: registered new interface driver hso=0D
[    1.210953] usbcore: registered new interface driver asix=0D
[    1.211606] usbcore: registered new interface driver MOSCHIP usb-etherne=
t driver=0D
[    1.212496] usbcore: registered new interface driver kalmia=0D
[    1.213104] usbcore: registered new interface driver cx82310_eth=0D
[    1.213799] usbcore: registered new interface driver cdc_ncm=0D
[    1.214472] usbcore: registered new interface driver qmi_wwan=0D
[    1.215339] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver=0D
[    1.216117] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver=0D
[    1.216932] driver u132_hcd=0D
[    1.217414] usbcore: registered new interface driver usblp=0D
[    1.218009] usbcore: registered new interface driver cdc_wdm=0D
[    1.218676] usbcore: registered new interface driver usbtmc=0D
[    1.219322] usbcore: registered new interface driver mdc800=0D
[    1.219931] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera=0D
[    1.220830] usbcore: registered new interface driver cypress_cy7c63=0D
[    1.221559] usbcore: registered new interface driver cytherm=0D
[    1.222178] usbcore: registered new interface driver emi62 - firmware lo=
ader=0D
[    1.222970] driver ftdi-elan=0D
[    1.223578] usbcore: registered new interface driver ftdi-elan=0D
[    1.224251] usbcore: registered new interface driver idmouse=0D
[    1.224887] usbcore: registered new interface driver usbled=0D
[    1.225569] usbcore: registered new interface driver legousbtower=0D
[    1.226262] usbcore: registered new interface driver trancevibrator=0D
[    1.226987] usbcore: registered new interface driver usbsevseg=0D
[    1.227675] usbcore: registered new interface driver yurex=0D
[    1.228404] dummy_hcd dummy_hcd: USB Host+Gadget Emulator, driver 02 May=
 2005=0D
[    1.229193] dummy_hcd dummy_hcd: Dummy host controller=0D
[    1.229791] dummy_hcd dummy_hcd: new USB bus registered, assigned bus nu=
mber 1=0D
[    1.230728] usb_device_match: device 1-0:1.0, driver usbfs =0D
[    1.231407] usb_device_match: device 1-0:1.0, driver hub =0D
[    1.231989] usb_match_id: id=3Dc1a87214 idVendor=3D0x0 idProduct=3D0x0=0D
[    1.232724] usb_match_id: id=3Dc1a87214 idVendor=3D0x0 idProduct=3D0x0=0D
[    1.233453] hub 1-0:1.0: USB hub found=0D
[    1.233861] hub 1-0:1.0: 1 port detected=0D
[    1.234493] udc dummy_udc: registering UDC driver [g_ether]=0D
[    1.235131]  gadget: using random self ethernet address=0D
[    1.235719]  gadget: using random host ethernet address=0D
[    1.236429] usb0: MAC 02:a1:5f:33:27:22=0D
[    1.236852] usb0: HOST MAC ce:f8:e6:26:43:8d=0D
[    1.237382]  gadget: adding config #2 'RNDIS'/c1d3d8b0=0D
[    1.237950]  gadget: adding 'rndis'/c7891480 to config 'RNDIS'/c1d3d8b0=
=0D
[    1.238710] rndis_register: configNr =3D 0=0D
[    1.239150] rndis_set_param_medium: 0 0=0D
[    1.239612]  gadget: RNDIS: super speed IN/ep-a OUT/ep-b NOTIFY/ep-c=0D
[    1.240351]  gadget: cfg 2/c1d3d8b0 speeds: super high full=0D
[    1.240961]  gadget:   interface 0 =3D rndis/c7891480=0D
[    1.241536]  gadget:   interface 1 =3D rndis/c7891480=0D
[    1.242068]  gadget: adding config #1 'CDC Ethernet (ECM)'/c1d3d840=0D
[    1.242798]  gadget: adding 'cdc_ethernet'/c7891600 to config 'CDC Ether=
net (ECM)'/c1d3d840=0D
[    1.243760]  gadget: CDC Ethernet: super speed IN/ep-a OUT/ep-b NOTIFY/e=
p-c=0D
[    1.244581]  gadget: cfg 1/c1d3d840 speeds: super high full=0D
[    1.245193]  gadget:   interface 0 =3D cdc_ethernet/c7891600=0D
[    1.245818]  gadget:   interface 1 =3D cdc_ethernet/c7891600=0D
[    1.246458]  gadget: Ethernet Gadget, version: Memorial Day 2008=0D
[    1.247110]  gadget: g_ether ready=0D
[    1.247530] dummy_udc dummy_udc: binding gadget driver 'g_ether'=0D
[    1.248210] dummy_udc dummy_udc: This device can perform faster if you c=
onnect it to a super-speed port...=0D
[    1.249352] dummy_hcd dummy_hcd: port status 0x00010101 has changes=0D
[    1.250101] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12=0D
[    1.251646] serio: i8042 KBD port at 0x60,0x64 irq 1=0D
[    1.252204] serio: i8042 AUX port at 0x60,0x64 irq 12=0D
[    1.253224] usb_device_match: device 1-0:1.0, driver xpad =0D
[    1.253880] usb_match_id: id=3Dc1d454c4 idVendor=3D0x0 idProduct=3D0x0=0D
[    1.254588] usb_match_id: id=3Dc1d454dc idVendor=3D0x45e idProduct=3D0x0=
=0D
[    1.255282] usb_match_id: id=3Dc1d454f4 idVendor=3D0x45e idProduct=3D0x0=
=0D
[    1.255964] usb_match_id: id=3Dc1d4550c idVendor=3D0x46d idProduct=3D0x0=
=0D
[    1.256722] usb_match_id: id=3Dc1d45524 idVendor=3D0x46d idProduct=3D0x0=
=0D
[    1.257447] usb_match_id: id=3Dc1d4553c idVendor=3D0x738 idProduct=3D0x0=
=0D
[    1.258122] usb_match_id: id=3Dc1d45554 idVendor=3D0x738 idProduct=3D0x0=
=0D
[    1.258865] usb_match_id: id=3Dc1d4556c idVendor=3D0x738 idProduct=3D0x4=
540=0D
[    1.259661] usb_match_id: id=3Dc1d45584 idVendor=3D0xe6f idProduct=3D0x0=
=0D
[    1.260423] usb_match_id: id=3Dc1d4559c idVendor=3D0xe6f idProduct=3D0x0=
=0D
[    1.261084] usb_match_id: id=3Dc1d455b4 idVendor=3D0x12ab idProduct=3D0x=
0=0D
[    1.261793] usb_match_id: id=3Dc1d455cc idVendor=3D0x12ab idProduct=3D0x=
0=0D
[    1.262508] usb_match_id: id=3Dc1d455e4 idVendor=3D0x1430 idProduct=3D0x=
0=0D
[    1.263185] usb_match_id: id=3Dc1d455fc idVendor=3D0x1430 idProduct=3D0x=
0=0D
[    1.263907] usb_match_id: id=3Dc1d45614 idVendor=3D0x146b idProduct=3D0x=
0=0D
[    1.264699] usb_match_id: id=3Dc1d4562c idVendor=3D0x146b idProduct=3D0x=
0=0D
[    1.265439] usb_match_id: id=3Dc1d45644 idVendor=3D0x1bad idProduct=3D0x=
0=0D
[    1.266121] usb_match_id: id=3Dc1d4565c idVendor=3D0x1bad idProduct=3D0x=
0=0D
[    1.266818] usb_match_id: id=3Dc1d45674 idVendor=3D0xf0d idProduct=3D0x0=
=0D
[    1.267512] usb_match_id: id=3Dc1d4568c idVendor=3D0xf0d idProduct=3D0x0=
=0D
[    1.268184] usb_match_id: id=3Dc1d456a4 idVendor=3D0x1689 idProduct=3D0x=
0=0D
[    1.268868] usb_match_id: id=3Dc1d456bc idVendor=3D0x1689 idProduct=3D0x=
0=0D
[    1.269655] usbcore: registered new interface driver xpad=0D
[    1.270725] usb_device_match: device 1-0:1.0, driver ati_remote2 =0D
[    1.270735] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1=0D
[    1.272980] usb_match_id: id=3Dc1d466f0 idVendor=3D0x471 idProduct=3D0x6=
02=0D
[    1.273963] usbcore: registered new interface driver ati_remote2=0D
[    1.275070] wistron_btns: System unknown=0D
[    1.275769] rtc_cmos 00:01: RTC can wake from S4=0D
[    1.276806] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0=0D
[    1.277834] rtc0: alarms up to one day, 114 bytes nvram, hpet irqs=0D
[    1.279016] usb_device_match: device 1-0:1.0, driver i2c-diolan-u2c =0D
[    1.279996] usb_match_id: id=3Dc1a8d820 idVendor=3D0xabf idProduct=3D0x3=
370=0D
[    1.280994] usbcore: registered new interface driver i2c-diolan-u2c=0D
[    1.282018] isa i2c-pca-isa.0: Please specify I/O base=0D
[    1.282841] scx200_i2c: no SCx200 gpio pins available=0D
[    1.283645] IR NEC protocol handler initialized=0D
[    1.284317] IR RC6 protocol handler initialized=0D
[    1.284989] IR JVC protocol handler initialized=0D
[    1.285704] IR Sony protocol handler initialized=0D
[    1.286423] IR MCE Keyboard/mouse protocol handler initialized=0D
[    1.287302] saa7146: register extension 'budget dvb'=0D
[    1.288049] saa7146: register extension 'budget_av'=0D
[    1.288841] saa7146: register extension 'budget_patch dvb'=0D
[    1.289719] saa7146: register extension 'av7110'=0D
[    1.290479] usb_device_match: device 1-0:1.0, driver ttusb-dec =0D
[    1.291346] usb_match_id: id=3Dc1d7ce74 idVendor=3D0xb48 idProduct=3D0x1=
006=0D
[    1.292287] usb_match_id: id=3Dc1d7ce8c idVendor=3D0xb48 idProduct=3D0x1=
008=0D
[    1.293279] usb_match_id: id=3Dc1d7cea4 idVendor=3D0xb48 idProduct=3D0x1=
009=0D
[    1.294316] usbcore: registered new interface driver ttusb-dec=0D
[    1.295210] usb_device_match: device 1-0:1.0, driver dvb_usb_dtt200u =0D
[    1.296170] usb_match_id: id=3Dc1d80748 idVendor=3D0x14aa idProduct=3D0x=
201=0D
[    1.297151] usb_match_id: id=3Dc1d80760 idVendor=3D0x14aa idProduct=3D0x=
301=0D
[    1.298130] usb_match_id: id=3Dc1d80778 idVendor=3D0x14aa idProduct=3D0x=
222=0D
[    1.299101] usb_match_id: id=3Dc1d80790 idVendor=3D0x14aa idProduct=3D0x=
221=0D
[    1.300088] usb_match_id: id=3Dc1d807a8 idVendor=3D0x14aa idProduct=3D0x=
22a=0D
[    1.301080] usb_match_id: id=3Dc1d807c0 idVendor=3D0x14aa idProduct=3D0x=
22b=0D
[    1.302081] usb_match_id: id=3Dc1d807d8 idVendor=3D0x14aa idProduct=3D0x=
225=0D
[    1.303082] usb_match_id: id=3Dc1d807f0 idVendor=3D0x14aa idProduct=3D0x=
226=0D
[    1.304089] usb_match_id: id=3Dc1d80808 idVendor=3D0x14aa idProduct=3D0x=
220=0D
[    1.305068] usb_match_id: id=3Dc1d80820 idVendor=3D0x18f3 idProduct=3D0x=
220=0D
[    1.306046] usbcore: registered new interface driver dvb_usb_dtt200u=0D
[    1.307002] usb_device_match: device 1-0:1.0, driver dvb_usb_nova_t_usb2=
 =0D
[    1.308036] usb_match_id: id=3Dc1d81b6c idVendor=3D0x2040 idProduct=3D0x=
9300=0D
[    1.309025] usb_match_id: id=3Dc1d81b84 idVendor=3D0x2040 idProduct=3D0x=
9301=0D
[    1.310040] usbcore: registered new interface driver dvb_usb_nova_t_usb2=
=0D
[    1.311056] usb_device_match: device 1-0:1.0, driver dvb_usb_umt_010 =0D
[    1.312043] usb_match_id: id=3Dc1d824f4 idVendor=3D0x15f4 idProduct=3D0x=
1=0D
[    1.313041] usb_match_id: id=3Dc1d8250c idVendor=3D0x15f4 idProduct=3D0x=
15=0D
[    1.314020] usbcore: registered new interface driver dvb_usb_umt_010=0D
[    1.314973] usb_device_match: device 1-0:1.0, driver dvb_usb_gl861 =0D
[    1.315924] usb_match_id: id=3Dc1d82eb4 idVendor=3D0xdb0 idProduct=3D0x5=
581=0D
[    1.316913] usb_match_id: id=3Dc1d82ecc idVendor=3D0x5e3 idProduct=3D0xf=
170=0D
[    1.317893] usbcore: registered new interface driver dvb_usb_gl861=0D
[    1.318862] usb_device_match: device 1-0:1.0, driver dvb_usb_au6610 =0D
[    1.319882] usb_match_id: id=3Dc1d838b8 idVendor=3D0x58f idProduct=3D0x6=
610=0D
[    1.320879] usbcore: registered new interface driver dvb_usb_au6610=0D
[    1.321831] usb_device_match: device 1-0:1.0, driver dvb_usb_ttusb2 =0D
[    1.322792] usb_match_id: id=3Dc1d8522c idVendor=3D0x2304 idProduct=3D0x=
20f=0D
[    1.323752] usb_match_id: id=3Dc1d85244 idVendor=3D0x2304 idProduct=3D0x=
222=0D
[    1.324713] usb_match_id: id=3Dc1d8525c idVendor=3D0xb48 idProduct=3D0x3=
006=0D
[    1.325672] usb_match_id: id=3Dc1d85274 idVendor=3D0xb48 idProduct=3D0x3=
00d=0D
[    1.326707] usbcore: registered new interface driver dvb_usb_ttusb2=0D
[    1.327752] usb_device_match: device 1-0:1.0, driver dvb_usb_dib0700 =0D
[    1.328726] usb_match_id: id=3Dc1d91b48 idVendor=3D0x10b8 idProduct=3D0x=
1e14=0D
[    1.329733] usb_match_id: id=3Dc1d91b60 idVendor=3D0x10b8 idProduct=3D0x=
1e78=0D
[    1.330741] usb_match_id: id=3Dc1d91b78 idVendor=3D0x2040 idProduct=3D0x=
9941=0D
[    1.331693] usb_match_id: id=3Dc1d91b90 idVendor=3D0x2040 idProduct=3D0x=
9950=0D
[    1.332423] usb_match_id: id=3Dc1d91ba8 idVendor=3D0x2040 idProduct=3D0x=
7050=0D
[    1.333132] usb_match_id: id=3Dc1d91bc0 idVendor=3D0x7ca idProduct=3D0xa=
807=0D
[    1.333844] usb_match_id: id=3Dc1d91bd8 idVendor=3D0x185b idProduct=3D0x=
1e78=0D
[    1.334092] dummy_hcd dummy_hcd: port status 0x00010101 has changes=0D
[    1.335294] usb_match_id: id=3Dc1d91bf0 idVendor=3D0x1584 idProduct=3D0x=
6003=0D
[    1.336006] usb_match_id: id=3Dc1d91c08 idVendor=3D0x413 idProduct=3D0x6=
f00=0D
[    1.336723] usb_match_id: id=3Dc1d91c20 idVendor=3D0x2040 idProduct=3D0x=
7060=0D
[    1.337442] usb_match_id: id=3Dc1d91c38 idVendor=3D0x7ca idProduct=3D0xb=
808=0D
[    1.338125] usb_match_id: id=3Dc1d91c50 idVendor=3D0x2304 idProduct=3D0x=
22c=0D
[    1.338858] usb_match_id: id=3Dc1d91c68 idVendor=3D0xccd idProduct=3D0x5=
a=0D
[    1.339553] usb_match_id: id=3Dc1d91c80 idVendor=3D0x2040 idProduct=3D0x=
9580=0D
[    1.340254] usb_match_id: id=3Dc1d91c98 idVendor=3D0x10b8 idProduct=3D0x=
1ef0=0D
[    1.341143] usb_match_id: id=3Dc1d91cb0 idVendor=3D0x10b8 idProduct=3D0x=
1ebc=0D
[    1.341944] usb_match_id: id=3Dc1d91cc8 idVendor=3D0x2304 idProduct=3D0x=
228=0D
[    1.342720] usb_match_id: id=3Dc1d91ce0 idVendor=3D0x10b8 idProduct=3D0x=
1ebe=0D
[    1.343459] usb_match_id: id=3Dc1d91cf8 idVendor=3D0x2304 idProduct=3D0x=
229=0D
[    1.344141] usb_match_id: id=3Dc1d91d10 idVendor=3D0x185b idProduct=3D0x=
1e80=0D
[    1.344879] usb_match_id: id=3Dc1d91d28 idVendor=3D0x7ca idProduct=3D0xb=
568=0D
[    1.345607] usb_match_id: id=3Dc1d91d40 idVendor=3D0x1044 idProduct=3D0x=
7001=0D
[    1.346318] usb_match_id: id=3Dc1d91d58 idVendor=3D0x5d8 idProduct=3D0x8=
10f=0D
[    1.347081] usb_match_id: id=3Dc1d91d70 idVendor=3D0xb05 idProduct=3D0x1=
71f=0D
[    1.347821] usb_match_id: id=3Dc1d91d88 idVendor=3D0xb05 idProduct=3D0x1=
73f=0D
[    1.348560] usb_match_id: id=3Dc1d91da0 idVendor=3D0x2040 idProduct=3D0x=
7070=0D
[    1.349262] usb_match_id: id=3Dc1d91db8 idVendor=3D0x2040 idProduct=3D0x=
7080=0D
[    1.349994] usb_match_id: id=3Dc1d91dd0 idVendor=3D0xccd idProduct=3D0x5=
8=0D
[    1.350748] usb_match_id: id=3Dc1d91de8 idVendor=3D0x2304 idProduct=3D0x=
22e=0D
[    1.351477] usb_match_id: id=3Dc1d91e00 idVendor=3D0x2304 idProduct=3D0x=
236=0D
[    1.352164] usb_match_id: id=3Dc1d91e18 idVendor=3D0x2304 idProduct=3D0x=
237=0D
[    1.352897] usb_match_id: id=3Dc1d91e30 idVendor=3D0x1164 idProduct=3D0x=
1edc=0D
[    1.353641] usb_match_id: id=3Dc1d91e48 idVendor=3D0xccd idProduct=3D0x6=
0=0D
[    1.354326] usb_match_id: id=3Dc1d91e60 idVendor=3D0xccd idProduct=3D0x7=
8=0D
[    1.355037] usb_match_id: id=3Dc1d91e78 idVendor=3D0x413 idProduct=3D0x6=
f01=0D
[    1.355763] usb_match_id: id=3Dc1d91e90 idVendor=3D0x2040 idProduct=3D0x=
5200=0D
[    1.356509] usb_match_id: id=3Dc1d91ea8 idVendor=3D0x2040 idProduct=3D0x=
8400=0D
[    1.357202] usb_match_id: id=3Dc1d91ec0 idVendor=3D0x1044 idProduct=3D0x=
7002=0D
[    1.357924] usb_match_id: id=3Dc1d91ed8 idVendor=3D0x1164 idProduct=3D0x=
1f08=0D
[    1.358696] usb_match_id: id=3Dc1d91ef0 idVendor=3D0xb05 idProduct=3D0x1=
736=0D
[    1.359416] usb_match_id: id=3Dc1d91f08 idVendor=3D0x2304 idProduct=3D0x=
23a=0D
[    1.360104] usb_match_id: id=3Dc1d91f20 idVendor=3D0x2304 idProduct=3D0x=
23b=0D
[    1.360821] usb_match_id: id=3Dc1d91f38 idVendor=3D0xccd idProduct=3D0x6=
2=0D
[    1.361529] usb_match_id: id=3Dc1d91f50 idVendor=3D0xccd idProduct=3D0x8=
1=0D
[    1.362200] usb_match_id: id=3Dc1d91f68 idVendor=3D0x1415 idProduct=3D0x=
3=0D
[    1.362906] usb_match_id: id=3Dc1d91f80 idVendor=3D0x1164 idProduct=3D0x=
2edc=0D
[    1.363650] usb_match_id: id=3Dc1d91f98 idVendor=3D0x2040 idProduct=3D0x=
b200=0D
[    1.364388] usb_match_id: id=3Dc1d91fb0 idVendor=3D0x2040 idProduct=3D0x=
b210=0D
[    1.365094] usb_match_id: id=3Dc1d91fc8 idVendor=3D0x1164 idProduct=3D0x=
871=0D
[    1.365823] usb_match_id: id=3Dc1d91fe0 idVendor=3D0xfd9 idProduct=3D0x2=
1=0D
[    1.366585] usb_match_id: id=3Dc1d91ff8 idVendor=3D0xfd9 idProduct=3D0x2=
0=0D
[    1.367267] usb_match_id: id=3Dc1d92010 idVendor=3D0x413 idProduct=3D0x6=
0f6=0D
[    1.367991] usb_match_id: id=3Dc1d92028 idVendor=3D0xccd idProduct=3D0x1=
0a0=0D
[    1.368724] usb_match_id: id=3Dc1d92040 idVendor=3D0xccd idProduct=3D0x1=
0a1=0D
[    1.369442] usb_match_id: id=3Dc1d92058 idVendor=3D0x1164 idProduct=3D0x=
1efc=0D
[    1.370157] usb_match_id: id=3Dc1d92070 idVendor=3D0x1164 idProduct=3D0x=
1e8c=0D
[    1.370952] usb_match_id: id=3Dc1d92088 idVendor=3D0x2304 idProduct=3D0x=
243=0D
[    1.371685] usb_match_id: id=3Dc1d920a0 idVendor=3D0x2013 idProduct=3D0x=
245=0D
[    1.372422] usb_match_id: id=3Dc1d920b8 idVendor=3D0x2013 idProduct=3D0x=
248=0D
[    1.373117] usb_match_id: id=3Dc1d920d0 idVendor=3D0x10b8 idProduct=3D0x=
1e80=0D
[    1.373856] usb_match_id: id=3Dc1d920e8 idVendor=3D0xccd idProduct=3D0xa=
b=0D
[    1.374616] usb_match_id: id=3Dc1d92100 idVendor=3D0x10b8 idProduct=3D0x=
1f98=0D
[    1.375316] usb_match_id: id=3Dc1d92118 idVendor=3D0x10b8 idProduct=3D0x=
1f90=0D
[    1.376039] usb_match_id: id=3Dc1d92130 idVendor=3D0x1554 idProduct=3D0x=
5010=0D
[    1.376784] usb_match_id: id=3Dc1d92148 idVendor=3D0x1e59 idProduct=3D0x=
2=0D
[    1.377496] usb_match_id: id=3Dc1d92160 idVendor=3D0x2304 idProduct=3D0x=
245=0D
[    1.378186] usb_match_id: id=3Dc1d92178 idVendor=3D0x2304 idProduct=3D0x=
248=0D
[    1.378896] usb_match_id: id=3Dc1d92190 idVendor=3D0x10b8 idProduct=3D0x=
1fa0=0D
[    1.379630] usb_match_id: id=3Dc1d921a8 idVendor=3D0xfd9 idProduct=3D0x1=
1=0D
[    1.380327] usb_match_id: id=3Dc1d921c0 idVendor=3D0x10b8 idProduct=3D0x=
2383=0D
[    1.381049] usb_match_id: id=3Dc1d921d8 idVendor=3D0x10b8 idProduct=3D0x=
1fa8=0D
[    1.381771] usb_match_id: id=3Dc1d921f0 idVendor=3D0x10b8 idProduct=3D0x=
2384=0D
[    1.382558] usb_match_id: id=3Dc1d92208 idVendor=3D0x10b8 idProduct=3D0x=
1bb2=0D
[    1.383267] usb_match_id: id=3Dc1d92220 idVendor=3D0x10b8 idProduct=3D0x=
1bb4=0D
[    1.383980] usb_match_id: id=3Dc1d92238 idVendor=3D0x14f7 idProduct=3D0x=
4=0D
[    1.384684] usb_match_id: id=3Dc1d92250 idVendor=3D0x1660 idProduct=3D0x=
1921=0D
[    1.385420] usb_match_id: id=3Dc1d92268 idVendor=3D0x2304 idProduct=3D0x=
23d=0D
[    1.386114] usb_match_id: id=3Dc1d92280 idVendor=3D0x2304 idProduct=3D0x=
23e=0D
[    1.386860] usb_match_id: id=3Dc1d92298 idVendor=3D0x10b8 idProduct=3D0x=
1bb7=0D
[    1.387579] usb_match_id: id=3Dc1d922b0 idVendor=3D0x10b8 idProduct=3D0x=
1e6e=0D
[    1.388299] usb_match_id: id=3Dc1d922c8 idVendor=3D0x10b8 idProduct=3D0x=
1f9c=0D
[    1.389013] usb_match_id: id=3Dc1d922e0 idVendor=3D0xfd9 idProduct=3D0x3=
f=0D
[    1.389729] usbcore: registered new interface driver dvb_usb_dib0700=0D
[    1.390469] usb_device_match: device 1-0:1.0, driver pctv452e =0D
[    1.391132] usb_match_id: id=3Dc1d94c1c idVendor=3D0x2304 idProduct=3D0x=
21f=0D
[    1.391843] usb_match_id: id=3Dc1d94c34 idVendor=3D0xb48 idProduct=3D0x3=
007=0D
[    1.392569] usb_match_id: id=3Dc1d94c4c idVendor=3D0xb48 idProduct=3D0x3=
00a=0D
[    1.393262] usbcore: registered new interface driver pctv452e=0D
[    1.393918] usb_device_match: device 1-0:1.0, driver dw2102 =0D
[    1.394596] usb_match_id: id=3Dc1d97af4 idVendor=3D0x4b4 idProduct=3D0x2=
102=0D
[    1.395307] usb_match_id: id=3Dc1d97b0c idVendor=3D0x4b4 idProduct=3D0x2=
101=0D
[    1.396007] usb_match_id: id=3Dc1d97b24 idVendor=3D0x4b4 idProduct=3D0x2=
104=0D
[    1.396731] usb_match_id: id=3Dc1d97b3c idVendor=3D0x9022 idProduct=3D0x=
d650=0D
[    1.397473] usb_match_id: id=3Dc1d97b54 idVendor=3D0xccd idProduct=3D0x6=
4=0D
[    1.398147] usb_match_id: id=3Dc1d97b6c idVendor=3D0x4b4 idProduct=3D0x3=
101=0D
[    1.398898] usb_match_id: id=3Dc1d97b84 idVendor=3D0x9022 idProduct=3D0x=
d630=0D
[    1.399621] usb_match_id: id=3Dc1d97b9c idVendor=3D0x3011 idProduct=3D0x=
b012=0D
[    1.400324] usb_match_id: id=3Dc1d97bb4 idVendor=3D0x9022 idProduct=3D0x=
d660=0D
[    1.401050] usb_match_id: id=3Dc1d97bcc idVendor=3D0x3034 idProduct=3D0x=
7500=0D
[    1.401793] usb_match_id: id=3Dc1d97be4 idVendor=3D0x1f4d idProduct=3D0x=
3000=0D
[    1.402569] usb_match_id: id=3Dc1d97bfc idVendor=3D0xccd idProduct=3D0xa=
8=0D
[    1.403259] usb_match_id: id=3Dc1d97c14 idVendor=3D0x9022 idProduct=3D0x=
d481=0D
[    1.403969] usb_match_id: id=3Dc1d97c2c idVendor=3D0x9022 idProduct=3D0x=
d482=0D
[    1.404701] usb_match_id: id=3Dc1d97c44 idVendor=3D0x1f4d idProduct=3D0x=
3100=0D
[    1.405429] usbcore: registered new interface driver dw2102=0D
[    1.406033] usb_device_match: device 1-0:1.0, driver dvb_usb_af9015 =0D
[    1.406790] usb_match_id: id=3Dc1d99d24 idVendor=3D0x15a4 idProduct=3D0x=
9015=0D
[    1.407515] usb_match_id: id=3Dc1d99d3c idVendor=3D0x15a4 idProduct=3D0x=
9016=0D
[    1.408206] usb_match_id: id=3Dc1d99d54 idVendor=3D0x413 idProduct=3D0x6=
029=0D
[    1.408912] usb_match_id: id=3Dc1d99d6c idVendor=3D0x2304 idProduct=3D0x=
22b=0D
[    1.409627] usb_match_id: id=3Dc1d99d84 idVendor=3D0x1b80 idProduct=3D0x=
e399=0D
[    1.410326] usb_match_id: id=3Dc1d99d9c idVendor=3D0x13d3 idProduct=3D0x=
3226=0D
[    1.411094] usb_match_id: id=3Dc1d99db4 idVendor=3D0x13d3 idProduct=3D0x=
3237=0D
[    1.411808] usb_match_id: id=3Dc1d99dcc idVendor=3D0xccd idProduct=3D0x6=
9=0D
[    1.412497] usb_match_id: id=3Dc1d99de4 idVendor=3D0x1b80 idProduct=3D0x=
c160=0D
[    1.413193] usb_match_id: id=3Dc1d99dfc idVendor=3D0x7ca idProduct=3D0xa=
815=0D
[    1.413901] usb_match_id: id=3Dc1d99e14 idVendor=3D0x1ae7 idProduct=3D0x=
381=0D
[    1.414646] usb_match_id: id=3Dc1d99e2c idVendor=3D0x1462 idProduct=3D0x=
8801=0D
[    1.415349] usb_match_id: id=3Dc1d99e44 idVendor=3D0x7ca idProduct=3D0x8=
150=0D
[    1.416055] usb_match_id: id=3Dc1d99e5c idVendor=3D0x10b9 idProduct=3D0x=
8000=0D
[    1.416773] usb_match_id: id=3Dc1d99e74 idVendor=3D0x7ca idProduct=3D0xa=
309=0D
[    1.417492] usb_match_id: id=3Dc1d99e8c idVendor=3D0x1462 idProduct=3D0x=
8807=0D
[    1.418197] usb_match_id: id=3Dc1d99ea4 idVendor=3D0x1b80 idProduct=3D0x=
e396=0D
[    1.418993] usb_match_id: id=3Dc1d99ebc idVendor=3D0x1b80 idProduct=3D0x=
e39b=0D
[    1.419712] usb_match_id: id=3Dc1d99ed4 idVendor=3D0x1b80 idProduct=3D0x=
e395=0D
[    1.420431] usb_match_id: id=3Dc1d99eec idVendor=3D0x15a4 idProduct=3D0x=
901b=0D
[    1.421123] usb_match_id: id=3Dc1d99f04 idVendor=3D0x7ca idProduct=3D0x8=
50a=0D
[    1.421832] usb_match_id: id=3Dc1d99f1c idVendor=3D0x7ca idProduct=3D0xa=
805=0D
[    1.422583] usb_match_id: id=3Dc1d99f34 idVendor=3D0x1b80 idProduct=3D0x=
e397=0D
[    1.423286] usb_match_id: id=3Dc1d99f4c idVendor=3D0x1b80 idProduct=3D0x=
c810=0D
[    1.423994] usb_match_id: id=3Dc1d99f64 idVendor=3D0x458 idProduct=3D0x4=
012=0D
[    1.424703] usb_match_id: id=3Dc1d99f7c idVendor=3D0x1b80 idProduct=3D0x=
e400=0D
[    1.425422] usb_match_id: id=3Dc1d99f94 idVendor=3D0x1b80 idProduct=3D0x=
c161=0D
[    1.426115] usb_match_id: id=3Dc1d99fac idVendor=3D0x1b80 idProduct=3D0x=
e39d=0D
[    1.426833] usb_match_id: id=3Dc1d99fc4 idVendor=3D0x1b80 idProduct=3D0x=
e402=0D
[    1.427544] usb_match_id: id=3Dc1d99fdc idVendor=3D0x413 idProduct=3D0x6=
a04=0D
[    1.428238] usb_match_id: id=3Dc1d99ff4 idVendor=3D0x1b80 idProduct=3D0x=
e383=0D
[    1.428942] usb_match_id: id=3Dc1d9a00c idVendor=3D0x1b80 idProduct=3D0x=
e39a=0D
[    1.429668] usb_match_id: id=3Dc1d9a024 idVendor=3D0x7ca idProduct=3D0x8=
15a=0D
[    1.430382] usb_match_id: id=3Dc1d9a03c idVendor=3D0xccd idProduct=3D0x9=
7=0D
[    1.431108] usb_match_id: id=3Dc1d9a054 idVendor=3D0xccd idProduct=3D0x9=
9=0D
[    1.431806] usb_match_id: id=3Dc1d9a06c idVendor=3D0x7ca idProduct=3D0x8=
50b=0D
[    1.432527] usb_match_id: id=3Dc1d9a084 idVendor=3D0x1f4d idProduct=3D0x=
9016=0D
[    1.433242] usb_match_id: id=3Dc1d9a09c idVendor=3D0x1b80 idProduct=3D0x=
e401=0D
[    1.433964] usbcore: registered new interface driver dvb_usb_af9015=0D
[    1.434723] usb_device_match: device 1-0:1.0, driver cinergyT2 =0D
[    1.435400] usb_match_id: id=3Dc1d9ad3c idVendor=3D0xccd idProduct=3D0x3=
8=0D
[    1.436073] usbcore: registered new interface driver cinergyT2=0D
[    1.436733] usb_device_match: device 1-0:1.0, driver dvb_usb_ce6230 =0D
[    1.437445] usb_match_id: id=3Dc1d9b9e0 idVendor=3D0x8086 idProduct=3D0x=
9500=0D
[    1.438158] usb_match_id: id=3Dc1d9b9f8 idVendor=3D0x7ca idProduct=3D0xa=
310=0D
[    1.438914] usbcore: registered new interface driver dvb_usb_ce6230=0D
[    1.439629] usb_device_match: device 1-0:1.0, driver dvb_usb_friio =0D
[    1.440320] usb_match_id: id=3Dc1d9c418 idVendor=3D0x7a69 idProduct=3D0x=
1=0D
[    1.441013] usbcore: registered new interface driver dvb_usb_friio=0D
[    1.441714] usb_device_match: device 1-0:1.0, driver dvb_usb_ec168 =0D
[    1.442422] usb_match_id: id=3Dc1d9d07c idVendor=3D0x18b4 idProduct=3D0x=
1689=0D
[    1.443174] usb_match_id: id=3Dc1d9d094 idVendor=3D0x18b4 idProduct=3D0x=
fffa=0D
[    1.443897] usb_match_id: id=3Dc1d9d0ac idVendor=3D0x18b4 idProduct=3D0x=
fffb=0D
[    1.444635] usb_match_id: id=3Dc1d9d0c4 idVendor=3D0x18b4 idProduct=3D0x=
1001=0D
[    1.445348] usb_match_id: id=3Dc1d9d0dc idVendor=3D0x18b4 idProduct=3D0x=
1002=0D
[    1.446065] usbcore: registered new interface driver dvb_usb_ec168=0D
[    1.446804] usb_device_match: device 1-0:1.0, driver dvb_usb_az6007 =0D
[    1.447519] usb_match_id: id=3Dc1d9db3c idVendor=3D0x13d3 idProduct=3D0x=
ccd=0D
[    1.448205] usb_match_id: id=3Dc1d9db54 idVendor=3D0xccd idProduct=3D0x1=
0b4=0D
[    1.448916] usb_match_id: id=3Dc1d9db6c idVendor=3D0xccd idProduct=3D0x1=
0a3=0D
[    1.449631] usbcore: registered new interface driver dvb_usb_az6007=0D
[    1.450320] usb_device_match: device 1-0:1.0, driver dvb_usb_az6027 =0D
[    1.451034] usb_match_id: id=3Dc1d9e828 idVendor=3D0x13d3 idProduct=3D0x=
3275=0D
[    1.451755] usb_match_id: id=3Dc1d9e840 idVendor=3D0xccd idProduct=3D0x1=
0a4=0D
[    1.452464] usb_match_id: id=3Dc1d9e858 idVendor=3D0xccd idProduct=3D0x1=
0ac=0D
[    1.453156] usb_match_id: id=3Dc1d9e870 idVendor=3D0x14f7 idProduct=3D0x=
1=0D
[    1.453847] usb_match_id: id=3Dc1d9e888 idVendor=3D0x14f7 idProduct=3D0x=
2=0D
[    1.454591] usb_match_id: id=3Dc1d9e8a0 idVendor=3D0xfd9 idProduct=3D0x2=
a=0D
[    1.455272] usbcore: registered new interface driver dvb_usb_az6027=0D
[    1.455962] usb_device_match: device 1-0:1.0, driver LME2510C_DVB-S =0D
[    1.456678] usb_match_id: id=3Dc1d9fd50 idVendor=3D0x3344 idProduct=3D0x=
1122=0D
[    1.457404] usb_match_id: id=3Dc1d9fd68 idVendor=3D0x3344 idProduct=3D0x=
1120=0D
[    1.458108] usb_match_id: id=3Dc1d9fd80 idVendor=3D0x3344 idProduct=3D0x=
22f0=0D
[    1.458821] usbcore: registered new interface driver LME2510C_DVB-S=0D
[    1.459526] usb_device_match: device 1-0:1.0, driver dvb_usb_af9035 =0D
[    1.460209] usb_match_id: id=3Dc1da0434 idVendor=3D0x15a4 idProduct=3D0x=
9035=0D
[    1.460930] usb_match_id: id=3Dc1da044c idVendor=3D0x15a4 idProduct=3D0x=
1000=0D
[    1.461650] usb_match_id: id=3Dc1da0464 idVendor=3D0x15a4 idProduct=3D0x=
1001=0D
[    1.462368] usb_match_id: id=3Dc1da047c idVendor=3D0x15a4 idProduct=3D0x=
1002=0D
[    1.463107] usb_match_id: id=3Dc1da0494 idVendor=3D0x15a4 idProduct=3D0x=
1003=0D
[    1.463827] usb_match_id: id=3Dc1da04ac idVendor=3D0xccd idProduct=3D0x9=
3=0D
[    1.464522] usb_match_id: id=3Dc1da04c4 idVendor=3D0x7ca idProduct=3D0xa=
835=0D
[    1.465211] usb_match_id: id=3Dc1da04dc idVendor=3D0x7ca idProduct=3D0xb=
835=0D
[    1.465924] usb_match_id: id=3Dc1da04f4 idVendor=3D0x7ca idProduct=3D0x1=
867=0D
[    1.466675] usb_match_id: id=3Dc1da050c idVendor=3D0x7ca idProduct=3D0xa=
867=0D
[    1.467388] usb_match_id: id=3Dc1da0524 idVendor=3D0x7ca idProduct=3D0x8=
25=0D
[    1.468067] usbcore: registered new interface driver dvb_usb_af9035=0D
[    1.468778] nGene PCIE bridge driver, Copyright (C) 2005-2007 Micronas=0D
[    1.469512] Digital Devices PCIE bridge driver, Copyright (C) 2010-11 Di=
gital Devices GmbH=0D
[    1.470429] Driver for 1-wire Dallas network protocol.=0D
[    1.471069] usb_device_match: device 1-0:1.0, driver DS9490R =0D
[    1.471714] usb_match_id: id=3Dc1da56d8 idVendor=3D0x4fa idProduct=3D0x2=
490=0D
[    1.472435] usbcore: registered new interface driver DS9490R=0D
[    1.473076] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko=0D
[    1.473796] power_supply test_ac: power_supply_changed=0D
[    1.474391] power_supply test_ac: power_supply_changed_work=0D
[    1.474987] power_supply test_ac: power_supply_update_gen_leds 1=0D
[    1.475722] power_supply test_battery: power_supply_changed=0D
[    1.476342] power_supply test_battery: power_supply_changed_work=0D
[    1.477000] power_supply test_battery: power_supply_update_bat_leds 2=0D
[    1.477731] power_supply test_usb: power_supply_changed=0D
[    1.478316] power_supply test_usb: power_supply_changed_work=0D
[    1.478984] power_supply test_usb: power_supply_update_gen_leds 1=0D
[    1.479812] usb_device_match: device 1-0:1.0, driver pcwd_usb =0D
[    1.480471] usb_match_id: id=3Dc1daa624 idVendor=3D0xc98 idProduct=3D0x1=
140=0D
[    1.481161] usbcore: registered new interface driver pcwd_usb=0D
[    1.481808] advantechwdt: WDT driver for Advantech single board computer=
 initialising=0D
[    1.482728] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D1)=0D
[    1.483428] alim7101_wdt: Steve Hill <steve@navaho.co.uk>=0D
[    1.484005] alim7101_wdt: ALi M7101 PMU not present - WDT not set=0D
[    1.484692] sp5100_tco: SP5100 TCO WatchDog Timer Driver v0.01=0D
[    1.485333]  gadget: resume=0D
[    1.485664] dummy_hcd dummy_hcd: port status 0x00100503 has changes=0D
[    1.486427] sc520_wdt: cannot register miscdev on minor=3D130 (err=3D-16=
)=0D
[    1.487180] ib700wdt: WDT driver for IB700 single board computer initial=
ising=0D
[    1.487997] ib700wdt: START method I/O 443 is not available=0D
[    1.488626] ib700wdt: probe of ib700wdt failed with error -5=0D
[    1.489248] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising=0D
[    1.490106] wafer5823wdt: I/O address 0x0443 already in use=0D
[    1.490774] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05=0D
[    1.491551] i6300esb: cannot register miscdev on minor=3D130 (err=3D-16)=
=0D
[    1.492275] i6300ESB timer: probe of 0000:00:0b.0 failed with error -16=
=0D
[    1.493033] pc87413_wdt: Version 1.1 at io 0x2E=0D
[    1.493552] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)=0D
[    1.494271] sbc60xxwdt: I/O address 0x0443 already in use=0D
[    1.494921] cpu5wdt: misc_register failed=0D
[    1.495444] w83627hf_wdt: WDT driver for the Winbond(TM) W83627HF/THF/HG=
/DHG Super I/O chip initialising=0D
[    1.496512] w83627hf_wdt: Watchdog already running. Resetting timeout to=
 60 sec=0D
[    1.497319] w83627hf_wdt: cannot register miscdev on minor=3D130 (err=3D=
-16)=0D
[    1.498045] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Sup=
er I/O chip initialising=0D
[    1.499010] w83697ug_wdt: No W83697UG/UF could be found=0D
[    1.499601] w83877f_wdt: I/O address 0x0443 already in use=0D
[    1.500186] machzwd: MachZ ZF-Logic Watchdog driver initializing=0D
[    1.500855] machzwd: no ZF-Logic found=0D
[    1.501270] Bluetooth: HCI UART driver ver 2.2=0D
[    1.501767] Bluetooth: HCILL protocol initialized=0D
[    1.502303] usb_device_match: device 1-0:1.0, driver bfusb =0D
[    1.502967] usb_match_id: id=3Dc1daeb08 idVendor=3D0x57c idProduct=3D0x2=
200=0D
[    1.503695] usbcore: registered new interface driver bfusb=0D
[    1.504300] usb_device_match: device 1-0:1.0, driver btusb =0D
[    1.504918] usb_match_id: id=3Dc1daf384 idVendor=3D0x0 idProduct=3D0x0=0D
[    1.505586] usb_match_id: id=3Dc1daf39c idVendor=3D0xa5c idProduct=3D0x2=
1e1=0D
[    1.506289] usb_match_id: id=3Dc1daf3b4 idVendor=3D0x5ac idProduct=3D0x8=
213=0D
[    1.506985] usb_match_id: id=3Dc1daf3cc idVendor=3D0x5ac idProduct=3D0x8=
215=0D
[    1.507698] usb_match_id: id=3Dc1daf3e4 idVendor=3D0x5ac idProduct=3D0x8=
218=0D
[    1.508408] usb_match_id: id=3Dc1daf3fc idVendor=3D0x5ac idProduct=3D0x8=
21b=0D
[    1.509091] usb_match_id: id=3Dc1daf414 idVendor=3D0x5ac idProduct=3D0x8=
21f=0D
[    1.509802] usb_match_id: id=3Dc1daf42c idVendor=3D0x5ac idProduct=3D0x8=
21a=0D
[    1.510563] usb_match_id: id=3Dc1daf444 idVendor=3D0x5ac idProduct=3D0x8=
281=0D
[    1.511261] usb_match_id: id=3Dc1daf45c idVendor=3D0x57c idProduct=3D0x3=
800=0D
[    1.511957] usb_match_id: id=3Dc1daf474 idVendor=3D0x4bf idProduct=3D0x3=
0a=0D
[    1.512658] usb_match_id: id=3Dc1daf48c idVendor=3D0x44e idProduct=3D0x3=
001=0D
[    1.513377] usb_match_id: id=3Dc1daf4a4 idVendor=3D0x44e idProduct=3D0x3=
002=0D
[    1.514062] usb_match_id: id=3Dc1daf4bc idVendor=3D0xbdb idProduct=3D0x1=
002=0D
[    1.514811] usb_match_id: id=3Dc1daf4d4 idVendor=3D0xc10 idProduct=3D0x0=
=0D
[    1.515501] usb_match_id: id=3Dc1daf4ec idVendor=3D0x489 idProduct=3D0xe=
042=0D
[    1.516185] usb_match_id: id=3Dc1daf504 idVendor=3D0xa5c idProduct=3D0x2=
1e3=0D
[    1.516890] usb_match_id: id=3Dc1daf51c idVendor=3D0xa5c idProduct=3D0x2=
1e6=0D
[    1.517701] usb_match_id: id=3Dc1daf534 idVendor=3D0xa5c idProduct=3D0x2=
1e8=0D
[    1.518769] usb_match_id: id=3Dc1daf54c idVendor=3D0xa5c idProduct=3D0x2=
1f3=0D
[    1.519833] usb_match_id: id=3Dc1daf564 idVendor=3D0x413c idProduct=3D0x=
8197=0D
[    1.520635] usb_match_id: id=3Dc1daf57c idVendor=3D0x489 idProduct=3D0xe=
033=0D
[    1.521330] usbcore: registered new interface driver btusb=0D
[    1.521966] Bluetooth: Generic Bluetooth SDIO driver ver 0.1=0D
[    1.522606] usb_device_match: device 1-0:1.0, driver ath3k =0D
[    1.523207] usb_match_id: id=3Dc1db0048 idVendor=3D0xcf3 idProduct=3D0x3=
000=0D
[    1.523917] usb_match_id: id=3Dc1db0060 idVendor=3D0xcf3 idProduct=3D0x3=
002=0D
[    1.524635] usb_match_id: id=3Dc1db0078 idVendor=3D0xcf3 idProduct=3D0xe=
019=0D
[    1.525331] usb_match_id: id=3Dc1db0090 idVendor=3D0x13d3 idProduct=3D0x=
3304=0D
[    1.526102] usb_match_id: id=3Dc1db00a8 idVendor=3D0x930 idProduct=3D0x2=
15=0D
[    1.526808] usb_match_id: id=3Dc1db00c0 idVendor=3D0x489 idProduct=3D0xe=
03d=0D
[    1.527520] usb_match_id: id=3Dc1db00d8 idVendor=3D0x3f0 idProduct=3D0x3=
11d=0D
[    1.528203] usb_match_id: id=3Dc1db00f0 idVendor=3D0xcf3 idProduct=3D0x3=
004=0D
[    1.528917] usb_match_id: id=3Dc1db0108 idVendor=3D0xcf3 idProduct=3D0x3=
11d=0D
[    1.529671] usb_match_id: id=3Dc1db0120 idVendor=3D0x13d3 idProduct=3D0x=
3375=0D
[    1.530404] usb_match_id: id=3Dc1db0138 idVendor=3D0x4ca idProduct=3D0x3=
005=0D
[    1.531091] usb_match_id: id=3Dc1db0150 idVendor=3D0x13d3 idProduct=3D0x=
3362=0D
[    1.531812] usb_match_id: id=3Dc1db0168 idVendor=3D0xcf3 idProduct=3D0xe=
004=0D
[    1.532534] usb_match_id: id=3Dc1db0180 idVendor=3D0x930 idProduct=3D0x2=
19=0D
[    1.533214] usb_match_id: id=3Dc1db0198 idVendor=3D0x489 idProduct=3D0xe=
02c=0D
[    1.534183] usb_match_id: id=3Dc1db01b0 idVendor=3D0x489 idProduct=3D0xe=
03c=0D
[    1.535319] usbcore: registered new interface driver ath3k=0D
[    1.536169] sdhci: Secure Digital Host Controller Interface driver=0D
[    1.536908] sdhci: Copyright(c) Pierre Ossman=0D
[    1.537453] wbsd: Winbond W83L51xD SD/MMC card interface driver=0D
[    1.538132] wbsd: Copyright(c) Pierre Ossman=0D
[    1.538644] usb 1-1: new high-speed USB device number 2 using dummy_hcd=
=0D
[    1.539410] via_sdmmc: VIA SD/MMC Card Reader driver (C) 2008 VIA Techno=
logies, Inc.=0D
[    1.540272] VUB300 Driver rom wait states =3D 1C irqpoll timeout =3D 040=
0=0D
[    1.541198] usb_device_match: device 1-0:1.0, driver vub300 =0D
[    1.541935] usb_match_id: id=3Dc1db6b04 idVendor=3D0x2201 idProduct=3D0x=
12c=0D
[    1.542676] usb_match_id: id=3Dc1db6b1c idVendor=3D0x424 idProduct=3D0x1=
2c=0D
[    1.543412] usbcore: registered new interface driver vub300=0D
[    1.544008] usb_device_match: device 1-0:1.0, driver ushc =0D
[    1.544649] usb_match_id: id=3Dc1db72a4 idVendor=3D0xa12 idProduct=3D0x5=
d10=0D
[    1.545400] usbcore: registered new interface driver ushc=0D
[    1.545993] sdhci-pltfm: SDHCI platform and OF driver helper=0D
[    1.546783] Driver for HIFN 795x crypto accelerator chip has been succes=
sfully registered.=0D
[    1.547779] usb_device_match: device 1-0:1.0, driver usbmouse =0D
[    1.548489] usb_match_id: id=3Dc1dc0aa8 idVendor=3D0x0 idProduct=3D0x0=0D
[    1.549475] usbcore: registered new interface driver usbmouse=0D
[    1.550476] msi_laptop: driver 0.5 successfully loaded=0D
[    1.551102] hdaps: supported laptop not found!=0D
[    1.551634] hdaps: driver init failed (ret=3D-19)!=0D
[    1.552181] intel_oaktrail: Platform not recognized (You could try the m=
odule's force-parameter)Audio Excel DSP 16 init driver Copyright (C) Riccar=
do Facchetti 1995-98=0D
[    1.553955] aedsp16: I/O, IRQ and DMA are mandatory=0D
[    1.554544] ad1848/cs4248 codec driver Copyright (C) by Hannu Savolainen=
 1993-1996=0D
[    1.555403] ad1848: No ISAPnP cards found, trying standard ones...=0D
[    1.556084] Pro Audio Spectrum driver Copyright (C) by Hannu Savolainen =
1993-1996=0D
[    1.556918] I/O, IRQ, DMA and type are mandatory=0D
[    1.557513] sb: Init: Starting Probe...=0D
[    1.557934] sb: Init: Done=0D
[    1.558255] MIDI Loopback device driver=0D
[    1.559074] usb_device_match: device 1-0:1.0, driver snd-usb-audio =0D
[    1.559781] usb_match_id: id=3Dc1e16d8c idVendor=3D0x403 idProduct=3D0xb=
8d8=0D
[    1.560502] usb_match_id: id=3Dc1e16da4 idVendor=3D0x41e idProduct=3D0x3=
048=0D
[    1.561193] usb_match_id: id=3Dc1e16dbc idVendor=3D0x41e idProduct=3D0x3=
010=0D
[    1.561909] usb_match_id: id=3Dc1e16dd4 idVendor=3D0x41e idProduct=3D0x3=
f02=0D
[    1.562629] usb_match_id: id=3Dc1e16dec idVendor=3D0x41e idProduct=3D0x3=
f04=0D
[    1.563329] usb_match_id: id=3Dc1e16e04 idVendor=3D0x41e idProduct=3D0x3=
f0a=0D
[    1.564034] usb_match_id: id=3Dc1e16e1c idVendor=3D0x41e idProduct=3D0x3=
f19=0D
[    1.564756] usb_match_id: id=3Dc1e16e34 idVendor=3D0x46d idProduct=3D0x8=
50=0D
[    1.565486] usb_match_id: id=3Dc1e16e4c idVendor=3D0x46d idProduct=3D0x8=
ae=0D
[    1.566179] usb_match_id: id=3Dc1e16e64 idVendor=3D0x46d idProduct=3D0x8=
c6=0D
[    1.566900] usb_match_id: id=3Dc1e16e7c idVendor=3D0x46d idProduct=3D0x8=
f0=0D
[    1.567622] usb_match_id: id=3Dc1e16e94 idVendor=3D0x46d idProduct=3D0x8=
f5=0D
[    1.568337] usb_match_id: id=3Dc1e16eac idVendor=3D0x46d idProduct=3D0x8=
f6=0D
[    1.569088] usb_match_id: id=3Dc1e16ec4 idVendor=3D0x46d idProduct=3D0x9=
90=0D
[    1.569819] usb_match_id: id=3Dc1e16edc idVendor=3D0x499 idProduct=3D0x1=
000=0D
[    1.570628] usb_match_id: id=3Dc1e16ef4 idVendor=3D0x499 idProduct=3D0x1=
001=0D
[    1.571575] usb_match_id: id=3Dc1e16f0c idVendor=3D0x499 idProduct=3D0x1=
002=0D
[    1.572377] usb_match_id: id=3Dc1e16f24 idVendor=3D0x499 idProduct=3D0x1=
003=0D
[    1.573131] usb_match_id: id=3Dc1e16f3c idVendor=3D0x499 idProduct=3D0x1=
004=0D
[    1.573877] usb_match_id: id=3Dc1e16f54 idVendor=3D0x499 idProduct=3D0x1=
005=0D
[    1.574679] usb_match_id: id=3Dc1e16f6c idVendor=3D0x499 idProduct=3D0x1=
006=0D
[    1.575713] usb_match_id: id=3Dc1e16f84 idVendor=3D0x499 idProduct=3D0x1=
007=0D
[    1.576781] usb_match_id: id=3Dc1e16f9c idVendor=3D0x499 idProduct=3D0x1=
008=0D
[    1.577796] usb_match_id: id=3Dc1e16fb4 idVendor=3D0x499 idProduct=3D0x1=
009=0D
[    1.578738] usb_match_id: id=3Dc1e16fcc idVendor=3D0x499 idProduct=3D0x1=
00a=0D
[    1.579704] usb_match_id: id=3Dc1e16fe4 idVendor=3D0x499 idProduct=3D0x1=
00c=0D
[    1.580525] usb_match_id: id=3Dc1e16ffc idVendor=3D0x499 idProduct=3D0x1=
00d=0D
[    1.581303] usb_match_id: id=3Dc1e17014 idVendor=3D0x499 idProduct=3D0x1=
00e=0D
[    1.582089] usb_match_id: id=3Dc1e1702c idVendor=3D0x499 idProduct=3D0x1=
00f=0D
[    1.582851] usb_match_id: id=3Dc1e17044 idVendor=3D0x499 idProduct=3D0x1=
010=0D
[    1.583925] usb_match_id: id=3Dc1e1705c idVendor=3D0x499 idProduct=3D0x1=
011=0D
[    1.584977] usb_match_id: id=3Dc1e17074 idVendor=3D0x499 idProduct=3D0x1=
012=0D
[    1.586041] usb_match_id: id=3Dc1e1708c idVendor=3D0x499 idProduct=3D0x1=
013=0D
[    1.586866] usb_match_id: id=3Dc1e170a4 idVendor=3D0x499 idProduct=3D0x1=
014=0D
[    1.587666] usb_match_id: id=3Dc1e170bc idVendor=3D0x499 idProduct=3D0x1=
015=0D
[    1.588420] usb_match_id: id=3Dc1e170d4 idVendor=3D0x499 idProduct=3D0x1=
016=0D
[    1.589155] usb_match_id: id=3Dc1e170ec idVendor=3D0x499 idProduct=3D0x1=
017=0D
[    1.589888] usb_match_id: id=3Dc1e17104 idVendor=3D0x499 idProduct=3D0x1=
018=0D
[    1.590720] usb_match_id: id=3Dc1e1711c idVendor=3D0x499 idProduct=3D0x1=
019=0D
[    1.591494] usb_match_id: id=3Dc1e17134 idVendor=3D0x499 idProduct=3D0x1=
01a=0D
[    1.592102]  gadget: resume=0D
[    1.592107] dummy_hcd dummy_hcd: port status 0x00100503 has changes=0D
[    1.593247] usb_match_id: id=3Dc1e1714c idVendor=3D0x499 idProduct=3D0x1=
01b=0D
[    1.593965] usb_match_id: id=3Dc1e17164 idVendor=3D0x499 idProduct=3D0x1=
01c=0D
[    1.594793] usb_match_id: id=3Dc1e1717c idVendor=3D0x499 idProduct=3D0x1=
01d=0D
[    1.595648] usb_match_id: id=3Dc1e17194 idVendor=3D0x499 idProduct=3D0x1=
01e=0D
[    1.596411] usb_match_id: id=3Dc1e171ac idVendor=3D0x499 idProduct=3D0x1=
01f=0D
[    1.597113] usb_match_id: id=3Dc1e171c4 idVendor=3D0x499 idProduct=3D0x1=
020=0D
[    1.597888] usb_match_id: id=3Dc1e171dc idVendor=3D0x499 idProduct=3D0x1=
021=0D
[    1.598616] usb_match_id: id=3Dc1e171f4 idVendor=3D0x499 idProduct=3D0x1=
022=0D
[    1.599322] usb_match_id: id=3Dc1e1720c idVendor=3D0x499 idProduct=3D0x1=
023=0D
[    1.600109] usb_match_id: id=3Dc1e17224 idVendor=3D0x499 idProduct=3D0x1=
024=0D
[    1.600849] usb_match_id: id=3Dc1e1723c idVendor=3D0x499 idProduct=3D0x1=
025=0D
[    1.601570] usb_match_id: id=3Dc1e17254 idVendor=3D0x499 idProduct=3D0x1=
026=0D
[    1.602511] usb_match_id: id=3Dc1e1726c idVendor=3D0x499 idProduct=3D0x1=
027=0D
[    1.603261] usb_match_id: id=3Dc1e17284 idVendor=3D0x499 idProduct=3D0x1=
028=0D
[    1.603988] usb_match_id: id=3Dc1e1729c idVendor=3D0x499 idProduct=3D0x1=
029=0D
[    1.604732] usb_match_id: id=3Dc1e172b4 idVendor=3D0x499 idProduct=3D0x1=
02a=0D
[    1.605504] usb_match_id: id=3Dc1e172cc idVendor=3D0x499 idProduct=3D0x1=
02b=0D
[    1.606200] usb_match_id: id=3Dc1e172e4 idVendor=3D0x499 idProduct=3D0x1=
02e=0D
[    1.606938] usb_match_id: id=3Dc1e172fc idVendor=3D0x499 idProduct=3D0x1=
030=0D
[    1.607673] usb_match_id: id=3Dc1e17314 idVendor=3D0x499 idProduct=3D0x1=
031=0D
[    1.608407] usb_match_id: id=3Dc1e1732c idVendor=3D0x499 idProduct=3D0x1=
032=0D
[    1.609135] usb_match_id: id=3Dc1e17344 idVendor=3D0x499 idProduct=3D0x1=
033=0D
[    1.610176] usb_match_id: id=3Dc1e1735c idVendor=3D0x499 idProduct=3D0x1=
034=0D
[    1.611130] usb_match_id: id=3Dc1e17374 idVendor=3D0x499 idProduct=3D0x1=
035=0D
[    1.612128] usb_match_id: id=3Dc1e1738c idVendor=3D0x499 idProduct=3D0x1=
036=0D
[    1.613133] usb_match_id: id=3Dc1e173a4 idVendor=3D0x499 idProduct=3D0x1=
037=0D
[    1.614184] usb_match_id: id=3Dc1e173bc idVendor=3D0x499 idProduct=3D0x1=
038=0D
[    1.615164] usb_match_id: id=3Dc1e173d4 idVendor=3D0x499 idProduct=3D0x1=
039=0D
[    1.615903] usb_match_id: id=3Dc1e173ec idVendor=3D0x499 idProduct=3D0x1=
03a=0D
[    1.616796] usb_match_id: id=3Dc1e17404 idVendor=3D0x499 idProduct=3D0x1=
03b=0D
[    1.617817] usb_match_id: id=3Dc1e1741c idVendor=3D0x499 idProduct=3D0x1=
03c=0D
[    1.618872] usb_match_id: id=3Dc1e17434 idVendor=3D0x499 idProduct=3D0x1=
03d=0D
[    1.619774] usb_match_id: id=3Dc1e1744c idVendor=3D0x499 idProduct=3D0x1=
03e=0D
[    1.620754] usb_match_id: id=3Dc1e17464 idVendor=3D0x499 idProduct=3D0x1=
03f=0D
[    1.621823] usb_match_id: id=3Dc1e1747c idVendor=3D0x499 idProduct=3D0x1=
040=0D
[    1.622882] usb_match_id: id=3Dc1e17494 idVendor=3D0x499 idProduct=3D0x1=
041=0D
[    1.623671] usb_match_id: id=3Dc1e174ac idVendor=3D0x499 idProduct=3D0x1=
042=0D
[    1.624445] usb_match_id: id=3Dc1e174c4 idVendor=3D0x499 idProduct=3D0x1=
043=0D
[    1.625202] usb_match_id: id=3Dc1e174dc idVendor=3D0x499 idProduct=3D0x1=
044=0D
[    1.625922] usb_match_id: id=3Dc1e174f4 idVendor=3D0x499 idProduct=3D0x1=
045=0D
[    1.626679] usb_match_id: id=3Dc1e1750c idVendor=3D0x499 idProduct=3D0x1=
04e=0D
[    1.627450] usb_match_id: id=3Dc1e17524 idVendor=3D0x499 idProduct=3D0x1=
04f=0D
[    1.628197] usb_match_id: id=3Dc1e1753c idVendor=3D0x499 idProduct=3D0x1=
050=0D
[    1.628912] usb_match_id: id=3Dc1e17554 idVendor=3D0x499 idProduct=3D0x1=
051=0D
[    1.629805] usb_match_id: id=3Dc1e1756c idVendor=3D0x499 idProduct=3D0x1=
052=0D
[    1.630843] usb_match_id: id=3Dc1e17584 idVendor=3D0x499 idProduct=3D0x1=
053=0D
[    1.631584] usb_match_id: id=3Dc1e1759c idVendor=3D0x499 idProduct=3D0x1=
054=0D
[    1.632343] usb_match_id: id=3Dc1e175b4 idVendor=3D0x499 idProduct=3D0x1=
055=0D
[    1.633040] usb_match_id: id=3Dc1e175cc idVendor=3D0x499 idProduct=3D0x1=
056=0D
[    1.633887] usb_match_id: id=3Dc1e175e4 idVendor=3D0x499 idProduct=3D0x1=
057=0D
[    1.634634] usb_match_id: id=3Dc1e175fc idVendor=3D0x499 idProduct=3D0x1=
058=0D
[    1.635378] usb_match_id: id=3Dc1e17614 idVendor=3D0x499 idProduct=3D0x1=
059=0D
[    1.636104] usb_match_id: id=3Dc1e1762c idVendor=3D0x499 idProduct=3D0x1=
05a=0D
[    1.636855] usb_match_id: id=3Dc1e17644 idVendor=3D0x499 idProduct=3D0x1=
05b=0D
[    1.637687] usb_match_id: id=3Dc1e1765c idVendor=3D0x499 idProduct=3D0x1=
05c=0D
[    1.638421] usb_match_id: id=3Dc1e17674 idVendor=3D0x499 idProduct=3D0x1=
05d=0D
[    1.639133] usb_match_id: id=3Dc1e1768c idVendor=3D0x499 idProduct=3D0x1=
503=0D
[    1.639922] usb_match_id: id=3Dc1e176a4 idVendor=3D0x499 idProduct=3D0x2=
000=0D
[    1.640712] usb_match_id: id=3Dc1e176bc idVendor=3D0x499 idProduct=3D0x2=
001=0D
[    1.641492] usb_match_id: id=3Dc1e176d4 idVendor=3D0x499 idProduct=3D0x2=
002=0D
[    1.642191] usb_match_id: id=3Dc1e176ec idVendor=3D0x499 idProduct=3D0x2=
003=0D
[    1.642904] usb_match_id: id=3Dc1e17704 idVendor=3D0x499 idProduct=3D0x5=
000=0D
[    1.643688] usb_match_id: id=3Dc1e1771c idVendor=3D0x499 idProduct=3D0x5=
001=0D
[    1.644079] dummy_udc dummy_udc: set_address =3D 2=0D
[    1.644960] usb_match_id: id=3Dc1e17734 idVendor=3D0x499 idProduct=3D0x5=
002=0D
[    1.645748] usb_match_id: id=3Dc1e1774c idVendor=3D0x499 idProduct=3D0x5=
003=0D
[    1.646521] usb_match_id: id=3Dc1e17764 idVendor=3D0x499 idProduct=3D0x5=
004=0D
[    1.647303] usb_match_id: id=3Dc1e1777c idVendor=3D0x499 idProduct=3D0x5=
005=0D
[    1.648119] usb_match_id: id=3Dc1e17794 idVendor=3D0x499 idProduct=3D0x5=
006=0D
[    1.648862] usb_match_id: id=3Dc1e177ac idVendor=3D0x499 idProduct=3D0x5=
007=0D
[    1.649628] usb_match_id: id=3Dc1e177c4 idVendor=3D0x499 idProduct=3D0x5=
008=0D
[    1.650429] usb_match_id: id=3Dc1e177dc idVendor=3D0x499 idProduct=3D0x5=
009=0D
[    1.651170] usb_match_id: id=3Dc1e177f4 idVendor=3D0x499 idProduct=3D0x5=
00a=0D
[    1.651893] usb_match_id: id=3Dc1e1780c idVendor=3D0x499 idProduct=3D0x5=
00b=0D
[    1.652650] usb_match_id: id=3Dc1e17824 idVendor=3D0x499 idProduct=3D0x5=
00c=0D
[    1.653444] usb_match_id: id=3Dc1e1783c idVendor=3D0x499 idProduct=3D0x5=
00d=0D
[    1.654253] usb_match_id: id=3Dc1e17854 idVendor=3D0x499 idProduct=3D0x5=
00e=0D
[    1.654998] usb_match_id: id=3Dc1e1786c idVendor=3D0x499 idProduct=3D0x5=
00f=0D
[    1.655819] usb_match_id: id=3Dc1e17884 idVendor=3D0x499 idProduct=3D0x7=
000=0D
[    1.656623] usb_match_id: id=3Dc1e1789c idVendor=3D0x499 idProduct=3D0x7=
010=0D
[    1.657398] usb_match_id: id=3Dc1e178b4 idVendor=3D0x582 idProduct=3D0x0=
=0D
[    1.658242] usb_match_id: id=3Dc1e178cc idVendor=3D0x582 idProduct=3D0x2=
=0D
[    1.658956] usb_match_id: id=3Dc1e178e4 idVendor=3D0x582 idProduct=3D0x3=
=0D
[    1.659718] usb_match_id: id=3Dc1e178fc idVendor=3D0x582 idProduct=3D0x4=
=0D
[    1.660458] usb_match_id: id=3Dc1e17914 idVendor=3D0x582 idProduct=3D0x5=
=0D
[    1.661181] usb_match_id: id=3Dc1e1792c idVendor=3D0x582 idProduct=3D0x7=
=0D
[    1.661985] usb_match_id: id=3Dc1e17944 idVendor=3D0x582 idProduct=3D0x8=
=0D
[    1.662780] usb_match_id: id=3Dc1e1795c idVendor=3D0x582 idProduct=3D0x9=
=0D
[    1.663544] usb_match_id: id=3Dc1e17974 idVendor=3D0x582 idProduct=3D0xb=
=0D
[    1.664298] usb_match_id: id=3Dc1e1798c idVendor=3D0x582 idProduct=3D0xc=
=0D
[    1.665000] usb_match_id: id=3Dc1e179a4 idVendor=3D0x582 idProduct=3D0x1=
0=0D
[    1.665741] usb_match_id: id=3Dc1e179bc idVendor=3D0x582 idProduct=3D0x1=
2=0D
[    1.666088]  gadget: high-speed config #1: CDC Ethernet (ECM)=0D
[    1.666097] dummy_udc dummy_udc: enabled ep-c (ep3in-intr) maxpacket 16 =
stream disabled=0D
[    1.666098]  gadget: init ecm=0D
[    1.666100]  gadget: notify connect false=0D
[    1.666101]  gadget: notify speed 425984000=0D
[    1.667094] usb_device_match: device 1-1:1.0, driver usbfs =0D
[    1.667097] usb_device_match: device 1-1:1.0, driver hub =0D
[    1.667099] usb_match_id: id=3Dc1a87214 idVendor=3D0x0 idProduct=3D0x0=0D
[    1.667101] usb_match_id: id=3Dc1a8722c idVendor=3D0x0 idProduct=3D0x0=0D
[    1.667103] usb_device_match: device 1-1:1.0, driver udlfb =0D
[    1.667104] usb_match_id: id=3Dc1ccbc68 idVendor=3D0x17e9 idProduct=3D0x=
0=0D
[    1.667106] usb_device_match: device 1-1:1.0, driver smscufx =0D
[    1.667107] usb_match_id: id=3Dc1ccc5dc idVendor=3D0x424 idProduct=3D0x9=
d00=0D
[    1.667109] usb_match_id: id=3Dc1ccc5f4 idVendor=3D0x424 idProduct=3D0x9=
d01=0D
[    1.667111] usb_device_match: device 1-1:1.0, driver alauda =0D
[    1.667112] usb_match_id: id=3Dc1a810a4 idVendor=3D0x584 idProduct=3D0x8=
=0D
[    1.667113] usb_match_id: id=3Dc1a810bc idVendor=3D0x7b4 idProduct=3D0x1=
0a=0D
[    1.667115] usb_device_match: device 1-1:1.0, driver kaweth =0D
[    1.667117] usb_match_id: id=3Dc1d1e1e4 idVendor=3D0x3e8 idProduct=3D0x8=
=0D
[    1.667118] usb_match_id: id=3Dc1d1e1fc idVendor=3D0x4bb idProduct=3D0x9=
01=0D
[    1.667120] usb_match_id: id=3Dc1d1e214 idVendor=3D0x506 idProduct=3D0x3=
e8=0D
[    1.667121] usb_match_id: id=3Dc1d1e22c idVendor=3D0x506 idProduct=3D0x1=
1f8=0D
[    1.667122] usb_match_id: id=3Dc1d1e244 idVendor=3D0x557 idProduct=3D0x2=
002=0D
[    1.667124] usb_match_id: id=3Dc1d1e25c idVendor=3D0x557 idProduct=3D0x4=
000=0D
[    1.667125] usb_match_id: id=3Dc1d1e274 idVendor=3D0x565 idProduct=3D0x2=
=0D
[    1.667127] usb_match_id: id=3Dc1d1e28c idVendor=3D0x565 idProduct=3D0x3=
=0D
[    1.667128] usb_match_id: id=3Dc1d1e2a4 idVendor=3D0x565 idProduct=3D0x5=
=0D
[    1.667129] usb_match_id: id=3Dc1d1e2bc idVendor=3D0x5e9 idProduct=3D0x8=
=0D
[    1.667131] usb_match_id: id=3Dc1d1e2d4 idVendor=3D0x5e9 idProduct=3D0x9=
=0D
[    1.667132] usb_match_id: id=3Dc1d1e2ec idVendor=3D0x66b idProduct=3D0x2=
202=0D
[    1.667134] usb_match_id: id=3Dc1d1e304 idVendor=3D0x6e1 idProduct=3D0x8=
=0D
[    1.667135] usb_match_id: id=3Dc1d1e31c idVendor=3D0x6e1 idProduct=3D0x9=
=0D
[    1.667136] usb_match_id: id=3Dc1d1e334 idVendor=3D0x707 idProduct=3D0x1=
00=0D
[    1.667138] usb_match_id: id=3Dc1d1e34c idVendor=3D0x7aa idProduct=3D0x1=
=0D
[    1.667139] usb_match_id: id=3Dc1d1e364 idVendor=3D0x7b8 idProduct=3D0x4=
000=0D
[    1.667141] usb_match_id: id=3Dc1d1e37c idVendor=3D0x7c9 idProduct=3D0xb=
010=0D
[    1.667142] usb_match_id: id=3Dc1d1e394 idVendor=3D0x846 idProduct=3D0x1=
001=0D
[    1.667143] usb_match_id: id=3Dc1d1e3ac idVendor=3D0x846 idProduct=3D0x1=
002=0D
[    1.667145] usb_match_id: id=3Dc1d1e3c4 idVendor=3D0x85a idProduct=3D0x8=
=0D
[    1.667146] usb_match_id: id=3Dc1d1e3dc idVendor=3D0x85a idProduct=3D0x9=
=0D
[    1.667148] usb_match_id: id=3Dc1d1e3f4 idVendor=3D0x87d idProduct=3D0x5=
704=0D
[    1.667149] usb_match_id: id=3Dc1d1e40c idVendor=3D0x951 idProduct=3D0x8=
=0D
[    1.667150] usb_match_id: id=3Dc1d1e424 idVendor=3D0x95a idProduct=3D0x3=
003=0D
[    1.667152] usb_match_id: id=3Dc1d1e43c idVendor=3D0x10bd idProduct=3D0x=
1427=0D
[    1.667153] usb_match_id: id=3Dc1d1e454 idVendor=3D0x1342 idProduct=3D0x=
204=0D
[    1.667154] usb_match_id: id=3Dc1d1e46c idVendor=3D0x13d2 idProduct=3D0x=
400=0D
[    1.667156] usb_match_id: id=3Dc1d1e484 idVendor=3D0x1485 idProduct=3D0x=
1=0D
[    1.667157] usb_match_id: id=3Dc1d1e49c idVendor=3D0x1485 idProduct=3D0x=
2=0D
[    1.667159] usb_match_id: id=3Dc1d1e4b4 idVendor=3D0x1645 idProduct=3D0x=
5=0D
[    1.667160] usb_match_id: id=3Dc1d1e4cc idVendor=3D0x1645 idProduct=3D0x=
8=0D
[    1.667161] usb_match_id: id=3Dc1d1e4e4 idVendor=3D0x1645 idProduct=3D0x=
8005=0D
[    1.667163] usb_match_id: id=3Dc1d1e4fc idVendor=3D0x1668 idProduct=3D0x=
323=0D
[    1.667164] usb_match_id: id=3Dc1d1e514 idVendor=3D0x2001 idProduct=3D0x=
4000=0D
[    1.667166] usb_device_match: device 1-1:1.0, driver pegasus =0D
[    1.667167] usb_match_id: id=3Dc1d1ebd8 idVendor=3D0x506 idProduct=3D0x4=
601=0D
[    1.667169] usb_match_id: id=3Dc1d1ebf0 idVendor=3D0x557 idProduct=3D0x2=
007=0D
[    1.667170] usb_match_id: id=3Dc1d1ec08 idVendor=3D0x7b8 idProduct=3D0x1=
10c=0D
[    1.667176] usb_match_id: id=3Dc1d1ec20 idVendor=3D0x7b8 idProduct=3D0x4=
104=0D
[    1.667178] usb_match_id: id=3Dc1d1ec38 idVendor=3D0x7b8 idProduct=3D0x4=
004=0D
[    1.667179] usb_match_id: id=3Dc1d1ec50 idVendor=3D0x7b8 idProduct=3D0x4=
007=0D
[    1.667180] usb_match_id: id=3Dc1d1ec68 idVendor=3D0x7b8 idProduct=3D0x4=
102=0D
[    1.667182] usb_match_id: id=3Dc1d1ec80 idVendor=3D0x7b8 idProduct=3D0x4=
002=0D
[    1.667183] usb_match_id: id=3Dc1d1ec98 idVendor=3D0x7b8 idProduct=3D0x4=
00b=0D
[    1.667184] usb_match_id: id=3Dc1d1ecb0 idVendor=3D0x7b8 idProduct=3D0x4=
00c=0D
[    1.667186] usb_match_id: id=3Dc1d1ecc8 idVendor=3D0x7b8 idProduct=3D0xa=
bc1=0D
[    1.667187] usb_match_id: id=3Dc1d1ece0 idVendor=3D0x7b8 idProduct=3D0x2=
00c=0D
[    1.667188] usb_match_id: id=3Dc1d1ecf8 idVendor=3D0x83a idProduct=3D0x1=
046=0D
[    1.667190] usb_match_id: id=3Dc1d1ed10 idVendor=3D0x83a idProduct=3D0x5=
046=0D
[    1.667191] usb_match_id: id=3Dc1d1ed28 idVendor=3D0x83a idProduct=3D0xb=
004=0D
[    1.667192] usb_match_id: id=3Dc1d1ed40 idVendor=3D0x7a6 idProduct=3D0x8=
511=0D
[    1.667194] usb_match_id: id=3Dc1d1ed58 idVendor=3D0x7a6 idProduct=3D0x8=
513=0D
[    1.667195] usb_match_id: id=3Dc1d1ed70 idVendor=3D0x7a6 idProduct=3D0x8=
515=0D
[    1.667197] usb_match_id: id=3Dc1d1ed88 idVendor=3D0x7a6 idProduct=3D0x9=
86=0D
[    1.667198] usb_match_id: id=3Dc1d1eda0 idVendor=3D0x7a6 idProduct=3D0x7=
c2=0D
[    1.667199] usb_match_id: id=3Dc1d1edb8 idVendor=3D0x3334 idProduct=3D0x=
1701=0D
[    1.667201] usb_match_id: id=3Dc1d1edd0 idVendor=3D0x7c9 idProduct=3D0xb=
100=0D
[    1.667202] usb_match_id: id=3Dc1d1ede8 idVendor=3D0x50d idProduct=3D0x1=
21=0D
[    1.667204] usb_match_id: id=3Dc1d1ee00 idVendor=3D0x50d idProduct=3D0x1=
22=0D
[    1.667205] usb_match_id: id=3Dc1d1ee18 idVendor=3D0x8dd idProduct=3D0x9=
86=0D
[    1.667206] usb_match_id: id=3Dc1d1ee30 idVendor=3D0x8dd idProduct=3D0x9=
87=0D
[    1.667208] usb_match_id: id=3Dc1d1ee48 idVendor=3D0x49f idProduct=3D0x8=
511=0D
[    1.667209] usb_match_id: id=3Dc1d1ee60 idVendor=3D0x8dd idProduct=3D0x9=
88=0D
[    1.667211] usb_match_id: id=3Dc1d1ee78 idVendor=3D0x8dd idProduct=3D0x8=
511=0D
[    1.667212] usb_match_id: id=3Dc1d1ee90 idVendor=3D0x7aa idProduct=3D0x4=
=0D
[    1.667213] usb_match_id: id=3Dc1d1eea8 idVendor=3D0x7aa idProduct=3D0xd=
=0D
[    1.667215] usb_match_id: id=3Dc1d1eec0 idVendor=3D0x2001 idProduct=3D0x=
4001=0D
[    1.667216] usb_match_id: id=3Dc1d1eed8 idVendor=3D0x2001 idProduct=3D0x=
4002=0D
[    1.667218] usb_match_id: id=3Dc1d1eef0 idVendor=3D0x2001 idProduct=3D0x=
4102=0D
[    1.667219] usb_match_id: id=3Dc1d1ef08 idVendor=3D0x2001 idProduct=3D0x=
400b=0D
[    1.667220] usb_match_id: id=3Dc1d1ef20 idVendor=3D0x2001 idProduct=3D0x=
200c=0D
[    1.667222] usb_match_id: id=3Dc1d1ef38 idVendor=3D0x2001 idProduct=3D0x=
4003=0D
[    1.667223] usb_match_id: id=3Dc1d1ef50 idVendor=3D0x2001 idProduct=3D0x=
abc1=0D
[    1.667225] usb_match_id: id=3Dc1d1ef68 idVendor=3D0xdb7 idProduct=3D0x2=
=0D
[    1.667226] usb_match_id: id=3Dc1d1ef80 idVendor=3D0x56e idProduct=3D0x4=
010=0D
[    1.667227] usb_match_id: id=3Dc1d1ef98 idVendor=3D0x1342 idProduct=3D0x=
304=0D
[    1.667229] usb_match_id: id=3Dc1d1efb0 idVendor=3D0x5cc idProduct=3D0x3=
000=0D
[    1.667230] usb_match_id: id=3Dc1d1efc8 idVendor=3D0x1044 idProduct=3D0x=
8002=0D
[    1.667232] usb_match_id: id=3Dc1d1efe0 idVendor=3D0xe66 idProduct=3D0x4=
00c=0D
[    1.667233] usb_match_id: id=3Dc1d1eff8 idVendor=3D0x3f0 idProduct=3D0x8=
11c=0D
[    1.667235] usb_match_id: id=3Dc1d1f010 idVendor=3D0x4bb idProduct=3D0x9=
04=0D
[    1.667236] usb_match_id: id=3Dc1d1f028 idVendor=3D0x4bb idProduct=3D0x9=
13=0D
[    1.667237] usb_match_id: id=3Dc1d1f040 idVendor=3D0x4bb idProduct=3D0x9=
3a=0D
[    1.667239] usb_match_id: id=3Dc1d1f058 idVendor=3D0x951 idProduct=3D0xa=
=0D
[    1.667240] usb_match_id: id=3Dc1d1f070 idVendor=3D0x56e idProduct=3D0x4=
002=0D
[    1.667242] usb_match_id: id=3Dc1d1f088 idVendor=3D0x56e idProduct=3D0x4=
005=0D
[    1.667243] usb_match_id: id=3Dc1d1f0a0 idVendor=3D0x56e idProduct=3D0x4=
00b=0D
[    1.667244] usb_match_id: id=3Dc1d1f0b8 idVendor=3D0x56e idProduct=3D0xa=
bc1=0D
[    1.667246] usb_match_id: id=3Dc1d1f0d0 idVendor=3D0x56e idProduct=3D0x2=
00c=0D
[    1.667247] usb_match_id: id=3Dc1d1f0e8 idVendor=3D0x66b idProduct=3D0x2=
202=0D
[    1.667249] usb_match_id: id=3Dc1d1f100 idVendor=3D0x66b idProduct=3D0x2=
203=0D
[    1.667250] usb_match_id: id=3Dc1d1f118 idVendor=3D0x66b idProduct=3D0x2=
204=0D
[    1.667254] usb_match_id: id=3Dc1d1f130 idVendor=3D0x66b idProduct=3D0x2=
206=0D
[    1.667255] usb_match_id: id=3Dc1d1f148 idVendor=3D0x77b idProduct=3D0x8=
b4=0D
[    1.667257] usb_match_id: id=3Dc1d1f160 idVendor=3D0x66b idProduct=3D0x4=
00b=0D
[    1.667258] usb_match_id: id=3Dc1d1f178 idVendor=3D0x66b idProduct=3D0x2=
00c=0D
[    1.667259] usb_match_id: id=3Dc1d1f190 idVendor=3D0x411 idProduct=3D0x1=
=0D
[    1.667261] usb_match_id: id=3Dc1d1f1a8 idVendor=3D0x411 idProduct=3D0x5=
=0D
[    1.667262] usb_match_id: id=3Dc1d1f1c0 idVendor=3D0x411 idProduct=3D0x9=
=0D
[    1.667264] usb_match_id: id=3Dc1d1f1d8 idVendor=3D0x45e idProduct=3D0x7=
a=0D
[    1.667265] usb_match_id: id=3Dc1d1f1f0 idVendor=3D0x846 idProduct=3D0x1=
020=0D
[    1.667266] usb_match_id: id=3Dc1d1f208 idVendor=3D0xb39 idProduct=3D0x1=
09=0D
[    1.667268] usb_match_id: id=3Dc1d1f220 idVendor=3D0xb39 idProduct=3D0x9=
01=0D
[    1.667269] usb_match_id: id=3Dc1d1f238 idVendor=3D0x8d1 idProduct=3D0x3=
=0D
[    1.667270] usb_match_id: id=3Dc1d1f250 idVendor=3D0x707 idProduct=3D0x2=
00=0D
[    1.667272] usb_match_id: id=3Dc1d1f268 idVendor=3D0x707 idProduct=3D0x2=
01=0D
[    1.667273] usb_match_id: id=3Dc1d1f280 idVendor=3D0x15e8 idProduct=3D0x=
9100=0D
[    1.667274] usb_match_id: id=3Dc1d1f298 idVendor=3D0x15e8 idProduct=3D0x=
9110=0D
[    1.667276] usb_match_id: id=3Dc1d1f2b0 idVendor=3D0x67c idProduct=3D0x1=
001=0D
[    1.667278] usb_device_match: device 1-1:1.0, driver hso =0D
[    1.667279] usb_match_id: id=3Dc1a84c64 idVendor=3D0xaf0 idProduct=3D0x6=
711=0D
[    1.667281] usb_match_id: id=3Dc1a84c7c idVendor=3D0xaf0 idProduct=3D0x6=
731=0D
[    1.667282] usb_match_id: id=3Dc1a84c94 idVendor=3D0xaf0 idProduct=3D0x6=
751=0D
[    1.667284] usb_match_id: id=3Dc1a84cac idVendor=3D0xaf0 idProduct=3D0x6=
771=0D
[    1.667285] usb_match_id: id=3Dc1a84cc4 idVendor=3D0xaf0 idProduct=3D0x6=
791=0D
[    1.667286] usb_match_id: id=3Dc1a84cdc idVendor=3D0xaf0 idProduct=3D0x6=
811=0D
[    1.667288] usb_match_id: id=3Dc1a84cf4 idVendor=3D0xaf0 idProduct=3D0x6=
911=0D
[    1.667289] usb_match_id: id=3Dc1a84d0c idVendor=3D0xaf0 idProduct=3D0x6=
951=0D
[    1.667290] usb_match_id: id=3Dc1a84d24 idVendor=3D0xaf0 idProduct=3D0x6=
971=0D
[    1.667292] usb_match_id: id=3Dc1a84d3c idVendor=3D0xaf0 idProduct=3D0x7=
011=0D
[    1.667293] usb_match_id: id=3Dc1a84d54 idVendor=3D0xaf0 idProduct=3D0x7=
031=0D
[    1.667295] usb_match_id: id=3Dc1a84d6c idVendor=3D0xaf0 idProduct=3D0x7=
051=0D
[    1.667296] usb_match_id: id=3Dc1a84d84 idVendor=3D0xaf0 idProduct=3D0x7=
071=0D
[    1.667297] usb_match_id: id=3Dc1a84d9c idVendor=3D0xaf0 idProduct=3D0x7=
111=0D
[    1.667299] usb_match_id: id=3Dc1a84db4 idVendor=3D0xaf0 idProduct=3D0x7=
211=0D
[    1.667300] usb_match_id: id=3Dc1a84dcc idVendor=3D0xaf0 idProduct=3D0x7=
251=0D
[    1.667302] usb_match_id: id=3Dc1a84de4 idVendor=3D0xaf0 idProduct=3D0x7=
271=0D
[    1.667303] usb_match_id: id=3Dc1a84dfc idVendor=3D0xaf0 idProduct=3D0x7=
311=0D
[    1.667304] usb_match_id: id=3Dc1a84e14 idVendor=3D0xaf0 idProduct=3D0xc=
031=0D
[    1.667306] usb_match_id: id=3Dc1a84e2c idVendor=3D0xaf0 idProduct=3D0xd=
013=0D
[    1.667307] usb_match_id: id=3Dc1a84e44 idVendor=3D0xaf0 idProduct=3D0xd=
031=0D
[    1.667309] usb_match_id: id=3Dc1a84e5c idVendor=3D0xaf0 idProduct=3D0xd=
033=0D
[    1.667310] usb_match_id: id=3Dc1a84e74 idVendor=3D0xaf0 idProduct=3D0x7=
301=0D
[    1.667311] usb_match_id: id=3Dc1a84e8c idVendor=3D0xaf0 idProduct=3D0x7=
361=0D
[    1.667313] usb_match_id: id=3Dc1a84ea4 idVendor=3D0xaf0 idProduct=3D0x7=
381=0D
[    1.667314] usb_match_id: id=3Dc1a84ebc idVendor=3D0xaf0 idProduct=3D0x7=
401=0D
[    1.667316] usb_match_id: id=3Dc1a84ed4 idVendor=3D0xaf0 idProduct=3D0x7=
501=0D
[    1.667317] usb_match_id: id=3Dc1a84eec idVendor=3D0xaf0 idProduct=3D0x7=
601=0D
[    1.667318] usb_match_id: id=3Dc1a84f04 idVendor=3D0xaf0 idProduct=3D0x7=
701=0D
[    1.667320] usb_match_id: id=3Dc1a84f1c idVendor=3D0xaf0 idProduct=3D0x7=
706=0D
[    1.667321] usb_match_id: id=3Dc1a84f34 idVendor=3D0xaf0 idProduct=3D0x7=
801=0D
[    1.667323] usb_match_id: id=3Dc1a84f4c idVendor=3D0xaf0 idProduct=3D0x7=
901=0D
[    1.667324] usb_match_id: id=3Dc1a84f64 idVendor=3D0xaf0 idProduct=3D0x7=
a01=0D
[    1.667325] usb_match_id: id=3Dc1a84f7c idVendor=3D0xaf0 idProduct=3D0x7=
a05=0D
[    1.667327] usb_match_id: id=3Dc1a84f94 idVendor=3D0xaf0 idProduct=3D0x8=
200=0D
[    1.667328] usb_match_id: id=3Dc1a84fac idVendor=3D0xaf0 idProduct=3D0x8=
201=0D
[    1.667330] usb_match_id: id=3Dc1a84fc4 idVendor=3D0xaf0 idProduct=3D0x8=
300=0D
[    1.667333] usb_match_id: id=3Dc1a84fdc idVendor=3D0xaf0 idProduct=3D0x8=
302=0D
[    1.667335] usb_match_id: id=3Dc1a84ff4 idVendor=3D0xaf0 idProduct=3D0x8=
304=0D
[    1.667336] usb_match_id: id=3Dc1a8500c idVendor=3D0xaf0 idProduct=3D0x8=
400=0D
[    1.667338] usb_match_id: id=3Dc1a85024 idVendor=3D0xaf0 idProduct=3D0x8=
600=0D
[    1.667339] usb_match_id: id=3Dc1a8503c idVendor=3D0xaf0 idProduct=3D0x8=
800=0D
[    1.667340] usb_match_id: id=3Dc1a85054 idVendor=3D0xaf0 idProduct=3D0x8=
900=0D
[    1.667342] usb_match_id: id=3Dc1a8506c idVendor=3D0xaf0 idProduct=3D0x9=
000=0D
[    1.667343] usb_match_id: id=3Dc1a85084 idVendor=3D0xaf0 idProduct=3D0xd=
035=0D
[    1.667345] usb_match_id: id=3Dc1a8509c idVendor=3D0xaf0 idProduct=3D0xd=
055=0D
[    1.667346] usb_match_id: id=3Dc1a850b4 idVendor=3D0xaf0 idProduct=3D0xd=
155=0D
[    1.667347] usb_match_id: id=3Dc1a850cc idVendor=3D0xaf0 idProduct=3D0xd=
255=0D
[    1.667349] usb_match_id: id=3Dc1a850e4 idVendor=3D0xaf0 idProduct=3D0xd=
057=0D
[    1.667350] usb_match_id: id=3Dc1a850fc idVendor=3D0xaf0 idProduct=3D0xd=
157=0D
[    1.667352] usb_match_id: id=3Dc1a85114 idVendor=3D0xaf0 idProduct=3D0xd=
257=0D
[    1.667353] usb_match_id: id=3Dc1a8512c idVendor=3D0xaf0 idProduct=3D0xd=
357=0D
[    1.667377] usb_match_id: id=3Dc1a85144 idVendor=3D0xaf0 idProduct=3D0xd=
058=0D
[    1.667378] usb_match_id: id=3Dc1a8515c idVendor=3D0xaf0 idProduct=3D0xc=
100=0D
[    1.667380] usb_device_match: device 1-1:1.0, driver asix =0D
[    1.667382] usb_match_id: id=3Dc1a85594 idVendor=3D0x77b idProduct=3D0x2=
226=0D
[    1.667383] usb_match_id: id=3Dc1a855ac idVendor=3D0x846 idProduct=3D0x1=
040=0D
[    1.667384] usb_match_id: id=3Dc1a855c4 idVendor=3D0x2001 idProduct=3D0x=
1a00=0D
[    1.667386] usb_match_id: id=3Dc1a855dc idVendor=3D0xb95 idProduct=3D0x1=
720=0D
[    1.667387] usb_match_id: id=3Dc1a855f4 idVendor=3D0x7b8 idProduct=3D0x4=
20a=0D
[    1.667388] usb_match_id: id=3Dc1a8560c idVendor=3D0x8dd idProduct=3D0x9=
0ff=0D
[    1.667390] usb_match_id: id=3Dc1a85624 idVendor=3D0x557 idProduct=3D0x2=
009=0D
[    1.667391] usb_match_id: id=3Dc1a8563c idVendor=3D0x411 idProduct=3D0x3=
d=0D
[    1.667392] usb_match_id: id=3Dc1a85654 idVendor=3D0x411 idProduct=3D0x6=
e=0D
[    1.667394] usb_match_id: id=3Dc1a8566c idVendor=3D0x6189 idProduct=3D0x=
182d=0D
[    1.667395] usb_match_id: id=3Dc1a85684 idVendor=3D0xdf6 idProduct=3D0x5=
6=0D
[    1.667396] usb_match_id: id=3Dc1a8569c idVendor=3D0x7aa idProduct=3D0x1=
7=0D
[    1.667398] usb_match_id: id=3Dc1a856b4 idVendor=3D0x1189 idProduct=3D0x=
893=0D
[    1.667399] usb_match_id: id=3Dc1a856cc idVendor=3D0x1631 idProduct=3D0x=
6200=0D
[    1.667401] usb_match_id: id=3Dc1a856e4 idVendor=3D0x4f1 idProduct=3D0x3=
008=0D
[    1.667402] usb_match_id: id=3Dc1a856fc idVendor=3D0xb95 idProduct=3D0x7=
72b=0D
[    1.667404] usb_match_id: id=3Dc1a85714 idVendor=3D0xb95 idProduct=3D0x7=
720=0D
[    1.667405] usb_match_id: id=3Dc1a8572c idVendor=3D0xb95 idProduct=3D0x1=
780=0D
[    1.667407] usb_match_id: id=3Dc1a85744 idVendor=3D0x789 idProduct=3D0x1=
60=0D
[    1.667408] usb_match_id: id=3Dc1a8575c idVendor=3D0x13b1 idProduct=3D0x=
18=0D
[    1.667409] usb_match_id: id=3Dc1a85774 idVendor=3D0x1557 idProduct=3D0x=
7720=0D
[    1.667411] usb_match_id: id=3Dc1a8578c idVendor=3D0x7d1 idProduct=3D0x3=
c05=0D
[    1.667412] usb_match_id: id=3Dc1a857a4 idVendor=3D0x2001 idProduct=3D0x=
3c05=0D
[    1.667414] usb_match_id: id=3Dc1a857bc idVendor=3D0x1737 idProduct=3D0x=
39=0D
[    1.667415] usb_match_id: id=3Dc1a857d4 idVendor=3D0x4bb idProduct=3D0x9=
30=0D
[    1.667416] usb_match_id: id=3Dc1a857ec idVendor=3D0x50d idProduct=3D0x5=
055=0D
[    1.667418] usb_match_id: id=3Dc1a85804 idVendor=3D0x5ac idProduct=3D0x1=
402=0D
[    1.667419] usb_match_id: id=3Dc1a8581c idVendor=3D0xb95 idProduct=3D0x7=
72a=0D
[    1.667421] usb_match_id: id=3Dc1a85834 idVendor=3D0x14ea idProduct=3D0x=
ab11=0D
[    1.667422] usb_match_id: id=3Dc1a8584c idVendor=3D0xdb0 idProduct=3D0xa=
877=0D
[    1.667423] usb_match_id: id=3Dc1a85864 idVendor=3D0xb95 idProduct=3D0x7=
e2b=0D
[    1.667425] usb_match_id: id=3Dc1a8587c idVendor=3D0xb95 idProduct=3D0x1=
72a=0D
[    1.667427] usb_device_match: device 1-1:1.0, driver MOSCHIP usb-etherne=
t driver =0D
[    1.667428] usb_match_id: id=3Dc1a85d5c idVendor=3D0x9710 idProduct=3D0x=
7832=0D
[    1.667429] usb_match_id: id=3Dc1a85d74 idVendor=3D0x9710 idProduct=3D0x=
7830=0D
[    1.667431] usb_match_id: id=3Dc1a85d8c idVendor=3D0x9710 idProduct=3D0x=
7730=0D
[    1.667435] usb_match_id: id=3Dc1a85da4 idVendor=3D0xdf6 idProduct=3D0x2=
1=0D
[    1.667437] usb_device_match: device 1-1:1.0, driver kalmia =0D
[    1.667438] usb_match_id: id=3Dc1a85fec idVendor=3D0x4e8 idProduct=3D0x6=
89a=0D
[    1.667440] usb_match_id: id=3Dc1a86004 idVendor=3D0x4e8 idProduct=3D0x6=
889=0D
[    1.667442] usb_device_match: device 1-1:1.0, driver cx82310_eth =0D
[    1.667443] usb_match_id: id=3Dc1a86078 idVendor=3D0x572 idProduct=3D0xc=
b01=0D
[    1.667445] usb_device_match: device 1-1:1.0, driver cdc_ncm =0D
[    1.667446] usb_match_id: id=3Dc1a861a4 idVendor=3D0xbdb idProduct=3D0x0=
=0D
[    1.667448] usb_match_id: id=3Dc1a861bc idVendor=3D0x0 idProduct=3D0x0=0D
[    1.667449] usb_device_match: device 1-1:1.0, driver qmi_wwan =0D
[    1.667451] usb_match_id: id=3Dc1a862b8 idVendor=3D0x12d1 idProduct=3D0x=
0=0D
[    1.667452] usb_match_id: id=3Dc1a862d0 idVendor=3D0x12d1 idProduct=3D0x=
0=0D
[    1.667454] usb_match_id: id=3Dc1a862e8 idVendor=3D0x12d1 idProduct=3D0x=
0=0D
[    1.667455] usb_match_id: id=3Dc1a86300 idVendor=3D0x106c idProduct=3D0x=
3718=0D
[    1.667456] usb_match_id: id=3Dc1a86318 idVendor=3D0x19d2 idProduct=3D0x=
167=0D
[    1.667458] usb_match_id: id=3Dc1a86330 idVendor=3D0x19d2 idProduct=3D0x=
326=0D
[    1.667459] usb_match_id: id=3Dc1a86348 idVendor=3D0x19d2 idProduct=3D0x=
55=0D
[    1.667461] usb_match_id: id=3Dc1a86360 idVendor=3D0x19d2 idProduct=3D0x=
63=0D
[    1.667462] usb_match_id: id=3Dc1a86378 idVendor=3D0x19d2 idProduct=3D0x=
1008=0D
[    1.667463] usb_match_id: id=3Dc1a86390 idVendor=3D0x19d2 idProduct=3D0x=
1010=0D
[    1.667465] usb_match_id: id=3Dc1a863a8 idVendor=3D0x19d2 idProduct=3D0x=
2002=0D
[    1.667466] usb_match_id: id=3Dc1a863c0 idVendor=3D0x19d2 idProduct=3D0x=
104=0D
[    1.667468] usb_match_id: id=3Dc1a863d8 idVendor=3D0x19d2 idProduct=3D0x=
1402=0D
[    1.667469] usb_match_id: id=3Dc1a863f0 idVendor=3D0x1199 idProduct=3D0x=
68a2=0D
[    1.667471] usb_match_id: id=3Dc1a86408 idVendor=3D0x5c6 idProduct=3D0x9=
212=0D
[    1.667472] usb_match_id: id=3Dc1a86420 idVendor=3D0x3f0 idProduct=3D0x1=
f1d=0D
[    1.667473] usb_match_id: id=3Dc1a86438 idVendor=3D0x3f0 idProduct=3D0x3=
71d=0D
[    1.667475] usb_match_id: id=3Dc1a86450 idVendor=3D0x4da idProduct=3D0x2=
50d=0D
[    1.667476] usb_match_id: id=3Dc1a86468 idVendor=3D0x413c idProduct=3D0x=
8172=0D
[    1.667477] usb_match_id: id=3Dc1a86480 idVendor=3D0x1410 idProduct=3D0x=
a001=0D
[    1.667479] usb_match_id: id=3Dc1a86498 idVendor=3D0xb05 idProduct=3D0x1=
776=0D
[    1.667480] usb_match_id: id=3Dc1a864b0 idVendor=3D0x19d2 idProduct=3D0x=
fff3=0D
[    1.667482] usb_match_id: id=3Dc1a864c8 idVendor=3D0x5c6 idProduct=3D0x9=
001=0D
[    1.667483] usb_match_id: id=3Dc1a864e0 idVendor=3D0x5c6 idProduct=3D0x9=
002=0D
[    1.667484] usb_match_id: id=3Dc1a864f8 idVendor=3D0x5c6 idProduct=3D0x9=
202=0D
[    1.667486] usb_match_id: id=3Dc1a86510 idVendor=3D0x5c6 idProduct=3D0x9=
203=0D
[    1.667487] usb_match_id: id=3Dc1a86528 idVendor=3D0x5c6 idProduct=3D0x9=
222=0D
[    1.667489] usb_match_id: id=3Dc1a86540 idVendor=3D0x5c6 idProduct=3D0x9=
009=0D
[    1.667490] usb_match_id: id=3Dc1a86558 idVendor=3D0x413c idProduct=3D0x=
8186=0D
[    1.667491] usb_match_id: id=3Dc1a86570 idVendor=3D0x5c6 idProduct=3D0x9=
20b=0D
[    1.667493] usb_match_id: id=3Dc1a86588 idVendor=3D0x5c6 idProduct=3D0x9=
225=0D
[    1.667494] usb_match_id: id=3Dc1a865a0 idVendor=3D0x5c6 idProduct=3D0x9=
245=0D
[    1.667496] usb_match_id: id=3Dc1a865b8 idVendor=3D0x3f0 idProduct=3D0x2=
51d=0D
[    1.667497] usb_match_id: id=3Dc1a865d0 idVendor=3D0x5c6 idProduct=3D0x9=
215=0D
[    1.667498] usb_match_id: id=3Dc1a865e8 idVendor=3D0x5c6 idProduct=3D0x9=
265=0D
[    1.667500] usb_match_id: id=3Dc1a86600 idVendor=3D0x5c6 idProduct=3D0x9=
235=0D
[    1.667501] usb_match_id: id=3Dc1a86618 idVendor=3D0x5c6 idProduct=3D0x9=
275=0D
[    1.667502] usb_match_id: id=3Dc1a86630 idVendor=3D0x1199 idProduct=3D0x=
9001=0D
[    1.667504] usb_match_id: id=3Dc1a86648 idVendor=3D0x1199 idProduct=3D0x=
9002=0D
[    1.667505] usb_match_id: id=3Dc1a86660 idVendor=3D0x1199 idProduct=3D0x=
9003=0D
[    1.667507] usb_match_id: id=3Dc1a86678 idVendor=3D0x1199 idProduct=3D0x=
9004=0D
[    1.667508] usb_match_id: id=3Dc1a86690 idVendor=3D0x1199 idProduct=3D0x=
9005=0D
[    1.667509] usb_match_id: id=3Dc1a866a8 idVendor=3D0x1199 idProduct=3D0x=
9006=0D
[    1.667511] usb_match_id: id=3Dc1a866c0 idVendor=3D0x1199 idProduct=3D0x=
9007=0D
[    1.667512] usb_match_id: id=3Dc1a866d8 idVendor=3D0x1199 idProduct=3D0x=
9008=0D
[    1.667516] usb_match_id: id=3Dc1a866f0 idVendor=3D0x1199 idProduct=3D0x=
9009=0D
[    1.667518] usb_match_id: id=3Dc1a86708 idVendor=3D0x1199 idProduct=3D0x=
900a=0D
[    1.667519] usb_match_id: id=3Dc1a86720 idVendor=3D0x1199 idProduct=3D0x=
9011=0D
[    1.667520] usb_match_id: id=3Dc1a86738 idVendor=3D0x16d8 idProduct=3D0x=
8002=0D
[    1.667522] usb_match_id: id=3Dc1a86750 idVendor=3D0x5c6 idProduct=3D0x9=
205=0D
[    1.667523] usb_match_id: id=3Dc1a86768 idVendor=3D0x1199 idProduct=3D0x=
9013=0D
[    1.667525] usb_match_id: id=3Dc1a86780 idVendor=3D0x1199 idProduct=3D0x=
9015=0D
[    1.667526] usb_match_id: id=3Dc1a86798 idVendor=3D0x1199 idProduct=3D0x=
9019=0D
[    1.667528] usb_device_match: device 1-1:1.0, driver usblp =0D
[    1.667529] usb_match_id: id=3Dc1a89540 idVendor=3D0x0 idProduct=3D0x0=0D
[    1.667531] usb_match_id: id=3Dc1a89558 idVendor=3D0x0 idProduct=3D0x0=0D
[    1.667532] usb_match_id: id=3Dc1a89570 idVendor=3D0x0 idProduct=3D0x0=0D
[    1.667533] usb_match_id: id=3Dc1a89588 idVendor=3D0x0 idProduct=3D0x0=0D
[    1.667535] usb_match_id: id=3Dc1a895a0 idVendor=3D0x0 idProduct=3D0x0=0D
[    1.667536] usb_match_id: id=3Dc1a895b8 idVendor=3D0x0 idProduct=3D0x0=0D
[    1.667537] usb_match_id: id=3Dc1a895d0 idVendor=3D0x4b8 idProduct=3D0x2=
02=0D
[    1.667539] usb_device_match: device 1-1:1.0, driver cdc_wdm =0D
[    1.667541] usb_match_id: id=3Dc1a8967c idVendor=3D0x0 idProduct=3D0x0=0D
[    1.667542] usb_device_match: device 1-1:1.0, driver usbtmc =0D
[    1.667544] usb_match_id: id=3Dc1a89730 idVendor=3D0x0 idProduct=3D0x0=0D
[    1.667545] usb_match_id: id=3Dc1a89748 idVendor=3D0x0 idProduct=3D0x0=0D
[    1.667547] usb_device_match: device 1-1:1.0, driver mdc800 =0D
[    1.667548] usb_match_id: id=3Dc1a897e0 idVendor=3D0x55f idProduct=3D0xa=
800=0D
[    1.667549] usb_device_match: device 1-1:1.0, driver cypress_cy7c63 =0D
[    1.667551] usb_match_id: id=3Dc1a89878 idVendor=3D0xa2c idProduct=3D0x8=
=0D
[    1.667552] usb_device_match: device 1-1:1.0, driver cytherm =0D
[    1.667554] usb_match_id: id=3Dc1a898a8 idVendor=3D0x4b4 idProduct=3D0x2=
=0D
[    1.667555] usb_device_match: device 1-1:1.0, driver emi62 - firmware lo=
ader =0D
[    1.667557] usb_match_id: id=3Dc1f85ca0 idVendor=3D0x86a idProduct=3D0x1=
10=0D
[    1.667559] usb_device_match: device 1-1:1.0, driver ftdi-elan =0D
[    1.667560] usb_match_id: id=3Dc1a89924 idVendor=3D0x403 idProduct=3D0xd=
6ea=0D
[    1.667562] usb_device_match: device 1-1:1.0, driver idmouse =0D
[    1.667569] usb_match_id: id=3Dc1a899bc idVendor=3D0x681 idProduct=3D0x5=
=0D
[    1.667570] usb_match_id: id=3Dc1a899d4 idVendor=3D0x681 idProduct=3D0x1=
0=0D
[    1.667572] usb_device_match: device 1-1:1.0, driver usbled =0D
[    1.667573] usb_match_id: id=3Dc1a89a78 idVendor=3D0xfc5 idProduct=3D0x1=
223=0D
[    1.667575] usb_match_id: id=3Dc1a89a90 idVendor=3D0x1d34 idProduct=3D0x=
4=0D
[    1.667576] usb_match_id: id=3Dc1a89aa8 idVendor=3D0x1d34 idProduct=3D0x=
a=0D
[    1.667578] usb_device_match: device 1-1:1.0, driver legousbtower =0D
[    1.667579] usb_match_id: id=3Dc1a89c70 idVendor=3D0x694 idProduct=3D0x1=
=0D
[    1.667581] usb_device_match: device 1-1:1.0, driver trancevibrator =0D
[    1.667583] usb_match_id: id=3Dc1a89d08 idVendor=3D0xb49 idProduct=3D0x6=
4f=0D
[    1.667584] usb_device_match: device 1-1:1.0, driver usbsevseg =0D
[    1.667586] usb_match_id: id=3Dc1a89d48 idVendor=3D0xfc5 idProduct=3D0x1=
227=0D
[    1.667587] usb_device_match: device 1-1:1.0, driver yurex =0D
[    1.667589] usb_match_id: id=3Dc1d384e4 idVendor=3D0xc45 idProduct=3D0x1=
010=0D
[    1.667591] usb_device_match: device 1-1:1.0, driver xpad =0D
[    1.667592] usb_match_id: id=3Dc1d454c4 idVendor=3D0x0 idProduct=3D0x0=0D
[    1.667594] usb_match_id: id=3Dc1d454dc idVendor=3D0x45e idProduct=3D0x0=
=0D
[    1.667595] usb_match_id: id=3Dc1d454f4 idVendor=3D0x45e idProduct=3D0x0=
=0D
[    1.667596] usb_match_id: id=3Dc1d4550c idVendor=3D0x46d idProduct=3D0x0=
=0D
[    1.667598] usb_match_id: id=3Dc1d45524 idVendor=3D0x46d idProduct=3D0x0=
=0D
[    1.667599] usb_match_id: id=3Dc1d4553c idVendor=3D0x738 idProduct=3D0x0=
=0D
[    1.667601] usb_match_id: id=3Dc1d45554 idVendor=3D0x738 idProduct=3D0x0=
=0D
[    1.667602] usb_match_id: id=3Dc1d4556c idVendor=3D0x738 idProduct=3D0x4=
540=0D
[    1.667603] usb_match_id: id=3Dc1d45584 idVendor=3D0xe6f idProduct=3D0x0=
=0D
[    1.667605] usb_match_id: id=3Dc1d4559c idVendor=3D0xe6f idProduct=3D0x0=
=0D
[    1.667609] usb_match_id: id=3Dc1d455b4 idVendor=3D0x12ab idProduct=3D0x=
0=0D
[    1.667610] usb_match_id: id=3Dc1d455cc idVendor=3D0x12ab idProduct=3D0x=
0=0D
[    1.667612] usb_match_id: id=3Dc1d455e4 idVendor=3D0x1430 idProduct=3D0x=
0=0D
[    1.667613] usb_match_id: id=3Dc1d455fc idVendor=3D0x1430 idProduct=3D0x=
0=0D
[    1.667614] usb_match_id: id=3Dc1d45614 idVendor=3D0x146b idProduct=3D0x=
0=0D
[    1.667616] usb_match_id: id=3Dc1d4562c idVendor=3D0x146b idProduct=3D0x=
0=0D
[    1.667617] usb_match_id: id=3Dc1d45644 idVendor=3D0x1bad idProduct=3D0x=
0=0D
[    1.667619] usb_match_id: id=3Dc1d4565c idVendor=3D0x1bad idProduct=3D0x=
0=0D
[    1.667620] usb_match_id: id=3Dc1d45674 idVendor=3D0xf0d idProduct=3D0x0=
=0D
[    1.667621] usb_match_id: id=3Dc1d4568c idVendor=3D0xf0d idProduct=3D0x0=
=0D
[    1.667623] usb_match_id: id=3Dc1d456a4 idVendor=3D0x1689 idProduct=3D0x=
0=0D
[    1.667624] usb_match_id: id=3Dc1d456bc idVendor=3D0x1689 idProduct=3D0x=
0=0D
[    1.667626] usb_device_match: device 1-1:1.0, driver ati_remote2 =0D
[    1.667628] usb_match_id: id=3Dc1d466f0 idVendor=3D0x471 idProduct=3D0x6=
02=0D
[    1.667629] usb_device_match: device 1-1:1.0, driver i2c-diolan-u2c =0D
[    1.667631] usb_match_id: id=3Dc1a8d820 idVendor=3D0xabf idProduct=3D0x3=
370=0D
[    1.667633] usb_device_match: device 1-1:1.0, driver ttusb-dec =0D
[    1.667634] usb_match_id: id=3Dc1d7ce74 idVendor=3D0xb48 idProduct=3D0x1=
006=0D
[    1.667636] usb_match_id: id=3Dc1d7ce8c idVendor=3D0xb48 idProduct=3D0x1=
008=0D
[    1.667637] usb_match_id: id=3Dc1d7cea4 idVendor=3D0xb48 idProduct=3D0x1=
009=0D
[    1.667639] usb_device_match: device 1-1:1.0, driver dvb_usb_dtt200u =0D
[    1.667640] usb_match_id: id=3Dc1d80748 idVendor=3D0x14aa idProduct=3D0x=
201=0D
[    1.667642] usb_match_id: id=3Dc1d80760 idVendor=3D0x14aa idProduct=3D0x=
301=0D
[    1.667643] usb_match_id: id=3Dc1d80778 idVendor=3D0x14aa idProduct=3D0x=
222=0D
[    1.667645] usb_match_id: id=3Dc1d80790 idVendor=3D0x14aa idProduct=3D0x=
221=0D
[    1.667646] usb_match_id: id=3Dc1d807a8 idVendor=3D0x14aa idProduct=3D0x=
22a=0D
[    1.667647] usb_match_id: id=3Dc1d807c0 idVendor=3D0x14aa idProduct=3D0x=
22b=0D
[    1.667649] usb_match_id: id=3Dc1d807d8 idVendor=3D0x14aa idProduct=3D0x=
225=0D
[    1.667650] usb_match_id: id=3Dc1d807f0 idVendor=3D0x14aa idProduct=3D0x=
226=0D
[    1.667652] usb_match_id: id=3Dc1d80808 idVendor=3D0x14aa idProduct=3D0x=
220=0D
[    1.667653] usb_match_id: id=3Dc1d80820 idVendor=3D0x18f3 idProduct=3D0x=
220=0D
[    1.667655] usb_device_match: device 1-1:1.0, driver dvb_usb_nova_t_usb2=
 =0D
[    1.667656] usb_match_id: id=3Dc1d81b6c idVendor=3D0x2040 idProduct=3D0x=
9300=0D
[    1.667658] usb_match_id: id=3Dc1d81b84 idVendor=3D0x2040 idProduct=3D0x=
9301=0D
[    1.667659] usb_device_match: device 1-1:1.0, driver dvb_usb_umt_010 =0D
[    1.667661] usb_match_id: id=3Dc1d824f4 idVendor=3D0x15f4 idProduct=3D0x=
1=0D
[    1.667662] usb_match_id: id=3Dc1d8250c idVendor=3D0x15f4 idProduct=3D0x=
15=0D
[    1.667664] usb_device_match: device 1-1:1.0, driver dvb_usb_gl861 =0D
[    1.667665] usb_match_id: id=3Dc1d82eb4 idVendor=3D0xdb0 idProduct=3D0x5=
581=0D
[    1.667666] usb_match_id: id=3Dc1d82ecc idVendor=3D0x5e3 idProduct=3D0xf=
170=0D
[    1.667668] usb_device_match: device 1-1:1.0, driver dvb_usb_au6610 =0D
[    1.667669] usb_match_id: id=3Dc1d838b8 idVendor=3D0x58f idProduct=3D0x6=
610=0D
[    1.667671] usb_device_match: device 1-1:1.0, driver dvb_usb_ttusb2 =0D
[    1.667673] usb_match_id: id=3Dc1d8522c idVendor=3D0x2304 idProduct=3D0x=
20f=0D
[    1.667674] usb_match_id: id=3Dc1d85244 idVendor=3D0x2304 idProduct=3D0x=
222=0D
[    1.667675] usb_match_id: id=3Dc1d8525c idVendor=3D0xb48 idProduct=3D0x3=
006=0D
[    1.667677] usb_match_id: id=3Dc1d85274 idVendor=3D0xb48 idProduct=3D0x3=
00d=0D
[    1.667678] usb_device_match: device 1-1:1.0, driver dvb_usb_dib0700 =0D
[    1.667680] usb_match_id: id=3Dc1d91b48 idVendor=3D0x10b8 idProduct=3D0x=
1e14=0D
[    1.667681] usb_match_id: id=3Dc1d91b60 idVendor=3D0x10b8 idProduct=3D0x=
1e78=0D
[    1.667683] usb_match_id: id=3Dc1d91b78 idVendor=3D0x2040 idProduct=3D0x=
9941=0D
[    1.667684] usb_match_id: id=3Dc1d91b90 idVendor=3D0x2040 idProduct=3D0x=
9950=0D
[    1.667686] usb_match_id: id=3Dc1d91ba8 idVendor=3D0x2040 idProduct=3D0x=
7050=0D
[    1.667687] usb_match_id: id=3Dc1d91bc0 idVendor=3D0x7ca idProduct=3D0xa=
807=0D
[    1.667688] usb_match_id: id=3Dc1d91bd8 idVendor=3D0x185b idProduct=3D0x=
1e78=0D
[    1.667692] usb_match_id: id=3Dc1d91bf0 idVendor=3D0x1584 idProduct=3D0x=
6003=0D
[    1.667694] usb_match_id: id=3Dc1d91c08 idVendor=3D0x413 idProduct=3D0x6=
f00=0D
[    1.667695] usb_match_id: id=3Dc1d91c20 idVendor=3D0x2040 idProduct=3D0x=
7060=0D
[    1.667696] usb_match_id: id=3Dc1d91c38 idVendor=3D0x7ca idProduct=3D0xb=
808=0D
[    1.667698] usb_match_id: id=3Dc1d91c50 idVendor=3D0x2304 idProduct=3D0x=
22c=0D
[    1.667699] usb_match_id: id=3Dc1d91c68 idVendor=3D0xccd idProduct=3D0x5=
a=0D
[    1.667701] usb_match_id: id=3Dc1d91c80 idVendor=3D0x2040 idProduct=3D0x=
9580=0D
[    1.667702] usb_match_id: id=3Dc1d91c98 idVendor=3D0x10b8 idProduct=3D0x=
1ef0=0D
[    1.667703] usb_match_id: id=3Dc1d91cb0 idVendor=3D0x10b8 idProduct=3D0x=
1ebc=0D
[    1.667705] usb_match_id: id=3Dc1d91cc8 idVendor=3D0x2304 idProduct=3D0x=
228=0D
[    1.667706] usb_match_id: id=3Dc1d91ce0 idVendor=3D0x10b8 idProduct=3D0x=
1ebe=0D
[    1.667708] usb_match_id: id=3Dc1d91cf8 idVendor=3D0x2304 idProduct=3D0x=
229=0D
[    1.667709] usb_match_id: id=3Dc1d91d10 idVendor=3D0x185b idProduct=3D0x=
1e80=0D
[    1.667710] usb_match_id: id=3Dc1d91d28 idVendor=3D0x7ca idProduct=3D0xb=
568=0D
[    1.667711] usb_match_id: id=3Dc1d91d40 idVendor=3D0x1044 idProduct=3D0x=
7001=0D
[    1.667713] usb_match_id: id=3Dc1d91d58 idVendor=3D0x5d8 idProduct=3D0x8=
10f=0D
[    1.667714] usb_match_id: id=3Dc1d91d70 idVendor=3D0xb05 idProduct=3D0x1=
71f=0D
[    1.667716] usb_match_id: id=3Dc1d91d88 idVendor=3D0xb05 idProduct=3D0x1=
73f=0D
[    1.667717] usb_match_id: id=3Dc1d91da0 idVendor=3D0x2040 idProduct=3D0x=
7070=0D
[    1.667718] usb_match_id: id=3Dc1d91db8 idVendor=3D0x2040 idProduct=3D0x=
7080=0D
[    1.667720] usb_match_id: id=3Dc1d91dd0 idVendor=3D0xccd idProduct=3D0x5=
8=0D
[    1.667721] usb_match_id: id=3Dc1d91de8 idVendor=3D0x2304 idProduct=3D0x=
22e=0D
[    1.667723] usb_match_id: id=3Dc1d91e00 idVendor=3D0x2304 idProduct=3D0x=
236=0D
[    1.667724] usb_match_id: id=3Dc1d91e18 idVendor=3D0x2304 idProduct=3D0x=
237=0D
[    1.667725] usb_match_id: id=3Dc1d91e30 idVendor=3D0x1164 idProduct=3D0x=
1edc=0D
[    1.667727] usb_match_id: id=3Dc1d91e48 idVendor=3D0xccd idProduct=3D0x6=
0=0D
[    1.667728] usb_match_id: id=3Dc1d91e60 idVendor=3D0xccd idProduct=3D0x7=
8=0D
[    1.667729] usb_match_id: id=3Dc1d91e78 idVendor=3D0x413 idProduct=3D0x6=
f01=0D
[    1.667731] usb_match_id: id=3Dc1d91e90 idVendor=3D0x2040 idProduct=3D0x=
5200=0D
[    1.667732] usb_match_id: id=3Dc1d91ea8 idVendor=3D0x2040 idProduct=3D0x=
8400=0D
[    1.667734] usb_match_id: id=3Dc1d91ec0 idVendor=3D0x1044 idProduct=3D0x=
7002=0D
[    1.667735] usb_match_id: id=3Dc1d91ed8 idVendor=3D0x1164 idProduct=3D0x=
1f08=0D
[    1.667736] usb_match_id: id=3Dc1d91ef0 idVendor=3D0xb05 idProduct=3D0x1=
736=0D
[    1.667738] usb_match_id: id=3Dc1d91f08 idVendor=3D0x2304 idProduct=3D0x=
23a=0D
[    1.667739] usb_match_id: id=3Dc1d91f20 idVendor=3D0x2304 idProduct=3D0x=
23b=0D
[    1.667740] usb_match_id: id=3Dc1d91f38 idVendor=3D0xccd idProduct=3D0x6=
2=0D
[    1.667742] usb_match_id: id=3Dc1d91f50 idVendor=3D0xccd idProduct=3D0x8=
1=0D
[    1.667743] usb_match_id: id=3Dc1d91f68 idVendor=3D0x1415 idProduct=3D0x=
3=0D
[    1.667744] usb_match_id: id=3Dc1d91f80 idVendor=3D0x1164 idProduct=3D0x=
2edc=0D
[    1.667745] usb_match_id: id=3Dc1d91f98 idVendor=3D0x2040 idProduct=3D0x=
b200=0D
[    1.667747] usb_match_id: id=3Dc1d91fb0 idVendor=3D0x2040 idProduct=3D0x=
b210=0D
[    1.667748] usb_match_id: id=3Dc1d91fc8 idVendor=3D0x1164 idProduct=3D0x=
871=0D
[    1.667749] usb_match_id: id=3Dc1d91fe0 idVendor=3D0xfd9 idProduct=3D0x2=
1=0D
[    1.667750] usb_match_id: id=3Dc1d91ff8 idVendor=3D0xfd9 idProduct=3D0x2=
0=0D
[    1.667751] usb_match_id: id=3Dc1d92010 idVendor=3D0x413 idProduct=3D0x6=
0f6=0D
[    1.667753] usb_match_id: id=3Dc1d92028 idVendor=3D0xccd idProduct=3D0x1=
0a0=0D
[    1.667754] usb_match_id: id=3Dc1d92040 idVendor=3D0xccd idProduct=3D0x1=
0a1=0D
[    1.667755] usb_match_id: id=3Dc1d92058 idVendor=3D0x1164 idProduct=3D0x=
1efc=0D
[    1.667756] usb_match_id: id=3Dc1d92070 idVendor=3D0x1164 idProduct=3D0x=
1e8c=0D
[    1.667758] usb_match_id: id=3Dc1d92088 idVendor=3D0x2304 idProduct=3D0x=
243=0D
[    1.667759] usb_match_id: id=3Dc1d920a0 idVendor=3D0x2013 idProduct=3D0x=
245=0D
[    1.667760] usb_match_id: id=3Dc1d920b8 idVendor=3D0x2013 idProduct=3D0x=
248=0D
[    1.667762] usb_match_id: id=3Dc1d920d0 idVendor=3D0x10b8 idProduct=3D0x=
1e80=0D
[    1.667763] usb_match_id: id=3Dc1d920e8 idVendor=3D0xccd idProduct=3D0xa=
b=0D
[    1.667764] usb_match_id: id=3Dc1d92100 idVendor=3D0x10b8 idProduct=3D0x=
1f98=0D
[    1.667768] usb_match_id: id=3Dc1d92118 idVendor=3D0x10b8 idProduct=3D0x=
1f90=0D
[    1.667770] usb_match_id: id=3Dc1d92130 idVendor=3D0x1554 idProduct=3D0x=
5010=0D
[    1.667771] usb_match_id: id=3Dc1d92148 idVendor=3D0x1e59 idProduct=3D0x=
2=0D
[    1.667772] usb_match_id: id=3Dc1d92160 idVendor=3D0x2304 idProduct=3D0x=
245=0D
[    1.667774] usb_match_id: id=3Dc1d92178 idVendor=3D0x2304 idProduct=3D0x=
248=0D
[    1.667775] usb_match_id: id=3Dc1d92190 idVendor=3D0x10b8 idProduct=3D0x=
1fa0=0D
[    1.667776] usb_match_id: id=3Dc1d921a8 idVendor=3D0xfd9 idProduct=3D0x1=
1=0D
[    1.667777] usb_match_id: id=3Dc1d921c0 idVendor=3D0x10b8 idProduct=3D0x=
2383=0D
[    1.667779] usb_match_id: id=3Dc1d921d8 idVendor=3D0x10b8 idProduct=3D0x=
1fa8=0D
[    1.667780] usb_match_id: id=3Dc1d921f0 idVendor=3D0x10b8 idProduct=3D0x=
2384=0D
[    1.667781] usb_match_id: id=3Dc1d92208 idVendor=3D0x10b8 idProduct=3D0x=
1bb2=0D
[    1.667783] usb_match_id: id=3Dc1d92220 idVendor=3D0x10b8 idProduct=3D0x=
1bb4=0D
[    1.667784] usb_match_id: id=3Dc1d92238 idVendor=3D0x14f7 idProduct=3D0x=
4=0D
[    1.667786] usb_match_id: id=3Dc1d92250 idVendor=3D0x1660 idProduct=3D0x=
1921=0D
[    1.667788] usb_match_id: id=3Dc1d92268 idVendor=3D0x2304 idProduct=3D0x=
23d=0D
[    1.667789] usb_match_id: id=3Dc1d92280 idVendor=3D0x2304 idProduct=3D0x=
23e=0D
[    1.667790] usb_match_id: id=3Dc1d92298 idVendor=3D0x10b8 idProduct=3D0x=
1bb7=0D
[    1.667792] usb_match_id: id=3Dc1d922b0 idVendor=3D0x10b8 idProduct=3D0x=
1e6e=0D
[    1.667800] usb_match_id: id=3Dc1d922c8 idVendor=3D0x10b8 idProduct=3D0x=
1f9c=0D
[    1.667801] usb_match_id: id=3Dc1d922e0 idVendor=3D0xfd9 idProduct=3D0x3=
f=0D
[    1.667803] usb_device_match: device 1-1:1.0, driver pctv452e =0D
[    1.667805] usb_match_id: id=3Dc1d94c1c idVendor=3D0x2304 idProduct=3D0x=
21f=0D
[    1.667806] usb_match_id: id=3Dc1d94c34 idVendor=3D0xb48 idProduct=3D0x3=
007=0D
[    1.667807] usb_match_id: id=3Dc1d94c4c idVendor=3D0xb48 idProduct=3D0x3=
00a=0D
[    1.667809] usb_device_match: device 1-1:1.0, driver dw2102 =0D
[    1.667810] usb_match_id: id=3Dc1d97af4 idVendor=3D0x4b4 idProduct=3D0x2=
102=0D
[    1.667812] usb_match_id: id=3Dc1d97b0c idVendor=3D0x4b4 idProduct=3D0x2=
101=0D
[    1.667813] usb_match_id: id=3Dc1d97b24 idVendor=3D0x4b4 idProduct=3D0x2=
104=0D
[    1.667815] usb_match_id: id=3Dc1d97b3c idVendor=3D0x9022 idProduct=3D0x=
d650=0D
[    1.667816] usb_match_id: id=3Dc1d97b54 idVendor=3D0xccd idProduct=3D0x6=
4=0D
[    1.667817] usb_match_id: id=3Dc1d97b6c idVendor=3D0x4b4 idProduct=3D0x3=
101=0D
[    1.667818] usb_match_id: id=3Dc1d97b84 idVendor=3D0x9022 idProduct=3D0x=
d630=0D
[    1.667820] usb_match_id: id=3Dc1d97b9c idVendor=3D0x3011 idProduct=3D0x=
b012=0D
[    1.667821] usb_match_id: id=3Dc1d97bb4 idVendor=3D0x9022 idProduct=3D0x=
d660=0D
[    1.667822] usb_match_id: id=3Dc1d97bcc idVendor=3D0x3034 idProduct=3D0x=
7500=0D
[    1.667824] usb_match_id: id=3Dc1d97be4 idVendor=3D0x1f4d idProduct=3D0x=
3000=0D
[    1.667825] usb_match_id: id=3Dc1d97bfc idVendor=3D0xccd idProduct=3D0xa=
8=0D
[    1.667827] usb_match_id: id=3Dc1d97c14 idVendor=3D0x9022 idProduct=3D0x=
d481=0D
[    1.667828] usb_match_id: id=3Dc1d97c2c idVendor=3D0x9022 idProduct=3D0x=
d482=0D
[    1.667829] usb_match_id: id=3Dc1d97c44 idVendor=3D0x1f4d idProduct=3D0x=
3100=0D
[    1.667831] usb_device_match: device 1-1:1.0, driver dvb_usb_af9015 =0D
[    1.667832] usb_match_id: id=3Dc1d99d24 idVendor=3D0x15a4 idProduct=3D0x=
9015=0D
[    1.667834] usb_match_id: id=3Dc1d99d3c idVendor=3D0x15a4 idProduct=3D0x=
9016=0D
[    1.667835] usb_match_id: id=3Dc1d99d54 idVendor=3D0x413 idProduct=3D0x6=
029=0D
[    1.667836] usb_match_id: id=3Dc1d99d6c idVendor=3D0x2304 idProduct=3D0x=
22b=0D
[    1.667838] usb_match_id: id=3Dc1d99d84 idVendor=3D0x1b80 idProduct=3D0x=
e399=0D
[    1.667839] usb_match_id: id=3Dc1d99d9c idVendor=3D0x13d3 idProduct=3D0x=
3226=0D
[    1.667841] usb_match_id: id=3Dc1d99db4 idVendor=3D0x13d3 idProduct=3D0x=
3237=0D
[    1.667842] usb_match_id: id=3Dc1d99dcc idVendor=3D0xccd idProduct=3D0x6=
9=0D
[    1.667843] usb_match_id: id=3Dc1d99de4 idVendor=3D0x1b80 idProduct=3D0x=
c160=0D
[    1.667845] usb_match_id: id=3Dc1d99dfc idVendor=3D0x7ca idProduct=3D0xa=
815=0D
[    1.667846] usb_match_id: id=3Dc1d99e14 idVendor=3D0x1ae7 idProduct=3D0x=
381=0D
[    1.667848] usb_match_id: id=3Dc1d99e2c idVendor=3D0x1462 idProduct=3D0x=
8801=0D
[    1.667849] usb_match_id: id=3Dc1d99e44 idVendor=3D0x7ca idProduct=3D0x8=
150=0D
[    1.667853] usb_match_id: id=3Dc1d99e5c idVendor=3D0x10b9 idProduct=3D0x=
8000=0D
[    1.667855] usb_match_id: id=3Dc1d99e74 idVendor=3D0x7ca idProduct=3D0xa=
309=0D
[    1.667856] usb_match_id: id=3Dc1d99e8c idVendor=3D0x1462 idProduct=3D0x=
8807=0D
[    1.667858] usb_match_id: id=3Dc1d99ea4 idVendor=3D0x1b80 idProduct=3D0x=
e396=0D
[    1.667859] usb_match_id: id=3Dc1d99ebc idVendor=3D0x1b80 idProduct=3D0x=
e39b=0D
[    1.667860] usb_match_id: id=3Dc1d99ed4 idVendor=3D0x1b80 idProduct=3D0x=
e395=0D
[    1.667862] usb_match_id: id=3Dc1d99eec idVendor=3D0x15a4 idProduct=3D0x=
901b=0D
[    1.667863] usb_match_id: id=3Dc1d99f04 idVendor=3D0x7ca idProduct=3D0x8=
50a=0D
[    1.667864] usb_match_id: id=3Dc1d99f1c idVendor=3D0x7ca idProduct=3D0xa=
805=0D
[    1.667866] usb_match_id: id=3Dc1d99f34 idVendor=3D0x1b80 idProduct=3D0x=
e397=0D
[    1.667867] usb_match_id: id=3Dc1d99f4c idVendor=3D0x1b80 idProduct=3D0x=
c810=0D
[    1.667868] usb_match_id: id=3Dc1d99f64 idVendor=3D0x458 idProduct=3D0x4=
012=0D
[    1.667870] usb_match_id: id=3Dc1d99f7c idVendor=3D0x1b80 idProduct=3D0x=
e400=0D
[    1.667871] usb_match_id: id=3Dc1d99f94 idVendor=3D0x1b80 idProduct=3D0x=
c161=0D
[    1.667872] usb_match_id: id=3Dc1d99fac idVendor=3D0x1b80 idProduct=3D0x=
e39d=0D
[    1.667874] usb_match_id: id=3Dc1d99fc4 idVendor=3D0x1b80 idProduct=3D0x=
e402=0D
[    1.667875] usb_match_id: id=3Dc1d99fdc idVendor=3D0x413 idProduct=3D0x6=
a04=0D
[    1.667876] usb_match_id: id=3Dc1d99ff4 idVendor=3D0x1b80 idProduct=3D0x=
e383=0D
[    1.667877] usb_match_id: id=3Dc1d9a00c idVendor=3D0x1b80 idProduct=3D0x=
e39a=0D
[    1.667878] usb_match_id: id=3Dc1d9a024 idVendor=3D0x7ca idProduct=3D0x8=
15a=0D
[    1.667879] usb_match_id: id=3Dc1d9a03c idVendor=3D0xccd idProduct=3D0x9=
7=0D
[    1.667880] usb_match_id: id=3Dc1d9a054 idVendor=3D0xccd idProduct=3D0x9=
9=0D
[    1.667881] usb_match_id: id=3Dc1d9a06c idVendor=3D0x7ca idProduct=3D0x8=
50b=0D
[    1.667882] usb_match_id: id=3Dc1d9a084 idVendor=3D0x1f4d idProduct=3D0x=
9016=0D
[    1.667883] usb_match_id: id=3Dc1d9a09c idVendor=3D0x1b80 idProduct=3D0x=
e401=0D
[    1.667884] usb_device_match: device 1-1:1.0, driver cinergyT2 =0D
[    1.667885] usb_match_id: id=3Dc1d9ad3c idVendor=3D0xccd idProduct=3D0x3=
8=0D
[    1.667886] usb_device_match: device 1-1:1.0, driver dvb_usb_ce6230 =0D
[    1.667887] usb_match_id: id=3Dc1d9b9e0 idVendor=3D0x8086 idProduct=3D0x=
9500=0D
[    1.667887] usb_match_id: id=3Dc1d9b9f8 idVendor=3D0x7ca idProduct=3D0xa=
310=0D
[    1.667888] usb_device_match: device 1-1:1.0, driver dvb_usb_friio =0D
[    1.667889] usb_match_id: id=3Dc1d9c418 idVendor=3D0x7a69 idProduct=3D0x=
1=0D
[    1.667890] usb_device_match: device 1-1:1.0, driver dvb_usb_ec168 =0D
[    1.667891] usb_match_id: id=3Dc1d9d07c idVendor=3D0x18b4 idProduct=3D0x=
1689=0D
[    1.667892] usb_match_id: id=3Dc1d9d094 idVendor=3D0x18b4 idProduct=3D0x=
fffa=0D
[    1.667893] usb_match_id: id=3Dc1d9d0ac idVendor=3D0x18b4 idProduct=3D0x=
fffb=0D
[    1.667893] usb_match_id: id=3Dc1d9d0c4 idVendor=3D0x18b4 idProduct=3D0x=
1001=0D
[    1.667894] usb_match_id: id=3Dc1d9d0dc idVendor=3D0x18b4 idProduct=3D0x=
1002=0D
[    1.667895] usb_device_match: device 1-1:1.0, driver dvb_usb_az6007 =0D
[    1.667896] usb_match_id: id=3Dc1d9db3c idVendor=3D0x13d3 idProduct=3D0x=
ccd=0D
[    1.667897] usb_match_id: id=3Dc1d9db54 idVendor=3D0xccd idProduct=3D0x1=
0b4=0D
[    1.667898] usb_match_id: id=3Dc1d9db6c idVendor=3D0xccd idProduct=3D0x1=
0a3=0D
[    1.667898] usb_device_match: device 1-1:1.0, driver dvb_usb_az6027 =0D
[    1.667899] usb_match_id: id=3Dc1d9e828 idVendor=3D0x13d3 idProduct=3D0x=
3275=0D
[    1.667900] usb_match_id: id=3Dc1d9e840 idVendor=3D0xccd idProduct=3D0x1=
0a4=0D
[    1.667901] usb_match_id: id=3Dc1d9e858 idVendor=3D0xccd idProduct=3D0x1=
0ac=0D
[    1.667902] usb_match_id: id=3Dc1d9e870 idVendor=3D0x14f7 idProduct=3D0x=
1=0D
[    1.667903] usb_match_id: id=3Dc1d9e888 idVendor=3D0x14f7 idProduct=3D0x=
2=0D
[    1.667903] usb_match_id: id=3Dc1d9e8a0 idVendor=3D0xfd9 idProduct=3D0x2=
a=0D
[    1.667904] usb_device_match: device 1-1:1.0, driver LME2510C_DVB-S =0D
[    1.667905] usb_match_id: id=3Dc1d9fd50 idVendor=3D0x3344 idProduct=3D0x=
1122=0D
[    1.667906] usb_match_id: id=3Dc1d9fd68 idVendor=3D0x3344 idProduct=3D0x=
1120=0D
[    1.667907] usb_match_id: id=3Dc1d9fd80 idVendor=3D0x3344 idProduct=3D0x=
22f0=0D
[    1.667908] usb_device_match: device 1-1:1.0, driver dvb_usb_af9035 =0D
[    1.667909] usb_match_id: id=3Dc1da0434 idVendor=3D0x15a4 idProduct=3D0x=
9035=0D
[    1.667911] usb_match_id: id=3Dc1da044c idVendor=3D0x15a4 idProduct=3D0x=
1000=0D
[    1.667912] usb_match_id: id=3Dc1da0464 idVendor=3D0x15a4 idProduct=3D0x=
1001=0D
[    1.667913] usb_match_id: id=3Dc1da047c idVendor=3D0x15a4 idProduct=3D0x=
1002=0D
[    1.667914] usb_match_id: id=3Dc1da0494 idVendor=3D0x15a4 idProduct=3D0x=
1003=0D
[    1.667914] usb_match_id: id=3Dc1da04ac idVendor=3D0xccd idProduct=3D0x9=
3=0D
[    1.667915] usb_match_id: id=3Dc1da04c4 idVendor=3D0x7ca idProduct=3D0xa=
835=0D
[    1.667916] usb_match_id: id=3Dc1da04dc idVendor=3D0x7ca idProduct=3D0xb=
835=0D
[    1.667917] usb_match_id: id=3Dc1da04f4 idVendor=3D0x7ca idProduct=3D0x1=
867=0D
[    1.667918] usb_match_id: id=3Dc1da050c idVendor=3D0x7ca idProduct=3D0xa=
867=0D
[    1.667919] usb_match_id: id=3Dc1da0524 idVendor=3D0x7ca idProduct=3D0x8=
25=0D
[    1.667921] usb_device_match: device 1-1:1.0, driver DS9490R =0D
[    1.667922] usb_match_id: id=3Dc1da56d8 idVendor=3D0x4fa idProduct=3D0x2=
490=0D
[    1.667924] usb_device_match: device 1-1:1.0, driver pcwd_usb =0D
[    1.667925] usb_match_id: id=3Dc1daa624 idVendor=3D0xc98 idProduct=3D0x1=
140=0D
[    1.667927] usb_device_match: device 1-1:1.0, driver bfusb =0D
[    1.667929] usb_match_id: id=3Dc1daeb08 idVendor=3D0x57c idProduct=3D0x2=
200=0D
[    1.667930] usb_device_match: device 1-1:1.0, driver btusb =0D
[    1.667932] usb_match_id: id=3Dc1daf384 idVendor=3D0x0 idProduct=3D0x0=0D
[    1.667933] usb_match_id: id=3Dc1daf39c idVendor=3D0xa5c idProduct=3D0x2=
1e1=0D
[    1.667934] usb_match_id: id=3Dc1daf3b4 idVendor=3D0x5ac idProduct=3D0x8=
213=0D
[    1.667935] usb_match_id: id=3Dc1daf3cc idVendor=3D0x5ac idProduct=3D0x8=
215=0D
[    1.667937] usb_match_id: id=3Dc1daf3e4 idVendor=3D0x5ac idProduct=3D0x8=
218=0D
[    1.667938] usb_match_id: id=3Dc1daf3fc idVendor=3D0x5ac idProduct=3D0x8=
21b=0D
[    1.667951] usb_match_id: id=3Dc1daf414 idVendor=3D0x5ac idProduct=3D0x8=
21f=0D
[    1.667953] usb_match_id: id=3Dc1daf42c idVendor=3D0x5ac idProduct=3D0x8=
21a=0D
[    1.667954] usb_match_id: id=3Dc1daf444 idVendor=3D0x5ac idProduct=3D0x8=
281=0D
[    1.667955] usb_match_id: id=3Dc1daf45c idVendor=3D0x57c idProduct=3D0x3=
800=0D
[    1.667957] usb_match_id: id=3Dc1daf474 idVendor=3D0x4bf idProduct=3D0x3=
0a=0D
[    1.667958] usb_match_id: id=3Dc1daf48c idVendor=3D0x44e idProduct=3D0x3=
001=0D
[    1.667960] usb_match_id: id=3Dc1daf4a4 idVendor=3D0x44e idProduct=3D0x3=
002=0D
[    1.667961] usb_match_id: id=3Dc1daf4bc idVendor=3D0xbdb idProduct=3D0x1=
002=0D
[    1.667962] usb_match_id: id=3Dc1daf4d4 idVendor=3D0xc10 idProduct=3D0x0=
=0D
[    1.667963] usb_match_id: id=3Dc1daf4ec idVendor=3D0x489 idProduct=3D0xe=
042=0D
[    1.667965] usb_match_id: id=3Dc1daf504 idVendor=3D0xa5c idProduct=3D0x2=
1e3=0D
[    1.667966] usb_match_id: id=3Dc1daf51c idVendor=3D0xa5c idProduct=3D0x2=
1e6=0D
[    1.667967] usb_match_id: id=3Dc1daf534 idVendor=3D0xa5c idProduct=3D0x2=
1e8=0D
[    1.667969] usb_match_id: id=3Dc1daf54c idVendor=3D0xa5c idProduct=3D0x2=
1f3=0D
[    1.667970] usb_match_id: id=3Dc1daf564 idVendor=3D0x413c idProduct=3D0x=
8197=0D
[    1.667972] usb_match_id: id=3Dc1daf57c idVendor=3D0x489 idProduct=3D0xe=
033=0D
[    1.667973] usb_device_match: device 1-1:1.0, driver ath3k =0D
[    1.667975] usb_match_id: id=3Dc1db0048 idVendor=3D0xcf3 idProduct=3D0x3=
000=0D
[    1.667976] usb_match_id: id=3Dc1db0060 idVendor=3D0xcf3 idProduct=3D0x3=
002=0D
[    1.667977] usb_match_id: id=3Dc1db0078 idVendor=3D0xcf3 idProduct=3D0xe=
019=0D
[    1.667978] usb_match_id: id=3Dc1db0090 idVendor=3D0x13d3 idProduct=3D0x=
3304=0D
[    1.667979] usb_match_id: id=3Dc1db00a8 idVendor=3D0x930 idProduct=3D0x2=
15=0D
[    1.667980] usb_match_id: id=3Dc1db00c0 idVendor=3D0x489 idProduct=3D0xe=
03d=0D
[    1.667981] usb_match_id: id=3Dc1db00d8 idVendor=3D0x3f0 idProduct=3D0x3=
11d=0D
[    1.667981] usb_match_id: id=3Dc1db00f0 idVendor=3D0xcf3 idProduct=3D0x3=
004=0D
[    1.667982] usb_match_id: id=3Dc1db0108 idVendor=3D0xcf3 idProduct=3D0x3=
11d=0D
[    1.667983] usb_match_id: id=3Dc1db0120 idVendor=3D0x13d3 idProduct=3D0x=
3375=0D
[    1.667984] usb_match_id: id=3Dc1db0138 idVendor=3D0x4ca idProduct=3D0x3=
005=0D
[    1.667985] usb_match_id: id=3Dc1db0150 idVendor=3D0x13d3 idProduct=3D0x=
3362=0D
[    1.667985] usb_match_id: id=3Dc1db0168 idVendor=3D0xcf3 idProduct=3D0xe=
004=0D
[    1.667986] usb_match_id: id=3Dc1db0180 idVendor=3D0x930 idProduct=3D0x2=
19=0D
[    1.667990] usb_match_id: id=3Dc1db0198 idVendor=3D0x489 idProduct=3D0xe=
02c=0D
[    1.667993] usb_match_id: id=3Dc1db01b0 idVendor=3D0x489 idProduct=3D0xe=
03c=0D
[    1.667995] usb_device_match: device 1-1:1.0, driver vub300 =0D
[    1.667996] usb_match_id: id=3Dc1db6b04 idVendor=3D0x2201 idProduct=3D0x=
12c=0D
[    1.667996] usb_match_id: id=3Dc1db6b1c idVendor=3D0x424 idProduct=3D0x1=
2c=0D
[    1.667997] usb_device_match: device 1-1:1.0, driver ushc =0D
[    1.667998] usb_match_id: id=3Dc1db72a4 idVendor=3D0xa12 idProduct=3D0x5=
d10=0D
[    1.668000] usb_device_match: device 1-1:1.0, driver usbmouse =0D
[    1.668001] usb_match_id: id=3Dc1dc0aa8 idVendor=3D0x0 idProduct=3D0x0=0D
[    1.668073] usb_device_match: device 1-1:1.1, driver usbfs =0D
[    1.668075] usb_device_match: device 1-1:1.1, driver hub =0D
[    1.668077] usb_match_id: id=3Dc1a87214 idVendor=3D0x0 idProduct=3D0x0=0D
[    1.668078] usb_match_id: id=3Dc1a8722c idVendor=3D0x0 idProduct=3D0x0=0D
[    1.668079] usb_device_match: device 1-1:1.1, driver udlfb =0D
[    1.668081] usb_match_id: id=3Dc1ccbc68 idVendor=3D0x17e9 idProduct=3D0x=
0=0D
[    1.668082] usb_device_match: device 1-1:1.1, driver smscufx =0D
[    1.668083] usb_match_id: id=3Dc1ccc5dc idVendor=3D0x424 idProduct=3D0x9=
d00=0D
[    1.668085] usb_match_id: id=3Dc1ccc5f4 idVendor=3D0x424 idProduct=3D0x9=
d01=0D
[    1.668086] usb_device_match: device 1-1:1.1, driver alauda =0D
[    1.668088] usb_match_id: id=3Dc1a810a4 idVendor=3D0x584 idProduct=3D0x8=
=0D
[    1.668089] usb_match_id: id=3Dc1a810bc idVendor=3D0x7b4 idProduct=3D0x1=
0a=0D
[    1.668090] usb_device_match: device 1-1:1.1, driver kaweth =0D
[    1.668092] usb_match_id: id=3Dc1d1e1e4 idVendor=3D0x3e8 idProduct=3D0x8=
=0D
[    1.668093] usb_match_id: id=3Dc1d1e1fc idVendor=3D0x4bb idProduct=3D0x9=
01=0D
[    1.668094] usb_match_id: id=3Dc1d1e214 idVendor=3D0x506 idProduct=3D0x3=
e8=0D
[    1.668096] usb_match_id: id=3Dc1d1e22c idVendor=3D0x506 idProduct=3D0x1=
1f8=0D
[    1.668097] usb_match_id: id=3Dc1d1e244 idVendor=3D0x557 idProduct=3D0x2=
002=0D
[    1.668099] usb_match_id: id=3Dc1d1e25c idVendor=3D0x557 idProduct=3D0x4=
000=0D
[    1.668100] usb_match_id: id=3Dc1d1e274 idVendor=3D0x565 idProduct=3D0x2=
=0D
[    1.668101] usb_match_id: id=3Dc1d1e28c idVendor=3D0x565 idProduct=3D0x3=
=0D
[    1.668102] usb_match_id: id=3Dc1d1e2a4 idVendor=3D0x565 idProduct=3D0x5=
=0D
[    1.668104] usb_match_id: id=3Dc1d1e2bc idVendor=3D0x5e9 idProduct=3D0x8=
=0D
[    1.668105] usb_match_id: id=3Dc1d1e2d4 idVendor=3D0x5e9 idProduct=3D0x9=
=0D
[    1.668106] usb_match_id: id=3Dc1d1e2ec idVendor=3D0x66b idProduct=3D0x2=
202=0D
[    1.668107] usb_match_id: id=3Dc1d1e304 idVendor=3D0x6e1 idProduct=3D0x8=
=0D
[    1.668109] usb_match_id: id=3Dc1d1e31c idVendor=3D0x6e1 idProduct=3D0x9=
=0D
[    1.668110] usb_match_id: id=3Dc1d1e334 idVendor=3D0x707 idProduct=3D0x1=
00=0D
[    1.668111] usb_match_id: id=3Dc1d1e34c idVendor=3D0x7aa idProduct=3D0x1=
=0D
[    1.668112] usb_match_id: id=3Dc1d1e364 idVendor=3D0x7b8 idProduct=3D0x4=
000=0D
[    1.668114] usb_match_id: id=3Dc1d1e37c idVendor=3D0x7c9 idProduct=3D0xb=
010=0D
[    1.668115] usb_match_id: id=3Dc1d1e394 idVendor=3D0x846 idProduct=3D0x1=
001=0D
[    1.668116] usb_match_id: id=3Dc1d1e3ac idVendor=3D0x846 idProduct=3D0x1=
002=0D
[    1.668118] usb_match_id: id=3Dc1d1e3c4 idVendor=3D0x85a idProduct=3D0x8=
=0D
[    1.668119] usb_match_id: id=3Dc1d1e3dc idVendor=3D0x85a idProduct=3D0x9=
=0D
[    1.668120] usb_match_id: id=3Dc1d1e3f4 idVendor=3D0x87d idProduct=3D0x5=
704=0D
[    1.668121] usb_match_id: id=3Dc1d1e40c idVendor=3D0x951 idProduct=3D0x8=
=0D
[    1.668123] usb_match_id: id=3Dc1d1e424 idVendor=3D0x95a idProduct=3D0x3=
003=0D
[    1.668124] usb_match_id: id=3Dc1d1e43c idVendor=3D0x10bd idProduct=3D0x=
1427=0D
[    1.668125] usb_match_id: id=3Dc1d1e454 idVendor=3D0x1342 idProduct=3D0x=
204=0D
[    1.668126] usb_match_id: id=3Dc1d1e46c idVendor=3D0x13d2 idProduct=3D0x=
400=0D
[    1.668127] usb_match_id: id=3Dc1d1e484 idVendor=3D0x1485 idProduct=3D0x=
1=0D
[    1.668129] usb_match_id: id=3Dc1d1e49c idVendor=3D0x1485 idProduct=3D0x=
2=0D
[    1.668130] usb_match_id: id=3Dc1d1e4b4 idVendor=3D0x1645 idProduct=3D0x=
5=0D
[    1.668131] usb_match_id: id=3Dc1d1e4cc idVendor=3D0x1645 idProduct=3D0x=
8=0D
[    1.668133] usb_match_id: id=3Dc1d1e4e4 idVendor=3D0x1645 idProduct=3D0x=
8005=0D
[    1.668134] usb_match_id: id=3Dc1d1e4fc idVendor=3D0x1668 idProduct=3D0x=
323=0D
[    1.668135] usb_match_id: id=3Dc1d1e514 idVendor=3D0x2001 idProduct=3D0x=
4000=0D
[    1.668137] usb_device_match: device 1-1:1.1, driver pegasus =0D
[    1.668145] usb_match_id: id=3Dc1d1ebd8 idVendor=3D0x506 idProduct=3D0x4=
601=0D
[    1.668146] usb_match_id: id=3Dc1d1ebf0 idVendor=3D0x557 idProduct=3D0x2=
007=0D
[    1.668148] usb_match_id: id=3Dc1d1ec08 idVendor=3D0x7b8 idProduct=3D0x1=
10c=0D
[    1.668149] usb_match_id: id=3Dc1d1ec20 idVendor=3D0x7b8 idProduct=3D0x4=
104=0D
[    1.668150] usb_match_id: id=3Dc1d1ec38 idVendor=3D0x7b8 idProduct=3D0x4=
004=0D
[    1.668152] usb_match_id: id=3Dc1d1ec50 idVendor=3D0x7b8 idProduct=3D0x4=
007=0D
[    1.668153] usb_match_id: id=3Dc1d1ec68 idVendor=3D0x7b8 idProduct=3D0x4=
102=0D
[    1.668154] usb_match_id: id=3Dc1d1ec80 idVendor=3D0x7b8 idProduct=3D0x4=
002=0D
[    1.668156] usb_match_id: id=3Dc1d1ec98 idVendor=3D0x7b8 idProduct=3D0x4=
00b=0D
[    1.668157] usb_match_id: id=3Dc1d1ecb0 idVendor=3D0x7b8 idProduct=3D0x4=
00c=0D
[    1.668158] usb_match_id: id=3Dc1d1ecc8 idVendor=3D0x7b8 idProduct=3D0xa=
bc1=0D
[    1.668160] usb_match_id: id=3Dc1d1ece0 idVendor=3D0x7b8 idProduct=3D0x2=
00c=0D
[    1.668161] usb_match_id: id=3Dc1d1ecf8 idVendor=3D0x83a idProduct=3D0x1=
046=0D
[    1.668162] usb_match_id: id=3Dc1d1ed10 idVendor=3D0x83a idProduct=3D0x5=
046=0D
[    1.668163] usb_match_id: id=3Dc1d1ed28 idVendor=3D0x83a idProduct=3D0xb=
004=0D
[    1.668164] usb_match_id: id=3Dc1d1ed40 idVendor=3D0x7a6 idProduct=3D0x8=
511=0D
[    1.668166] usb_match_id: id=3Dc1d1ed58 idVendor=3D0x7a6 idProduct=3D0x8=
513=0D
[    1.668167] usb_match_id: id=3Dc1d1ed70 idVendor=3D0x7a6 idProduct=3D0x8=
515=0D
[    1.668168] usb_match_id: id=3Dc1d1ed88 idVendor=3D0x7a6 idProduct=3D0x9=
86=0D
[    1.668169] usb_match_id: id=3Dc1d1eda0 idVendor=3D0x7a6 idProduct=3D0x7=
c2=0D
[    1.668170] usb_match_id: id=3Dc1d1edb8 idVendor=3D0x3334 idProduct=3D0x=
1701=0D
[    1.668172] usb_match_id: id=3Dc1d1edd0 idVendor=3D0x7c9 idProduct=3D0xb=
100=0D
[    1.668173] usb_match_id: id=3Dc1d1ede8 idVendor=3D0x50d idProduct=3D0x1=
21=0D
[    1.668175] usb_match_id: id=3Dc1d1ee00 idVendor=3D0x50d idProduct=3D0x1=
22=0D
[    1.668176] usb_match_id: id=3Dc1d1ee18 idVendor=3D0x8dd idProduct=3D0x9=
86=0D
[    1.668177] usb_match_id: id=3Dc1d1ee30 idVendor=3D0x8dd idProduct=3D0x9=
87=0D
[    1.668178] usb_match_id: id=3Dc1d1ee48 idVendor=3D0x49f idProduct=3D0x8=
511=0D
[    1.668180] usb_match_id: id=3Dc1d1ee60 idVendor=3D0x8dd idProduct=3D0x9=
88=0D
[    1.668181] usb_match_id: id=3Dc1d1ee78 idVendor=3D0x8dd idProduct=3D0x8=
511=0D
[    1.668182] usb_match_id: id=3Dc1d1ee90 idVendor=3D0x7aa idProduct=3D0x4=
=0D
[    1.668184] usb_match_id: id=3Dc1d1eea8 idVendor=3D0x7aa idProduct=3D0xd=
=0D
[    1.668185] usb_match_id: id=3Dc1d1eec0 idVendor=3D0x2001 idProduct=3D0x=
4001=0D
[    1.668186] usb_match_id: id=3Dc1d1eed8 idVendor=3D0x2001 idProduct=3D0x=
4002=0D
[    1.668187] usb_match_id: id=3Dc1d1eef0 idVendor=3D0x2001 idProduct=3D0x=
4102=0D
[    1.668189] usb_match_id: id=3Dc1d1ef08 idVendor=3D0x2001 idProduct=3D0x=
400b=0D
[    1.668190] usb_match_id: id=3Dc1d1ef20 idVendor=3D0x2001 idProduct=3D0x=
200c=0D
[    1.668191] usb_match_id: id=3Dc1d1ef38 idVendor=3D0x2001 idProduct=3D0x=
4003=0D
[    1.668192] usb_match_id: id=3Dc1d1ef50 idVendor=3D0x2001 idProduct=3D0x=
abc1=0D
[    1.668194] usb_match_id: id=3Dc1d1ef68 idVendor=3D0xdb7 idProduct=3D0x2=
=0D
[    1.668195] usb_match_id: id=3Dc1d1ef80 idVendor=3D0x56e idProduct=3D0x4=
010=0D
[    1.668196] usb_match_id: id=3Dc1d1ef98 idVendor=3D0x1342 idProduct=3D0x=
304=0D
[    1.668198] usb_match_id: id=3Dc1d1efb0 idVendor=3D0x5cc idProduct=3D0x3=
000=0D
[    1.668199] usb_match_id: id=3Dc1d1efc8 idVendor=3D0x1044 idProduct=3D0x=
8002=0D
[    1.668200] usb_match_id: id=3Dc1d1efe0 idVendor=3D0xe66 idProduct=3D0x4=
00c=0D
[    1.668201] usb_match_id: id=3Dc1d1eff8 idVendor=3D0x3f0 idProduct=3D0x8=
11c=0D
[    1.668203] usb_match_id: id=3Dc1d1f010 idVendor=3D0x4bb idProduct=3D0x9=
04=0D
[    1.668204] usb_match_id: id=3Dc1d1f028 idVendor=3D0x4bb idProduct=3D0x9=
13=0D
[    1.668206] usb_match_id: id=3Dc1d1f040 idVendor=3D0x4bb idProduct=3D0x9=
3a=0D
[    1.668207] usb_match_id: id=3Dc1d1f058 idVendor=3D0x951 idProduct=3D0xa=
=0D
[    1.668208] usb_match_id: id=3Dc1d1f070 idVendor=3D0x56e idProduct=3D0x4=
002=0D
[    1.668210] usb_match_id: id=3Dc1d1f088 idVendor=3D0x56e idProduct=3D0x4=
005=0D
[    1.668211] usb_match_id: id=3Dc1d1f0a0 idVendor=3D0x56e idProduct=3D0x4=
00b=0D
[    1.668212] usb_match_id: id=3Dc1d1f0b8 idVendor=3D0x56e idProduct=3D0xa=
bc1=0D
[    1.668214] usb_match_id: id=3Dc1d1f0d0 idVendor=3D0x56e idProduct=3D0x2=
00c=0D
[    1.668220] usb_match_id: id=3Dc1d1f0e8 idVendor=3D0x66b idProduct=3D0x2=
202=0D
[    1.668222] usb_match_id: id=3Dc1d1f100 idVendor=3D0x66b idProduct=3D0x2=
203=0D
[    1.668224] usb_match_id: id=3Dc1d1f118 idVendor=3D0x66b idProduct=3D0x2=
204=0D
[    1.668225] usb_match_id: id=3Dc1d1f130 idVendor=3D0x66b idProduct=3D0x2=
206=0D
[    1.668226] usb_match_id: id=3Dc1d1f148 idVendor=3D0x77b idProduct=3D0x8=
b4=0D
[    1.668228] usb_match_id: id=3Dc1d1f160 idVendor=3D0x66b idProduct=3D0x4=
00b=0D
[    1.668229] usb_match_id: id=3Dc1d1f178 idVendor=3D0x66b idProduct=3D0x2=
00c=0D
[    1.668230] usb_match_id: id=3Dc1d1f190 idVendor=3D0x411 idProduct=3D0x1=
=0D
[    1.668232] usb_match_id: id=3Dc1d1f1a8 idVendor=3D0x411 idProduct=3D0x5=
=0D
[    1.668233] usb_match_id: id=3Dc1d1f1c0 idVendor=3D0x411 idProduct=3D0x9=
=0D
[    1.668235] usb_match_id: id=3Dc1d1f1d8 idVendor=3D0x45e idProduct=3D0x7=
a=0D
[    1.668243] usb_match_id: id=3Dc1d1f1f0 idVendor=3D0x846 idProduct=3D0x1=
020=0D
[    1.668244] usb_match_id: id=3Dc1d1f208 idVendor=3D0xb39 idProduct=3D0x1=
09=0D
[    1.668246] usb_match_id: id=3Dc1d1f220 idVendor=3D0xb39 idProduct=3D0x9=
01=0D
[    1.668247] usb_match_id: id=3Dc1d1f238 idVendor=3D0x8d1 idProduct=3D0x3=
=0D
[    1.668248] usb_match_id: id=3Dc1d1f250 idVendor=3D0x707 idProduct=3D0x2=
00=0D
[    1.668250] usb_match_id: id=3Dc1d1f268 idVendor=3D0x707 idProduct=3D0x2=
01=0D
[    1.668251] usb_match_id: id=3Dc1d1f280 idVendor=3D0x15e8 idProduct=3D0x=
9100=0D
[    1.668252] usb_match_id: id=3Dc1d1f298 idVendor=3D0x15e8 idProduct=3D0x=
9110=0D
[    1.668254] usb_match_id: id=3Dc1d1f2b0 idVendor=3D0x67c idProduct=3D0x1=
001=0D
[    1.668256] usb_device_match: device 1-1:1.1, driver hso =0D
[    1.668257] usb_match_id: id=3Dc1a84c64 idVendor=3D0xaf0 idProduct=3D0x6=
711=0D
[    1.668259] usb_match_id: id=3Dc1a84c7c idVendor=3D0xaf0 idProduct=3D0x6=
731=0D
[    1.668260] usb_match_id: id=3Dc1a84c94 idVendor=3D0xaf0 idProduct=3D0x6=
751=0D
[    1.668261] usb_match_id: id=3Dc1a84cac idVendor=3D0xaf0 idProduct=3D0x6=
771=0D
[    1.668263] usb_match_id: id=3Dc1a84cc4 idVendor=3D0xaf0 idProduct=3D0x6=
791=0D
[    1.668264] usb_match_id: id=3Dc1a84cdc idVendor=3D0xaf0 idProduct=3D0x6=
811=0D
[    1.668265] usb_match_id: id=3Dc1a84cf4 idVendor=3D0xaf0 idProduct=3D0x6=
911=0D
[    1.668267] usb_match_id: id=3Dc1a84d0c idVendor=3D0xaf0 idProduct=3D0x6=
951=0D
[    1.668268] usb_match_id: id=3Dc1a84d24 idVendor=3D0xaf0 idProduct=3D0x6=
971=0D
[    1.668270] usb_match_id: id=3Dc1a84d3c idVendor=3D0xaf0 idProduct=3D0x7=
011=0D
[    1.668271] usb_match_id: id=3Dc1a84d54 idVendor=3D0xaf0 idProduct=3D0x7=
031=0D
[    1.668272] usb_match_id: id=3Dc1a84d6c idVendor=3D0xaf0 idProduct=3D0x7=
051=0D
[    1.668274] usb_match_id: id=3Dc1a84d84 idVendor=3D0xaf0 idProduct=3D0x7=
071=0D
[    1.668275] usb_match_id: id=3Dc1a84d9c idVendor=3D0xaf0 idProduct=3D0x7=
111=0D
[    1.668277] usb_match_id: id=3Dc1a84db4 idVendor=3D0xaf0 idProduct=3D0x7=
211=0D
[    1.668278] usb_match_id: id=3Dc1a84dcc idVendor=3D0xaf0 idProduct=3D0x7=
251=0D
[    1.668279] usb_match_id: id=3Dc1a84de4 idVendor=3D0xaf0 idProduct=3D0x7=
271=0D
[    1.668281] usb_match_id: id=3Dc1a84dfc idVendor=3D0xaf0 idProduct=3D0x7=
311=0D
[    1.668282] usb_match_id: id=3Dc1a84e14 idVendor=3D0xaf0 idProduct=3D0xc=
031=0D
[    1.668283] usb_match_id: id=3Dc1a84e2c idVendor=3D0xaf0 idProduct=3D0xd=
013=0D
[    1.668285] usb_match_id: id=3Dc1a84e44 idVendor=3D0xaf0 idProduct=3D0xd=
031=0D
[    1.668286] usb_match_id: id=3Dc1a84e5c idVendor=3D0xaf0 idProduct=3D0xd=
033=0D
[    1.668288] usb_match_id: id=3Dc1a84e74 idVendor=3D0xaf0 idProduct=3D0x7=
301=0D
[    1.668289] usb_match_id: id=3Dc1a84e8c idVendor=3D0xaf0 idProduct=3D0x7=
361=0D
[    1.668290] usb_match_id: id=3Dc1a84ea4 idVendor=3D0xaf0 idProduct=3D0x7=
381=0D
[    1.668292] usb_match_id: id=3Dc1a84ebc idVendor=3D0xaf0 idProduct=3D0x7=
401=0D
[    1.668293] usb_match_id: id=3Dc1a84ed4 idVendor=3D0xaf0 idProduct=3D0x7=
501=0D
[    1.668295] usb_match_id: id=3Dc1a84eec idVendor=3D0xaf0 idProduct=3D0x7=
601=0D
[    1.668296] usb_match_id: id=3Dc1a84f04 idVendor=3D0xaf0 idProduct=3D0x7=
701=0D
[    1.668297] usb_match_id: id=3Dc1a84f1c idVendor=3D0xaf0 idProduct=3D0x7=
706=0D
[    1.668299] usb_match_id: id=3Dc1a84f34 idVendor=3D0xaf0 idProduct=3D0x7=
801=0D
[    1.668300] usb_match_id: id=3Dc1a84f4c idVendor=3D0xaf0 idProduct=3D0x7=
901=0D
[    1.668301] usb_match_id: id=3Dc1a84f64 idVendor=3D0xaf0 idProduct=3D0x7=
a01=0D
[    1.668303] usb_match_id: id=3Dc1a84f7c idVendor=3D0xaf0 idProduct=3D0x7=
a05=0D
[    1.668309] usb_match_id: id=3Dc1a84f94 idVendor=3D0xaf0 idProduct=3D0x8=
200=0D
[    1.668310] usb_match_id: id=3Dc1a84fac idVendor=3D0xaf0 idProduct=3D0x8=
201=0D
[    1.668312] usb_match_id: id=3Dc1a84fc4 idVendor=3D0xaf0 idProduct=3D0x8=
300=0D
[    1.668313] usb_match_id: id=3Dc1a84fdc idVendor=3D0xaf0 idProduct=3D0x8=
302=0D
[    1.668314] usb_match_id: id=3Dc1a84ff4 idVendor=3D0xaf0 idProduct=3D0x8=
304=0D
[    1.668316] usb_match_id: id=3Dc1a8500c idVendor=3D0xaf0 idProduct=3D0x8=
400=0D
[    1.668317] usb_match_id: id=3Dc1a85024 idVendor=3D0xaf0 idProduct=3D0x8=
600=0D
[    1.668318] usb_match_id: id=3Dc1a8503c idVendor=3D0xaf0 idProduct=3D0x8=
800=0D
[    1.668320] usb_match_id: id=3Dc1a85054 idVendor=3D0xaf0 idProduct=3D0x8=
900=0D
[    1.668321] usb_match_id: id=3Dc1a8506c idVendor=3D0xaf0 idProduct=3D0x9=
000=0D
[    1.668323] usb_match_id: id=3Dc1a85084 idVendor=3D0xaf0 idProduct=3D0xd=
035=0D
[    1.668324] usb_match_id: id=3Dc1a8509c idVendor=3D0xaf0 idProduct=3D0xd=
055=0D
[    1.668325] usb_match_id: id=3Dc1a850b4 idVendor=3D0xaf0 idProduct=3D0xd=
155=0D
[    1.668327] usb_match_id: id=3Dc1a850cc idVendor=3D0xaf0 idProduct=3D0xd=
255=0D
[    1.668328] usb_match_id: id=3Dc1a850e4 idVendor=3D0xaf0 idProduct=3D0xd=
057=0D
[    1.668330] usb_match_id: id=3Dc1a850fc idVendor=3D0xaf0 idProduct=3D0xd=
157=0D
[    1.668331] usb_match_id: id=3Dc1a85114 idVendor=3D0xaf0 idProduct=3D0xd=
257=0D
[    1.668332] usb_match_id: id=3Dc1a8512c idVendor=3D0xaf0 idProduct=3D0xd=
357=0D
[    1.668334] usb_match_id: id=3Dc1a85144 idVendor=3D0xaf0 idProduct=3D0xd=
058=0D
[    1.668335] usb_match_id: id=3Dc1a8515c idVendor=3D0xaf0 idProduct=3D0xc=
100=0D
[    1.668337] usb_device_match: device 1-1:1.1, driver asix =0D
[    1.668338] usb_match_id: id=3Dc1a85594 idVendor=3D0x77b idProduct=3D0x2=
226=0D
[    1.668339] usb_match_id: id=3Dc1a855ac idVendor=3D0x846 idProduct=3D0x1=
040=0D
[    1.668341] usb_match_id: id=3Dc1a855c4 idVendor=3D0x2001 idProduct=3D0x=
1a00=0D
[    1.668342] usb_match_id: id=3Dc1a855dc idVendor=3D0xb95 idProduct=3D0x1=
720=0D
[    1.668344] usb_match_id: id=3Dc1a855f4 idVendor=3D0x7b8 idProduct=3D0x4=
20a=0D
[    1.668345] usb_match_id: id=3Dc1a8560c idVendor=3D0x8dd idProduct=3D0x9=
0ff=0D
[    1.668346] usb_match_id: id=3Dc1a85624 idVendor=3D0x557 idProduct=3D0x2=
009=0D
[    1.668348] usb_match_id: id=3Dc1a8563c idVendor=3D0x411 idProduct=3D0x3=
d=0D
[    1.668349] usb_match_id: id=3Dc1a85654 idVendor=3D0x411 idProduct=3D0x6=
e=0D
[    1.668350] usb_match_id: id=3Dc1a8566c idVendor=3D0x6189 idProduct=3D0x=
182d=0D
[    1.668352] usb_match_id: id=3Dc1a85684 idVendor=3D0xdf6 idProduct=3D0x5=
6=0D
[    1.668353] usb_match_id: id=3Dc1a8569c idVendor=3D0x7aa idProduct=3D0x1=
7=0D
[    1.668355] usb_match_id: id=3Dc1a856b4 idVendor=3D0x1189 idProduct=3D0x=
893=0D
[    1.668379] usb_match_id: id=3Dc1a856cc idVendor=3D0x1631 idProduct=3D0x=
6200=0D
[    1.668381] usb_match_id: id=3Dc1a856e4 idVendor=3D0x4f1 idProduct=3D0x3=
008=0D
[    1.668382] usb_match_id: id=3Dc1a856fc idVendor=3D0xb95 idProduct=3D0x7=
72b=0D
[    1.668383] usb_match_id: id=3Dc1a85714 idVendor=3D0xb95 idProduct=3D0x7=
720=0D
[    1.668385] usb_match_id: id=3Dc1a8572c idVendor=3D0xb95 idProduct=3D0x1=
780=0D
[    1.668386] usb_match_id: id=3Dc1a85744 idVendor=3D0x789 idProduct=3D0x1=
60=0D
[    1.668387] usb_match_id: id=3Dc1a8575c idVendor=3D0x13b1 idProduct=3D0x=
18=0D
[    1.668389] usb_match_id: id=3Dc1a85774 idVendor=3D0x1557 idProduct=3D0x=
7720=0D
[    1.668390] usb_match_id: id=3Dc1a8578c idVendor=3D0x7d1 idProduct=3D0x3=
c05=0D
[    1.668395] usb_match_id: id=3Dc1a857a4 idVendor=3D0x2001 idProduct=3D0x=
3c05=0D
[    1.668397] usb_match_id: id=3Dc1a857bc idVendor=3D0x1737 idProduct=3D0x=
39=0D
[    1.668398] usb_match_id: id=3Dc1a857d4 idVendor=3D0x4bb idProduct=3D0x9=
30=0D
[    1.668400] usb_match_id: id=3Dc1a857ec idVendor=3D0x50d idProduct=3D0x5=
055=0D
[    1.668401] usb_match_id: id=3Dc1a85804 idVendor=3D0x5ac idProduct=3D0x1=
402=0D
[    1.668402] usb_match_id: id=3Dc1a8581c idVendor=3D0xb95 idProduct=3D0x7=
72a=0D
[    1.668404] usb_match_id: id=3Dc1a85834 idVendor=3D0x14ea idProduct=3D0x=
ab11=0D
[    1.668405] usb_match_id: id=3Dc1a8584c idVendor=3D0xdb0 idProduct=3D0xa=
877=0D
[    1.668408] usb_match_id: id=3Dc1a85864 idVendor=3D0xb95 idProduct=3D0x7=
e2b=0D
[    1.668410] usb_match_id: id=3Dc1a8587c idVendor=3D0xb95 idProduct=3D0x1=
72a=0D
[    1.668411] usb_device_match: device 1-1:1.1, driver MOSCHIP usb-etherne=
t driver =0D
[    1.668417] usb_match_id: id=3Dc1a85d5c idVendor=3D0x9710 idProduct=3D0x=
7832=0D
[    1.668418] usb_match_id: id=3Dc1a85d74 idVendor=3D0x9710 idProduct=3D0x=
7830=0D
[    1.668420] usb_match_id: id=3Dc1a85d8c idVendor=3D0x9710 idProduct=3D0x=
7730=0D
[    1.668421] usb_match_id: id=3Dc1a85da4 idVendor=3D0xdf6 idProduct=3D0x2=
1=0D
[    1.668423] usb_device_match: device 1-1:1.1, driver kalmia =0D
[    1.668424] usb_match_id: id=3Dc1a85fec idVendor=3D0x4e8 idProduct=3D0x6=
89a=0D
[    1.668425] usb_match_id: id=3Dc1a86004 idVendor=3D0x4e8 idProduct=3D0x6=
889=0D
[    1.668427] usb_device_match: device 1-1:1.1, driver cx82310_eth =0D
[    1.668428] usb_match_id: id=3Dc1a86078 idVendor=3D0x572 idProduct=3D0xc=
b01=0D
[    1.668429] usb_device_match: device 1-1:1.1, driver cdc_ncm =0D
[    1.668430] usb_match_id: id=3Dc1a861a4 idVendor=3D0xbdb idProduct=3D0x0=
=0D
[    1.668431] usb_match_id: id=3Dc1a861bc idVendor=3D0x0 idProduct=3D0x0=0D
[    1.668433] usb_device_match: device 1-1:1.1, driver qmi_wwan =0D
[    1.668434] usb_match_id: id=3Dc1a862b8 idVendor=3D0x12d1 idProduct=3D0x=
0=0D
[    1.668435] usb_match_id: id=3Dc1a862d0 idVendor=3D0x12d1 idProduct=3D0x=
0=0D
[    1.668436] usb_match_id: id=3Dc1a862e8 idVendor=3D0x12d1 idProduct=3D0x=
0=0D
[    1.668437] usb_match_id: id=3Dc1a86300 idVendor=3D0x106c idProduct=3D0x=
3718=0D
[    1.668439] usb_match_id: id=3Dc1a86318 idVendor=3D0x19d2 idProduct=3D0x=
167=0D
[    1.668440] usb_match_id: id=3Dc1a86330 idVendor=3D0x19d2 idProduct=3D0x=
326=0D
[    1.668441] usb_match_id: id=3Dc1a86348 idVendor=3D0x19d2 idProduct=3D0x=
55=0D
[    1.668442] usb_match_id: id=3Dc1a86360 idVendor=3D0x19d2 idProduct=3D0x=
63=0D
[    1.668444] usb_match_id: id=3Dc1a86378 idVendor=3D0x19d2 idProduct=3D0x=
1008=0D
[    1.668445] usb_match_id: id=3Dc1a86390 idVendor=3D0x19d2 idProduct=3D0x=
1010=0D
[    1.668446] usb_match_id: id=3Dc1a863a8 idVendor=3D0x19d2 idProduct=3D0x=
2002=0D
[    1.668447] usb_match_id: id=3Dc1a863c0 idVendor=3D0x19d2 idProduct=3D0x=
104=0D
[    1.668448] usb_match_id: id=3Dc1a863d8 idVendor=3D0x19d2 idProduct=3D0x=
1402=0D
[    1.668449] usb_match_id: id=3Dc1a863f0 idVendor=3D0x1199 idProduct=3D0x=
68a2=0D
[    1.668451] usb_match_id: id=3Dc1a86408 idVendor=3D0x5c6 idProduct=3D0x9=
212=0D
[    1.668452] usb_match_id: id=3Dc1a86420 idVendor=3D0x3f0 idProduct=3D0x1=
f1d=0D
[    1.668453] usb_match_id: id=3Dc1a86438 idVendor=3D0x3f0 idProduct=3D0x3=
71d=0D
[    1.668454] usb_match_id: id=3Dc1a86450 idVendor=3D0x4da idProduct=3D0x2=
50d=0D
[    1.668456] usb_match_id: id=3Dc1a86468 idVendor=3D0x413c idProduct=3D0x=
8172=0D
[    1.668457] usb_match_id: id=3Dc1a86480 idVendor=3D0x1410 idProduct=3D0x=
a001=0D
[    1.668458] usb_match_id: id=3Dc1a86498 idVendor=3D0xb05 idProduct=3D0x1=
776=0D
[    1.668460] usb_match_id: id=3Dc1a864b0 idVendor=3D0x19d2 idProduct=3D0x=
fff3=0D
[    1.668461] usb_match_id: id=3Dc1a864c8 idVendor=3D0x5c6 idProduct=3D0x9=
001=0D
[    1.668462] usb_match_id: id=3Dc1a864e0 idVendor=3D0x5c6 idProduct=3D0x9=
002=0D
[    1.668463] usb_match_id: id=3Dc1a864f8 idVendor=3D0x5c6 idProduct=3D0x9=
202=0D
[    1.668465] usb_match_id: id=3Dc1a86510 idVendor=3D0x5c6 idProduct=3D0x9=
203=0D
[    1.668466] usb_match_id: id=3Dc1a86528 idVendor=3D0x5c6 idProduct=3D0x9=
222=0D
[    1.668467] usb_match_id: id=3Dc1a86540 idVendor=3D0x5c6 idProduct=3D0x9=
009=0D
[    1.668468] usb_match_id: id=3Dc1a86558 idVendor=3D0x413c idProduct=3D0x=
8186=0D
[    1.668470] usb_match_id: id=3Dc1a86570 idVendor=3D0x5c6 idProduct=3D0x9=
20b=0D
[    1.668471] usb_match_id: id=3Dc1a86588 idVendor=3D0x5c6 idProduct=3D0x9=
225=0D
[    1.668472] usb_match_id: id=3Dc1a865a0 idVendor=3D0x5c6 idProduct=3D0x9=
245=0D
[    1.668474] usb_match_id: id=3Dc1a865b8 idVendor=3D0x3f0 idProduct=3D0x2=
51d=0D
[    1.668475] usb_match_id: id=3Dc1a865d0 idVendor=3D0x5c6 idProduct=3D0x9=
215=0D
[    1.668476] usb_match_id: id=3Dc1a865e8 idVendor=3D0x5c6 idProduct=3D0x9=
265=0D
[    1.668478] usb_match_id: id=3Dc1a86600 idVendor=3D0x5c6 idProduct=3D0x9=
235=0D
[    1.668485] usb_match_id: id=3Dc1a86618 idVendor=3D0x5c6 idProduct=3D0x9=
275=0D
[    1.668487] usb_match_id: id=3Dc1a86630 idVendor=3D0x1199 idProduct=3D0x=
9001=0D
[    1.668488] usb_match_id: id=3Dc1a86648 idVendor=3D0x1199 idProduct=3D0x=
9002=0D
[    1.668490] usb_match_id: id=3Dc1a86660 idVendor=3D0x1199 idProduct=3D0x=
9003=0D
[    1.668491] usb_match_id: id=3Dc1a86678 idVendor=3D0x1199 idProduct=3D0x=
9004=0D
[    1.668492] usb_match_id: id=3Dc1a86690 idVendor=3D0x1199 idProduct=3D0x=
9005=0D
[    1.668499] usb_match_id: id=3Dc1a866a8 idVendor=3D0x1199 idProduct=3D0x=
9006=0D
[    1.668500] usb_match_id: id=3Dc1a866c0 idVendor=3D0x1199 idProduct=3D0x=
9007=0D
[    1.668501] usb_match_id: id=3Dc1a866d8 idVendor=3D0x1199 idProduct=3D0x=
9008=0D
[    1.668504] usb_match_id: id=3Dc1a866f0 idVendor=3D0x1199 idProduct=3D0x=
9009=0D
[    1.668505] usb_match_id: id=3Dc1a86708 idVendor=3D0x1199 idProduct=3D0x=
900a=0D
[    1.668506] usb_match_id: id=3Dc1a86720 idVendor=3D0x1199 idProduct=3D0x=
9011=0D
[    1.668508] usb_match_id: id=3Dc1a86738 idVendor=3D0x16d8 idProduct=3D0x=
8002=0D
[    1.668509] usb_match_id: id=3Dc1a86750 idVendor=3D0x5c6 idProduct=3D0x9=
205=0D
[    1.668510] usb_match_id: id=3Dc1a86768 idVendor=3D0x1199 idProduct=3D0x=
9013=0D
[    1.668512] usb_match_id: id=3Dc1a86780 idVendor=3D0x1199 idProduct=3D0x=
9015=0D
[    1.668513] usb_match_id: id=3Dc1a86798 idVendor=3D0x1199 idProduct=3D0x=
9019=0D
[    1.668514] usb_device_match: device 1-1:1.1, driver usblp =0D
[    1.668516] usb_match_id: id=3Dc1a89540 idVendor=3D0x0 idProduct=3D0x0=0D
[    1.668517] usb_match_id: id=3Dc1a89558 idVendor=3D0x0 idProduct=3D0x0=0D
[    1.668518] usb_match_id: id=3Dc1a89570 idVendor=3D0x0 idProduct=3D0x0=0D
[    1.668520] usb_match_id: id=3Dc1a89588 idVendor=3D0x0 idProduct=3D0x0=0D
[    1.668521] usb_match_id: id=3Dc1a895a0 idVendor=3D0x0 idProduct=3D0x0=0D
[    1.668522] usb_match_id: id=3Dc1a895b8 idVendor=3D0x0 idProduct=3D0x0=0D
[    1.668524] usb_match_id: id=3Dc1a895d0 idVendor=3D0x4b8 idProduct=3D0x2=
02=0D
[    1.668525] usb_device_match: device 1-1:1.1, driver cdc_wdm =0D
[    1.668526] usb_match_id: id=3Dc1a8967c idVendor=3D0x0 idProduct=3D0x0=0D
[    1.668528] usb_device_match: device 1-1:1.1, driver usbtmc =0D
[    1.668529] usb_match_id: id=3Dc1a89730 idVendor=3D0x0 idProduct=3D0x0=0D
[    1.668531] usb_match_id: id=3Dc1a89748 idVendor=3D0x0 idProduct=3D0x0=0D
[    1.668532] usb_device_match: device 1-1:1.1, driver mdc800 =0D
[    1.668533] usb_match_id: id=3Dc1a897e0 idVendor=3D0x55f idProduct=3D0xa=
800=0D
[    1.668535] usb_device_match: device 1-1:1.1, driver cypress_cy7c63 =0D
[    1.668536] usb_match_id: id=3Dc1a89878 idVendor=3D0xa2c idProduct=3D0x8=
=0D
[    1.668538] usb_device_match: device 1-1:1.1, driver cytherm =0D
[    1.668539] usb_match_id: id=3Dc1a898a8 idVendor=3D0x4b4 idProduct=3D0x2=
=0D
[    1.668541] usb_device_match: device 1-1:1.1, driver emi62 - firmware lo=
ader =0D
[    1.668542] usb_match_id: id=3Dc1f85ca0 idVendor=3D0x86a idProduct=3D0x1=
10=0D
[    1.668543] usb_device_match: device 1-1:1.1, driver ftdi-elan =0D
[    1.668545] usb_match_id: id=3Dc1a89924 idVendor=3D0x403 idProduct=3D0xd=
6ea=0D
[    1.668546] usb_device_match: device 1-1:1.1, driver idmouse =0D
[    1.668547] usb_match_id: id=3Dc1a899bc idVendor=3D0x681 idProduct=3D0x5=
=0D
[    1.668549] usb_match_id: id=3Dc1a899d4 idVendor=3D0x681 idProduct=3D0x1=
0=0D
[    1.668550] usb_device_match: device 1-1:1.1, driver usbled =0D
[    1.668551] usb_match_id: id=3Dc1a89a78 idVendor=3D0xfc5 idProduct=3D0x1=
223=0D
[    1.668552] usb_match_id: id=3Dc1a89a90 idVendor=3D0x1d34 idProduct=3D0x=
4=0D
[    1.668553] usb_match_id: id=3Dc1a89aa8 idVendor=3D0x1d34 idProduct=3D0x=
a=0D
[    1.668555] usb_device_match: device 1-1:1.1, driver legousbtower =0D
[    1.668556] usb_match_id: id=3Dc1a89c70 idVendor=3D0x694 idProduct=3D0x1=
=0D
[    1.668557] usb_device_match: device 1-1:1.1, driver trancevibrator =0D
[    1.668558] usb_match_id: id=3Dc1a89d08 idVendor=3D0xb49 idProduct=3D0x6=
4f=0D
[    1.668559] usb_device_match: device 1-1:1.1, driver usbsevseg =0D
[    1.668560] usb_match_id: id=3Dc1a89d48 idVendor=3D0xfc5 idProduct=3D0x1=
227=0D
[    1.668560] usb_device_match: device 1-1:1.1, driver yurex =0D
[    1.668561] usb_match_id: id=3Dc1d384e4 idVendor=3D0xc45 idProduct=3D0x1=
010=0D
[    1.668562] usb_device_match: device 1-1:1.1, driver xpad =0D
[    1.668563] usb_match_id: id=3Dc1d454c4 idVendor=3D0x0 idProduct=3D0x0=0D
[    1.668563] usb_match_id: id=3Dc1d454dc idVendor=3D0x45e idProduct=3D0x0=
=0D
[    1.668564] usb_match_id: id=3Dc1d454f4 idVendor=3D0x45e idProduct=3D0x0=
=0D
[    1.668565] usb_match_id: id=3Dc1d4550c idVendor=3D0x46d idProduct=3D0x0=
=0D
[    1.668566] usb_match_id: id=3Dc1d45524 idVendor=3D0x46d idProduct=3D0x0=
=0D
[    1.668566] usb_match_id: id=3Dc1d4553c idVendor=3D0x738 idProduct=3D0x0=
=0D
[    1.668567] usb_match_id: id=3Dc1d45554 idVendor=3D0x738 idProduct=3D0x0=
=0D
[    1.668572] usb_match_id: id=3Dc1d4556c idVendor=3D0x738 idProduct=3D0x4=
540=0D
[    1.668573] usb_match_id: id=3Dc1d45584 idVendor=3D0xe6f idProduct=3D0x0=
=0D
[    1.668574] usb_match_id: id=3Dc1d4559c idVendor=3D0xe6f idProduct=3D0x0=
=0D
[    1.668574] usb_match_id: id=3Dc1d455b4 idVendor=3D0x12ab idProduct=3D0x=
0=0D
[    1.668575] usb_match_id: id=3Dc1d455cc idVendor=3D0x12ab idProduct=3D0x=
0=0D
[    1.668576] usb_match_id: id=3Dc1d455e4 idVendor=3D0x1430 idProduct=3D0x=
0=0D
[    1.668577] usb_match_id: id=3Dc1d455fc idVendor=3D0x1430 idProduct=3D0x=
0=0D
[    1.668578] usb_match_id: id=3Dc1d45614 idVendor=3D0x146b idProduct=3D0x=
0=0D
[    1.668578] usb_match_id: id=3Dc1d4562c idVendor=3D0x146b idProduct=3D0x=
0=0D
[    1.668579] usb_match_id: id=3Dc1d45644 idVendor=3D0x1bad idProduct=3D0x=
0=0D
[    1.668580] usb_match_id: id=3Dc1d4565c idVendor=3D0x1bad idProduct=3D0x=
0=0D
[    1.668581] usb_match_id: id=3Dc1d45674 idVendor=3D0xf0d idProduct=3D0x0=
=0D
[    1.668581] usb_match_id: id=3Dc1d4568c idVendor=3D0xf0d idProduct=3D0x0=
=0D
[    1.668582] usb_match_id: id=3Dc1d456a4 idVendor=3D0x1689 idProduct=3D0x=
0=0D
[    1.668583] usb_match_id: id=3Dc1d456bc idVendor=3D0x1689 idProduct=3D0x=
0=0D
[    1.668584] usb_device_match: device 1-1:1.1, driver ati_remote2 =0D
[    1.668585] usb_match_id: id=3Dc1d466f0 idVendor=3D0x471 idProduct=3D0x6=
02=0D
[    1.668585] usb_device_match: device 1-1:1.1, driver i2c-diolan-u2c =0D
[    1.668586] usb_match_id: id=3Dc1a8d820 idVendor=3D0xabf idProduct=3D0x3=
370=0D
[    1.668587] usb_device_match: device 1-1:1.1, driver ttusb-dec =0D
[    1.668588] usb_match_id: id=3Dc1d7ce74 idVendor=3D0xb48 idProduct=3D0x1=
006=0D
[    1.668589] usb_match_id: id=3Dc1d7ce8c idVendor=3D0xb48 idProduct=3D0x1=
008=0D
[    1.668589] usb_match_id: id=3Dc1d7cea4 idVendor=3D0xb48 idProduct=3D0x1=
009=0D
[    1.668590] usb_device_match: device 1-1:1.1, driver dvb_usb_dtt200u =0D
[    1.668591] usb_match_id: id=3Dc1d80748 idVendor=3D0x14aa idProduct=3D0x=
201=0D
[    1.668592] usb_match_id: id=3Dc1d80760 idVendor=3D0x14aa idProduct=3D0x=
301=0D
[    1.668593] usb_match_id: id=3Dc1d80778 idVendor=3D0x14aa idProduct=3D0x=
222=0D
[    1.668593] usb_match_id: id=3Dc1d80790 idVendor=3D0x14aa idProduct=3D0x=
221=0D
[    1.668594] usb_match_id: id=3Dc1d807a8 idVendor=3D0x14aa idProduct=3D0x=
22a=0D
[    1.668595] usb_match_id: id=3Dc1d807c0 idVendor=3D0x14aa idProduct=3D0x=
22b=0D
[    1.668596] usb_match_id: id=3Dc1d807d8 idVendor=3D0x14aa idProduct=3D0x=
225=0D
[    1.668597] usb_match_id: id=3Dc1d807f0 idVendor=3D0x14aa idProduct=3D0x=
226=0D
[    1.668597] usb_match_id: id=3Dc1d80808 idVendor=3D0x14aa idProduct=3D0x=
220=0D
[    1.668617] usb_match_id: id=3Dc1d80820 idVendor=3D0x18f3 idProduct=3D0x=
220=0D
[    1.668619] usb_device_match: device 1-1:1.1, driver dvb_usb_nova_t_usb2=
 =0D
[    1.668621] usb_match_id: id=3Dc1d81b6c idVendor=3D0x2040 idProduct=3D0x=
9300=0D
[    1.668622] usb_match_id: id=3Dc1d81b84 idVendor=3D0x2040 idProduct=3D0x=
9301=0D
[    1.668623] usb_device_match: device 1-1:1.1, driver dvb_usb_umt_010 =0D
[    1.668625] usb_match_id: id=3Dc1d824f4 idVendor=3D0x15f4 idProduct=3D0x=
1=0D
[    1.668626] usb_match_id: id=3Dc1d8250c idVendor=3D0x15f4 idProduct=3D0x=
15=0D
[    1.668627] usb_device_match: device 1-1:1.1, driver dvb_usb_gl861 =0D
[    1.668629] usb_match_id: id=3Dc1d82eb4 idVendor=3D0xdb0 idProduct=3D0x5=
581=0D
[    1.668630] usb_match_id: id=3Dc1d82ecc idVendor=3D0x5e3 idProduct=3D0xf=
170=0D
[    1.668631] usb_device_match: device 1-1:1.1, driver dvb_usb_au6610 =0D
[    1.668632] usb_match_id: id=3Dc1d838b8 idVendor=3D0x58f idProduct=3D0x6=
610=0D
[    1.668634] usb_device_match: device 1-1:1.1, driver dvb_usb_ttusb2 =0D
[    1.668635] usb_match_id: id=3Dc1d8522c idVendor=3D0x2304 idProduct=3D0x=
20f=0D
[    1.668636] usb_match_id: id=3Dc1d85244 idVendor=3D0x2304 idProduct=3D0x=
222=0D
[    1.668638] usb_match_id: id=3Dc1d8525c idVendor=3D0xb48 idProduct=3D0x3=
006=0D
[    1.668639] usb_match_id: id=3Dc1d85274 idVendor=3D0xb48 idProduct=3D0x3=
00d=0D
[    1.668640] usb_device_match: device 1-1:1.1, driver dvb_usb_dib0700 =0D
[    1.668642] usb_match_id: id=3Dc1d91b48 idVendor=3D0x10b8 idProduct=3D0x=
1e14=0D
[    1.668643] usb_match_id: id=3Dc1d91b60 idVendor=3D0x10b8 idProduct=3D0x=
1e78=0D
[    1.668644] usb_match_id: id=3Dc1d91b78 idVendor=3D0x2040 idProduct=3D0x=
9941=0D
[    1.668646] usb_match_id: id=3Dc1d91b90 idVendor=3D0x2040 idProduct=3D0x=
9950=0D
[    1.668647] usb_match_id: id=3Dc1d91ba8 idVendor=3D0x2040 idProduct=3D0x=
7050=0D
[    1.668653] usb_match_id: id=3Dc1d91bc0 idVendor=3D0x7ca idProduct=3D0xa=
807=0D
[    1.668655] usb_match_id: id=3Dc1d91bd8 idVendor=3D0x185b idProduct=3D0x=
1e78=0D
[    1.668656] usb_match_id: id=3Dc1d91bf0 idVendor=3D0x1584 idProduct=3D0x=
6003=0D
[    1.668658] usb_match_id: id=3Dc1d91c08 idVendor=3D0x413 idProduct=3D0x6=
f00=0D
[    1.668659] usb_match_id: id=3Dc1d91c20 idVendor=3D0x2040 idProduct=3D0x=
7060=0D
[    1.668660] usb_match_id: id=3Dc1d91c38 idVendor=3D0x7ca idProduct=3D0xb=
808=0D
[    1.668661] usb_match_id: id=3Dc1d91c50 idVendor=3D0x2304 idProduct=3D0x=
22c=0D
[    1.668663] usb_match_id: id=3Dc1d91c68 idVendor=3D0xccd idProduct=3D0x5=
a=0D
[    1.668664] usb_match_id: id=3Dc1d91c80 idVendor=3D0x2040 idProduct=3D0x=
9580=0D
[    1.668666] usb_match_id: id=3Dc1d91c98 idVendor=3D0x10b8 idProduct=3D0x=
1ef0=0D
[    1.668667] usb_match_id: id=3Dc1d91cb0 idVendor=3D0x10b8 idProduct=3D0x=
1ebc=0D
[    1.668668] usb_match_id: id=3Dc1d91cc8 idVendor=3D0x2304 idProduct=3D0x=
228=0D
[    1.668670] usb_match_id: id=3Dc1d91ce0 idVendor=3D0x10b8 idProduct=3D0x=
1ebe=0D
[    1.668671] usb_match_id: id=3Dc1d91cf8 idVendor=3D0x2304 idProduct=3D0x=
229=0D
[    1.668672] usb_match_id: id=3Dc1d91d10 idVendor=3D0x185b idProduct=3D0x=
1e80=0D
[    1.668674] usb_match_id: id=3Dc1d91d28 idVendor=3D0x7ca idProduct=3D0xb=
568=0D
[    1.668675] usb_match_id: id=3Dc1d91d40 idVendor=3D0x1044 idProduct=3D0x=
7001=0D
[    1.668676] usb_match_id: id=3Dc1d91d58 idVendor=3D0x5d8 idProduct=3D0x8=
10f=0D
[    1.668678] usb_match_id: id=3Dc1d91d70 idVendor=3D0xb05 idProduct=3D0x1=
71f=0D
[    1.668679] usb_match_id: id=3Dc1d91d88 idVendor=3D0xb05 idProduct=3D0x1=
73f=0D
[    1.668680] usb_match_id: id=3Dc1d91da0 idVendor=3D0x2040 idProduct=3D0x=
7070=0D
[    1.668681] usb_match_id: id=3Dc1d91db8 idVendor=3D0x2040 idProduct=3D0x=
7080=0D
[    1.668683] usb_match_id: id=3Dc1d91dd0 idVendor=3D0xccd idProduct=3D0x5=
8=0D
[    1.668684] usb_match_id: id=3Dc1d91de8 idVendor=3D0x2304 idProduct=3D0x=
22e=0D
[    1.668685] usb_match_id: id=3Dc1d91e00 idVendor=3D0x2304 idProduct=3D0x=
236=0D
[    1.668686] usb_match_id: id=3Dc1d91e18 idVendor=3D0x2304 idProduct=3D0x=
237=0D
[    1.668686] usb_match_id: id=3Dc1d91e30 idVendor=3D0x1164 idProduct=3D0x=
1edc=0D
[    1.668687] usb_match_id: id=3Dc1d91e48 idVendor=3D0xccd idProduct=3D0x6=
0=0D
[    1.668688] usb_match_id: id=3Dc1d91e60 idVendor=3D0xccd idProduct=3D0x7=
8=0D
[    1.668689] usb_match_id: id=3Dc1d91e78 idVendor=3D0x413 idProduct=3D0x6=
f01=0D
[    1.668690] usb_match_id: id=3Dc1d91e90 idVendor=3D0x2040 idProduct=3D0x=
5200=0D
[    1.668690] usb_match_id: id=3Dc1d91ea8 idVendor=3D0x2040 idProduct=3D0x=
8400=0D
[    1.668691] usb_match_id: id=3Dc1d91ec0 idVendor=3D0x1044 idProduct=3D0x=
7002=0D
[    1.668692] usb_match_id: id=3Dc1d91ed8 idVendor=3D0x1164 idProduct=3D0x=
1f08=0D
[    1.668693] usb_match_id: id=3Dc1d91ef0 idVendor=3D0xb05 idProduct=3D0x1=
736=0D
[    1.668694] usb_match_id: id=3Dc1d91f08 idVendor=3D0x2304 idProduct=3D0x=
23a=0D
[    1.668694] usb_match_id: id=3Dc1d91f20 idVendor=3D0x2304 idProduct=3D0x=
23b=0D
[    1.668695] usb_match_id: id=3Dc1d91f38 idVendor=3D0xccd idProduct=3D0x6=
2=0D
[    1.668696] usb_match_id: id=3Dc1d91f50 idVendor=3D0xccd idProduct=3D0x8=
1=0D
[    1.668697] usb_match_id: id=3Dc1d91f68 idVendor=3D0x1415 idProduct=3D0x=
3=0D
[    1.668697] usb_match_id: id=3Dc1d91f80 idVendor=3D0x1164 idProduct=3D0x=
2edc=0D
[    1.668698] usb_match_id: id=3Dc1d91f98 idVendor=3D0x2040 idProduct=3D0x=
b200=0D
[    1.668699] usb_match_id: id=3Dc1d91fb0 idVendor=3D0x2040 idProduct=3D0x=
b210=0D
[    1.668700] usb_match_id: id=3Dc1d91fc8 idVendor=3D0x1164 idProduct=3D0x=
871=0D
[    1.668701] usb_match_id: id=3Dc1d91fe0 idVendor=3D0xfd9 idProduct=3D0x2=
1=0D
[    1.668701] usb_match_id: id=3Dc1d91ff8 idVendor=3D0xfd9 idProduct=3D0x2=
0=0D
[    1.668702] usb_match_id: id=3Dc1d92010 idVendor=3D0x413 idProduct=3D0x6=
0f6=0D
[    1.668703] usb_match_id: id=3Dc1d92028 idVendor=3D0xccd idProduct=3D0x1=
0a0=0D
[    1.668704] usb_match_id: id=3Dc1d92040 idVendor=3D0xccd idProduct=3D0x1=
0a1=0D
[    1.668704] usb_match_id: id=3Dc1d92058 idVendor=3D0x1164 idProduct=3D0x=
1efc=0D
[    1.668705] usb_match_id: id=3Dc1d92070 idVendor=3D0x1164 idProduct=3D0x=
1e8c=0D
[    1.668706] usb_match_id: id=3Dc1d92088 idVendor=3D0x2304 idProduct=3D0x=
243=0D
[    1.668707] usb_match_id: id=3Dc1d920a0 idVendor=3D0x2013 idProduct=3D0x=
245=0D
[    1.668708] usb_match_id: id=3Dc1d920b8 idVendor=3D0x2013 idProduct=3D0x=
248=0D
[    1.668712] usb_match_id: id=3Dc1d920d0 idVendor=3D0x10b8 idProduct=3D0x=
1e80=0D
[    1.668713] usb_match_id: id=3Dc1d920e8 idVendor=3D0xccd idProduct=3D0xa=
b=0D
[    1.668713] usb_match_id: id=3Dc1d92100 idVendor=3D0x10b8 idProduct=3D0x=
1f98=0D
[    1.668714] usb_match_id: id=3Dc1d92118 idVendor=3D0x10b8 idProduct=3D0x=
1f90=0D
[    1.668715] usb_match_id: id=3Dc1d92130 idVendor=3D0x1554 idProduct=3D0x=
5010=0D
[    1.668716] usb_match_id: id=3Dc1d92148 idVendor=3D0x1e59 idProduct=3D0x=
2=0D
[    1.668717] usb_match_id: id=3Dc1d92160 idVendor=3D0x2304 idProduct=3D0x=
245=0D
[    1.668717] usb_match_id: id=3Dc1d92178 idVendor=3D0x2304 idProduct=3D0x=
248=0D
[    1.668718] usb_match_id: id=3Dc1d92190 idVendor=3D0x10b8 idProduct=3D0x=
1fa0=0D
[    1.668719] usb_match_id: id=3Dc1d921a8 idVendor=3D0xfd9 idProduct=3D0x1=
1=0D
[    1.668720] usb_match_id: id=3Dc1d921c0 idVendor=3D0x10b8 idProduct=3D0x=
2383=0D
[    1.668720] usb_match_id: id=3Dc1d921d8 idVendor=3D0x10b8 idProduct=3D0x=
1fa8=0D
[    1.668721] usb_match_id: id=3Dc1d921f0 idVendor=3D0x10b8 idProduct=3D0x=
2384=0D
[    1.668722] usb_match_id: id=3Dc1d92208 idVendor=3D0x10b8 idProduct=3D0x=
1bb2=0D
[    1.668723] usb_match_id: id=3Dc1d92220 idVendor=3D0x10b8 idProduct=3D0x=
1bb4=0D
[    1.668724] usb_match_id: id=3Dc1d92238 idVendor=3D0x14f7 idProduct=3D0x=
4=0D
[    1.668724] usb_match_id: id=3Dc1d92250 idVendor=3D0x1660 idProduct=3D0x=
1921=0D
[    1.668725] usb_match_id: id=3Dc1d92268 idVendor=3D0x2304 idProduct=3D0x=
23d=0D
[    1.668726] usb_match_id: id=3Dc1d92280 idVendor=3D0x2304 idProduct=3D0x=
23e=0D
[    1.668727] usb_match_id: id=3Dc1d92298 idVendor=3D0x10b8 idProduct=3D0x=
1bb7=0D
[    1.668727] usb_match_id: id=3Dc1d922b0 idVendor=3D0x10b8 idProduct=3D0x=
1e6e=0D
[    1.668728] usb_match_id: id=3Dc1d922c8 idVendor=3D0x10b8 idProduct=3D0x=
1f9c=0D
[    1.668729] usb_match_id: id=3Dc1d922e0 idVendor=3D0xfd9 idProduct=3D0x3=
f=0D
[    1.668730] usb_device_match: device 1-1:1.1, driver pctv452e =0D
[    1.668731] usb_match_id: id=3Dc1d94c1c idVendor=3D0x2304 idProduct=3D0x=
21f=0D
[    1.668732] usb_match_id: id=3Dc1d94c34 idVendor=3D0xb48 idProduct=3D0x3=
007=0D
[    1.668732] usb_match_id: id=3Dc1d94c4c idVendor=3D0xb48 idProduct=3D0x3=
00a=0D
[    1.668733] usb_device_match: device 1-1:1.1, driver dw2102 =0D
[    1.668734] usb_match_id: id=3Dc1d97af4 idVendor=3D0x4b4 idProduct=3D0x2=
102=0D
[    1.668735] usb_match_id: id=3Dc1d97b0c idVendor=3D0x4b4 idProduct=3D0x2=
101=0D
[    1.668736] usb_match_id: id=3Dc1d97b24 idVendor=3D0x4b4 idProduct=3D0x2=
104=0D
[    1.668736] usb_match_id: id=3Dc1d97b3c idVendor=3D0x9022 idProduct=3D0x=
d650=0D
[    1.668737] usb_match_id: id=3Dc1d97b54 idVendor=3D0xccd idProduct=3D0x6=
4=0D
[    1.668738] usb_match_id: id=3Dc1d97b6c idVendor=3D0x4b4 idProduct=3D0x3=
101=0D
[    1.668739] usb_match_id: id=3Dc1d97b84 idVendor=3D0x9022 idProduct=3D0x=
d630=0D
[    1.668739] usb_match_id: id=3Dc1d97b9c idVendor=3D0x3011 idProduct=3D0x=
b012=0D
[    1.668740] usb_match_id: id=3Dc1d97bb4 idVendor=3D0x9022 idProduct=3D0x=
d660=0D
[    1.668741] usb_match_id: id=3Dc1d97bcc idVendor=3D0x3034 idProduct=3D0x=
7500=0D
[    1.668742] usb_match_id: id=3Dc1d97be4 idVendor=3D0x1f4d idProduct=3D0x=
3000=0D
[    1.668743] usb_match_id: id=3Dc1d97bfc idVendor=3D0xccd idProduct=3D0xa=
8=0D
[    1.668743] usb_match_id: id=3Dc1d97c14 idVendor=3D0x9022 idProduct=3D0x=
d481=0D
[    1.668744] usb_match_id: id=3Dc1d97c2c idVendor=3D0x9022 idProduct=3D0x=
d482=0D
[    1.668745] usb_match_id: id=3Dc1d97c44 idVendor=3D0x1f4d idProduct=3D0x=
3100=0D
[    1.668746] usb_device_match: device 1-1:1.1, driver dvb_usb_af9015 =0D
[    1.668746] usb_match_id: id=3Dc1d99d24 idVendor=3D0x15a4 idProduct=3D0x=
9015=0D
[    1.668747] usb_match_id: id=3Dc1d99d3c idVendor=3D0x15a4 idProduct=3D0x=
9016=0D
[    1.668748] usb_match_id: id=3Dc1d99d54 idVendor=3D0x413 idProduct=3D0x6=
029=0D
[    1.668749] usb_match_id: id=3Dc1d99d6c idVendor=3D0x2304 idProduct=3D0x=
22b=0D
[    1.668750] usb_match_id: id=3Dc1d99d84 idVendor=3D0x1b80 idProduct=3D0x=
e399=0D
[    1.668750] usb_match_id: id=3Dc1d99d9c idVendor=3D0x13d3 idProduct=3D0x=
3226=0D
[    1.668751] usb_match_id: id=3Dc1d99db4 idVendor=3D0x13d3 idProduct=3D0x=
3237=0D
[    1.668752] usb_match_id: id=3Dc1d99dcc idVendor=3D0xccd idProduct=3D0x6=
9=0D
[    1.668753] usb_match_id: id=3Dc1d99de4 idVendor=3D0x1b80 idProduct=3D0x=
c160=0D
[    1.668753] usb_match_id: id=3Dc1d99dfc idVendor=3D0x7ca idProduct=3D0xa=
815=0D
[    1.668754] usb_match_id: id=3Dc1d99e14 idVendor=3D0x1ae7 idProduct=3D0x=
381=0D
[    1.668757] usb_match_id: id=3Dc1d99e2c idVendor=3D0x1462 idProduct=3D0x=
8801=0D
[    1.668758] usb_match_id: id=3Dc1d99e44 idVendor=3D0x7ca idProduct=3D0x8=
150=0D
[    1.668759] usb_match_id: id=3Dc1d99e5c idVendor=3D0x10b9 idProduct=3D0x=
8000=0D
[    1.668760] usb_match_id: id=3Dc1d99e74 idVendor=3D0x7ca idProduct=3D0xa=
309=0D
[    1.668760] usb_match_id: id=3Dc1d99e8c idVendor=3D0x1462 idProduct=3D0x=
8807=0D
[    1.668761] usb_match_id: id=3Dc1d99ea4 idVendor=3D0x1b80 idProduct=3D0x=
e396=0D
[    1.668762] usb_match_id: id=3Dc1d99ebc idVendor=3D0x1b80 idProduct=3D0x=
e39b=0D
[    1.668763] usb_match_id: id=3Dc1d99ed4 idVendor=3D0x1b80 idProduct=3D0x=
e395=0D
[    1.668763] usb_match_id: id=3Dc1d99eec idVendor=3D0x15a4 idProduct=3D0x=
901b=0D
[    1.668764] usb_match_id: id=3Dc1d99f04 idVendor=3D0x7ca idProduct=3D0x8=
50a=0D
[    1.668765] usb_match_id: id=3Dc1d99f1c idVendor=3D0x7ca idProduct=3D0xa=
805=0D
[    1.668766] usb_match_id: id=3Dc1d99f34 idVendor=3D0x1b80 idProduct=3D0x=
e397=0D
[    1.668767] usb_match_id: id=3Dc1d99f4c idVendor=3D0x1b80 idProduct=3D0x=
c810=0D
[    1.668767] usb_match_id: id=3Dc1d99f64 idVendor=3D0x458 idProduct=3D0x4=
012=0D
[    1.668768] usb_match_id: id=3Dc1d99f7c idVendor=3D0x1b80 idProduct=3D0x=
e400=0D
[    1.668769] usb_match_id: id=3Dc1d99f94 idVendor=3D0x1b80 idProduct=3D0x=
c161=0D
[    1.668770] usb_match_id: id=3Dc1d99fac idVendor=3D0x1b80 idProduct=3D0x=
e39d=0D
[    1.668770] usb_match_id: id=3Dc1d99fc4 idVendor=3D0x1b80 idProduct=3D0x=
e402=0D
[    1.668771] usb_match_id: id=3Dc1d99fdc idVendor=3D0x413 idProduct=3D0x6=
a04=0D
[    1.668772] usb_match_id: id=3Dc1d99ff4 idVendor=3D0x1b80 idProduct=3D0x=
e383=0D
[    1.668773] usb_match_id: id=3Dc1d9a00c idVendor=3D0x1b80 idProduct=3D0x=
e39a=0D
[    1.668774] usb_match_id: id=3Dc1d9a024 idVendor=3D0x7ca idProduct=3D0x8=
15a=0D
[    1.668774] usb_match_id: id=3Dc1d9a03c idVendor=3D0xccd idProduct=3D0x9=
7=0D
[    1.668775] usb_match_id: id=3Dc1d9a054 idVendor=3D0xccd idProduct=3D0x9=
9=0D
[    1.668776] usb_match_id: id=3Dc1d9a06c idVendor=3D0x7ca idProduct=3D0x8=
50b=0D
[    1.668777] usb_match_id: id=3Dc1d9a084 idVendor=3D0x1f4d idProduct=3D0x=
9016=0D
[    1.668777] usb_match_id: id=3Dc1d9a09c idVendor=3D0x1b80 idProduct=3D0x=
e401=0D
[    1.668778] usb_device_match: device 1-1:1.1, driver cinergyT2 =0D
[    1.668779] usb_match_id: id=3Dc1d9ad3c idVendor=3D0xccd idProduct=3D0x3=
8=0D
[    1.668780] usb_device_match: device 1-1:1.1, driver dvb_usb_ce6230 =0D
[    1.668781] usb_match_id: id=3Dc1d9b9e0 idVendor=3D0x8086 idProduct=3D0x=
9500=0D
[    1.668781] usb_match_id: id=3Dc1d9b9f8 idVendor=3D0x7ca idProduct=3D0xa=
310=0D
[    1.668782] usb_device_match: device 1-1:1.1, driver dvb_usb_friio =0D
[    1.668783] usb_match_id: id=3Dc1d9c418 idVendor=3D0x7a69 idProduct=3D0x=
1=0D
[    1.668784] usb_device_match: device 1-1:1.1, driver dvb_usb_ec168 =0D
[    1.668785] usb_match_id: id=3Dc1d9d07c idVendor=3D0x18b4 idProduct=3D0x=
1689=0D
[    1.668785] usb_match_id: id=3Dc1d9d094 idVendor=3D0x18b4 idProduct=3D0x=
fffa=0D
[    1.668786] usb_match_id: id=3Dc1d9d0ac idVendor=3D0x18b4 idProduct=3D0x=
fffb=0D
[    1.668787] usb_match_id: id=3Dc1d9d0c4 idVendor=3D0x18b4 idProduct=3D0x=
1001=0D
[    1.668788] usb_match_id: id=3Dc1d9d0dc idVendor=3D0x18b4 idProduct=3D0x=
1002=0D
[    1.668788] usb_device_match: device 1-1:1.1, driver dvb_usb_az6007 =0D
[    1.668789] usb_match_id: id=3Dc1d9db3c idVendor=3D0x13d3 idProduct=3D0x=
ccd=0D
[    1.668790] usb_match_id: id=3Dc1d9db54 idVendor=3D0xccd idProduct=3D0x1=
0b4=0D
[    1.668791] usb_match_id: id=3Dc1d9db6c idVendor=3D0xccd idProduct=3D0x1=
0a3=0D
[    1.668792] usb_device_match: device 1-1:1.1, driver dvb_usb_az6027 =0D
[    1.668792] usb_match_id: id=3Dc1d9e828 idVendor=3D0x13d3 idProduct=3D0x=
3275=0D
[    1.668793] usb_match_id: id=3Dc1d9e840 idVendor=3D0xccd idProduct=3D0x1=
0a4=0D
[    1.668794] usb_match_id: id=3Dc1d9e858 idVendor=3D0xccd idProduct=3D0x1=
0ac=0D
[    1.668795] usb_match_id: id=3Dc1d9e870 idVendor=3D0x14f7 idProduct=3D0x=
1=0D
[    1.668795] usb_match_id: id=3Dc1d9e888 idVendor=3D0x14f7 idProduct=3D0x=
2=0D
[    1.668796] usb_match_id: id=3Dc1d9e8a0 idVendor=3D0xfd9 idProduct=3D0x2=
a=0D
[    1.668797] usb_device_match: device 1-1:1.1, driver LME2510C_DVB-S =0D
[    1.668798] usb_match_id: id=3Dc1d9fd50 idVendor=3D0x3344 idProduct=3D0x=
1122=0D
[    1.668799] usb_match_id: id=3Dc1d9fd68 idVendor=3D0x3344 idProduct=3D0x=
1120=0D
[    1.668803] usb_match_id: id=3Dc1d9fd80 idVendor=3D0x3344 idProduct=3D0x=
22f0=0D
[    1.668804] usb_device_match: device 1-1:1.1, driver dvb_usb_af9035 =0D
[    1.668805] usb_match_id: id=3Dc1da0434 idVendor=3D0x15a4 idProduct=3D0x=
9035=0D
[    1.668805] usb_match_id: id=3Dc1da044c idVendor=3D0x15a4 idProduct=3D0x=
1000=0D
[    1.668806] usb_match_id: id=3Dc1da0464 idVendor=3D0x15a4 idProduct=3D0x=
1001=0D
[    1.668807] usb_match_id: id=3Dc1da047c idVendor=3D0x15a4 idProduct=3D0x=
1002=0D
[    1.668808] usb_match_id: id=3Dc1da0494 idVendor=3D0x15a4 idProduct=3D0x=
1003=0D
[    1.668808] usb_match_id: id=3Dc1da04ac idVendor=3D0xccd idProduct=3D0x9=
3=0D
[    1.668809] usb_match_id: id=3Dc1da04c4 idVendor=3D0x7ca idProduct=3D0xa=
835=0D
[    1.668810] usb_match_id: id=3Dc1da04dc idVendor=3D0x7ca idProduct=3D0xb=
835=0D
[    1.668811] usb_match_id: id=3Dc1da04f4 idVendor=3D0x7ca idProduct=3D0x1=
867=0D
[    1.668812] usb_match_id: id=3Dc1da050c idVendor=3D0x7ca idProduct=3D0xa=
867=0D
[    1.668812] usb_match_id: id=3Dc1da0524 idVendor=3D0x7ca idProduct=3D0x8=
25=0D
[    1.668813] usb_device_match: device 1-1:1.1, driver DS9490R =0D
[    1.668814] usb_match_id: id=3Dc1da56d8 idVendor=3D0x4fa idProduct=3D0x2=
490=0D
[    1.668815] usb_device_match: device 1-1:1.1, driver pcwd_usb =0D
[    1.668816] usb_match_id: id=3Dc1daa624 idVendor=3D0xc98 idProduct=3D0x1=
140=0D
[    1.668816] usb_device_match: device 1-1:1.1, driver bfusb =0D
[    1.668817] usb_match_id: id=3Dc1daeb08 idVendor=3D0x57c idProduct=3D0x2=
200=0D
[    1.668818] usb_device_match: device 1-1:1.1, driver btusb =0D
[    1.668819] usb_match_id: id=3Dc1daf384 idVendor=3D0x0 idProduct=3D0x0=0D
[    1.668819] usb_match_id: id=3Dc1daf39c idVendor=3D0xa5c idProduct=3D0x2=
1e1=0D
[    1.668820] usb_match_id: id=3Dc1daf3b4 idVendor=3D0x5ac idProduct=3D0x8=
213=0D
[    1.668821] usb_match_id: id=3Dc1daf3cc idVendor=3D0x5ac idProduct=3D0x8=
215=0D
[    1.668822] usb_match_id: id=3Dc1daf3e4 idVendor=3D0x5ac idProduct=3D0x8=
218=0D
[    1.668823] usb_match_id: id=3Dc1daf3fc idVendor=3D0x5ac idProduct=3D0x8=
21b=0D
[    1.668823] usb_match_id: id=3Dc1daf414 idVendor=3D0x5ac idProduct=3D0x8=
21f=0D
[    1.668824] usb_match_id: id=3Dc1daf42c idVendor=3D0x5ac idProduct=3D0x8=
21a=0D
[    1.668825] usb_match_id: id=3Dc1daf444 idVendor=3D0x5ac idProduct=3D0x8=
281=0D
[    1.668826] usb_match_id: id=3Dc1daf45c idVendor=3D0x57c idProduct=3D0x3=
800=0D
[    1.668826] usb_match_id: id=3Dc1daf474 idVendor=3D0x4bf idProduct=3D0x3=
0a=0D
[    1.668827] usb_match_id: id=3Dc1daf48c idVendor=3D0x44e idProduct=3D0x3=
001=0D
[    1.668828] usb_match_id: id=3Dc1daf4a4 idVendor=3D0x44e idProduct=3D0x3=
002=0D
[    1.668829] usb_match_id: id=3Dc1daf4bc idVendor=3D0xbdb idProduct=3D0x1=
002=0D
[    1.668829] usb_match_id: id=3Dc1daf4d4 idVendor=3D0xc10 idProduct=3D0x0=
=0D
[    1.668830] usb_match_id: id=3Dc1daf4ec idVendor=3D0x489 idProduct=3D0xe=
042=0D
[    1.668831] usb_match_id: id=3Dc1daf504 idVendor=3D0xa5c idProduct=3D0x2=
1e3=0D
[    1.668832] usb_match_id: id=3Dc1daf51c idVendor=3D0xa5c idProduct=3D0x2=
1e6=0D
[    1.668833] usb_match_id: id=3Dc1daf534 idVendor=3D0xa5c idProduct=3D0x2=
1e8=0D
[    1.668833] usb_match_id: id=3Dc1daf54c idVendor=3D0xa5c idProduct=3D0x2=
1f3=0D
[    1.668834] usb_match_id: id=3Dc1daf564 idVendor=3D0x413c idProduct=3D0x=
8197=0D
[    1.668835] usb_match_id: id=3Dc1daf57c idVendor=3D0x489 idProduct=3D0xe=
033=0D
[    1.668836] usb_device_match: device 1-1:1.1, driver ath3k =0D
[    1.668836] usb_match_id: id=3Dc1db0048 idVendor=3D0xcf3 idProduct=3D0x3=
000=0D
[    1.668837] usb_match_id: id=3Dc1db0060 idVendor=3D0xcf3 idProduct=3D0x3=
002=0D
[    1.668838] usb_match_id: id=3Dc1db0078 idVendor=3D0xcf3 idProduct=3D0xe=
019=0D
[    1.668839] usb_match_id: id=3Dc1db0090 idVendor=3D0x13d3 idProduct=3D0x=
3304=0D
[    1.668840] usb_match_id: id=3Dc1db00a8 idVendor=3D0x930 idProduct=3D0x2=
15=0D
[    1.668840] usb_match_id: id=3Dc1db00c0 idVendor=3D0x489 idProduct=3D0xe=
03d=0D
[    1.668841] usb_match_id: id=3Dc1db00d8 idVendor=3D0x3f0 idProduct=3D0x3=
11d=0D
[    1.668842] usb_match_id: id=3Dc1db00f0 idVendor=3D0xcf3 idProduct=3D0x3=
004=0D
[    1.668843] usb_match_id: id=3Dc1db0108 idVendor=3D0xcf3 idProduct=3D0x3=
11d=0D
[    1.668843] usb_match_id: id=3Dc1db0120 idVendor=3D0x13d3 idProduct=3D0x=
3375=0D
[    1.668844] usb_match_id: id=3Dc1db0138 idVendor=3D0x4ca idProduct=3D0x3=
005=0D
[    1.668845] usb_match_id: id=3Dc1db0150 idVendor=3D0x13d3 idProduct=3D0x=
3362=0D
[    1.668848] usb_match_id: id=3Dc1db0168 idVendor=3D0xcf3 idProduct=3D0xe=
004=0D
[    1.668849] usb_match_id: id=3Dc1db0180 idVendor=3D0x930 idProduct=3D0x2=
19=0D
[    1.668850] usb_match_id: id=3Dc1db0198 idVendor=3D0x489 idProduct=3D0xe=
02c=0D
[    1.668850] usb_match_id: id=3Dc1db01b0 idVendor=3D0x489 idProduct=3D0xe=
03c=0D
[    1.668851] usb_device_match: device 1-1:1.1, driver vub300 =0D
[    1.668852] usb_match_id: id=3Dc1db6b04 idVendor=3D0x2201 idProduct=3D0x=
12c=0D
[    1.668853] usb_match_id: id=3Dc1db6b1c idVendor=3D0x424 idProduct=3D0x1=
2c=0D
[    1.668854] usb_device_match: device 1-1:1.1, driver ushc =0D
[    1.668854] usb_match_id: id=3Dc1db72a4 idVendor=3D0xa12 idProduct=3D0x5=
d10=0D
[    1.668855] usb_device_match: device 1-1:1.1, driver usbmouse =0D
[    1.668856] usb_match_id: id=3Dc1dc0aa8 idVendor=3D0x0 idProduct=3D0x0=0D
[    2.563388] usb_match_id: id=3Dc1e179d4 idVendor=3D0x582 idProduct=3D0x1=
4=0D
[    2.564080] usb_match_id: id=3Dc1e179ec idVendor=3D0x582 idProduct=3D0x1=
6=0D
[    2.564837] usb_match_id: id=3Dc1e17a04 idVendor=3D0x582 idProduct=3D0x1=
b=0D
[    2.565568] usb_match_id: id=3Dc1e17a1c idVendor=3D0x582 idProduct=3D0x1=
d=0D
[    2.566290] usb_match_id: id=3Dc1e17a34 idVendor=3D0x582 idProduct=3D0x2=
3=0D
[    2.566979] usb_match_id: id=3Dc1e17a4c idVendor=3D0x582 idProduct=3D0x2=
5=0D
[    2.567745] usb_match_id: id=3Dc1e17a64 idVendor=3D0x582 idProduct=3D0x2=
7=0D
[    2.568467] usb_match_id: id=3Dc1e17a7c idVendor=3D0x582 idProduct=3D0x2=
9=0D
[    2.569159] usb_match_id: id=3Dc1e17a94 idVendor=3D0x582 idProduct=3D0x2=
b=0D
[    2.569876] usb_match_id: id=3Dc1e17aac idVendor=3D0x582 idProduct=3D0x2=
d=0D
[    2.570603] usb_match_id: id=3Dc1e17ac4 idVendor=3D0x582 idProduct=3D0x2=
f=0D
[    2.571346] usb_match_id: id=3Dc1e17adc idVendor=3D0x582 idProduct=3D0x3=
3=0D
[    2.572066] usb_match_id: id=3Dc1e17af4 idVendor=3D0x582 idProduct=3D0x3=
7=0D
[    2.572763] usb_match_id: id=3Dc1e17b0c idVendor=3D0x582 idProduct=3D0x3=
b=0D
[    2.573498] usb_match_id: id=3Dc1e17b24 idVendor=3D0x582 idProduct=3D0x4=
0=0D
[    2.574204] usb_match_id: id=3Dc1e17b3c idVendor=3D0x582 idProduct=3D0x4=
2=0D
[    2.574949] usb_match_id: id=3Dc1e17b54 idVendor=3D0x582 idProduct=3D0x4=
7=0D
[    2.575699] usb_match_id: id=3Dc1e17b6c idVendor=3D0x582 idProduct=3D0x4=
8=0D
[    2.576456] usb_match_id: id=3Dc1e17b84 idVendor=3D0x582 idProduct=3D0x4=
c=0D
[    2.577170] usb_match_id: id=3Dc1e17b9c idVendor=3D0x582 idProduct=3D0x4=
d=0D
[    2.577908] usb_match_id: id=3Dc1e17bb4 idVendor=3D0x582 idProduct=3D0x5=
0=0D
[    2.578656] usb_match_id: id=3Dc1e17bcc idVendor=3D0x582 idProduct=3D0x5=
2=0D
[    2.579380] usb_match_id: id=3Dc1e17be4 idVendor=3D0x582 idProduct=3D0x6=
0=0D
[    2.580074] usb_match_id: id=3Dc1e17bfc idVendor=3D0x582 idProduct=3D0x6=
4=0D
[    2.580776] usb_match_id: id=3Dc1e17c14 idVendor=3D0x582 idProduct=3D0x6=
5=0D
[    2.581550] usb_match_id: id=3Dc1e17c2c idVendor=3D0x582 idProduct=3D0x6=
a=0D
[    2.582267] usb_match_id: id=3Dc1e17c44 idVendor=3D0x582 idProduct=3D0x6=
d=0D
[    2.582961] usb_match_id: id=3Dc1e17c5c idVendor=3D0x582 idProduct=3D0x7=
4=0D
[    2.583683] usb_match_id: id=3Dc1e17c74 idVendor=3D0x582 idProduct=3D0x7=
5=0D
[    2.584447] usb_match_id: id=3Dc1e17c8c idVendor=3D0x582 idProduct=3D0x7=
a=0D
[    2.585143] usb_match_id: id=3Dc1e17ca4 idVendor=3D0x582 idProduct=3D0x8=
0=0D
[    2.585843] usb_match_id: id=3Dc1e17cbc idVendor=3D0x582 idProduct=3D0x8=
b=0D
[    2.586575] usb_match_id: id=3Dc1e17cd4 idVendor=3D0x582 idProduct=3D0x9=
6=0D
[    2.587282] usb_match_id: id=3Dc1e17cec idVendor=3D0x582 idProduct=3D0x9=
a=0D
[    2.588044] usb_match_id: id=3Dc1e17d04 idVendor=3D0x582 idProduct=3D0xa=
3=0D
[    2.588773] usb_match_id: id=3Dc1e17d1c idVendor=3D0x582 idProduct=3D0xa=
6=0D
[    2.589521] usb_match_id: id=3Dc1e17d34 idVendor=3D0x582 idProduct=3D0xa=
d=0D
[    2.590237] usb_match_id: id=3Dc1e17d4c idVendor=3D0x582 idProduct=3D0xc=
2=0D
[    2.590979] usb_match_id: id=3Dc1e17d64 idVendor=3D0x582 idProduct=3D0xc=
4=0D
[    2.591735] usb_match_id: id=3Dc1e17d7c idVendor=3D0x582 idProduct=3D0xd=
a=0D
[    2.592477] usb_match_id: id=3Dc1e17d94 idVendor=3D0x582 idProduct=3D0xe=
6=0D
[    2.593178] usb_match_id: id=3Dc1e17dac idVendor=3D0x582 idProduct=3D0xe=
9=0D
[    2.593889] usb_match_id: id=3Dc1e17dc4 idVendor=3D0x582 idProduct=3D0x1=
04=0D
[    2.594666] usb_match_id: id=3Dc1e17ddc idVendor=3D0x582 idProduct=3D0x1=
08=0D
[    2.595405] usb_match_id: id=3Dc1e17df4 idVendor=3D0x582 idProduct=3D0x1=
09=0D
[    2.596110] usb_match_id: id=3Dc1e17e0c idVendor=3D0x582 idProduct=3D0x1=
0f=0D
[    2.596843] usb_match_id: id=3Dc1e17e24 idVendor=3D0x582 idProduct=3D0x1=
11=0D
[    2.597620] usb_match_id: id=3Dc1e17e3c idVendor=3D0x582 idProduct=3D0x1=
13=0D
[    2.598335] usb_match_id: id=3Dc1e17e54 idVendor=3D0x582 idProduct=3D0x1=
27=0D
[    2.599068] usb_match_id: id=3Dc1e17e6c idVendor=3D0x582 idProduct=3D0x1=
2a=0D
[    2.599783] usb_match_id: id=3Dc1e17e84 idVendor=3D0x582 idProduct=3D0x1=
1e=0D
[    2.600523] usb_match_id: id=3Dc1e17e9c idVendor=3D0x582 idProduct=3D0x1=
30=0D
[    2.601235] usb_match_id: id=3Dc1e17eb4 idVendor=3D0x582 idProduct=3D0x1=
4d=0D
[    2.601942] usb_match_id: id=3Dc1e17ecc idVendor=3D0x6f8 idProduct=3D0xb=
000=0D
[    2.602698] usb_match_id: id=3Dc1e17ee4 idVendor=3D0x763 idProduct=3D0x1=
002=0D
[    2.603456] usb_match_id: id=3Dc1e17efc idVendor=3D0x763 idProduct=3D0x1=
011=0D
[    2.604170] usb_match_id: id=3Dc1e17f14 idVendor=3D0x763 idProduct=3D0x1=
015=0D
[    2.604903] usb_match_id: id=3Dc1e17f2c idVendor=3D0x763 idProduct=3D0x1=
021=0D
[    2.605667] usb_match_id: id=3Dc1e17f44 idVendor=3D0x763 idProduct=3D0x1=
031=0D
[    2.606438] usb_match_id: id=3Dc1e17f5c idVendor=3D0x763 idProduct=3D0x1=
033=0D
[    2.607170] usb_match_id: id=3Dc1e17f74 idVendor=3D0x763 idProduct=3D0x1=
041=0D
[    2.607907] usb_match_id: id=3Dc1e17f8c idVendor=3D0x763 idProduct=3D0x2=
001=0D
[    2.608676] usb_match_id: id=3Dc1e17fa4 idVendor=3D0x763 idProduct=3D0x2=
003=0D
[    2.609441] usb_match_id: id=3Dc1e17fbc idVendor=3D0x763 idProduct=3D0x2=
008=0D
[    2.610175] usb_match_id: id=3Dc1e17fd4 idVendor=3D0x763 idProduct=3D0x2=
00d=0D
[    2.610900] usb_match_id: id=3Dc1e17fec idVendor=3D0x763 idProduct=3D0x2=
019=0D
[    2.611661] usb_match_id: id=3Dc1e18004 idVendor=3D0x763 idProduct=3D0x2=
080=0D
[    2.612417] usb_match_id: id=3Dc1e1801c idVendor=3D0x763 idProduct=3D0x2=
081=0D
[    2.613140] usb_match_id: id=3Dc1e18034 idVendor=3D0x7cf idProduct=3D0x6=
801=0D
[    2.613864] usb_match_id: id=3Dc1e1804c idVendor=3D0x7cf idProduct=3D0x6=
802=0D
[    2.614612] usb_match_id: id=3Dc1e18064 idVendor=3D0x7fd idProduct=3D0x1=
=0D
[    2.615312] usb_match_id: id=3Dc1e1807c idVendor=3D0x86a idProduct=3D0x1=
=0D
[    2.615988] usb_match_id: id=3Dc1e18094 idVendor=3D0x86a idProduct=3D0x2=
=0D
[    2.616703] usb_match_id: id=3Dc1e180ac idVendor=3D0x86a idProduct=3D0x3=
=0D
[    2.617420] usb_match_id: id=3Dc1e180c4 idVendor=3D0x944 idProduct=3D0x2=
00=0D
[    2.618127] usb_match_id: id=3Dc1e180dc idVendor=3D0x944 idProduct=3D0x2=
01=0D
[    2.618825] usb_match_id: id=3Dc1e180f4 idVendor=3D0x9e8 idProduct=3D0x6=
2=0D
[    2.619547] usb_match_id: id=3Dc1e1810c idVendor=3D0xccd idProduct=3D0x1=
2=0D
[    2.620257] usb_match_id: id=3Dc1e18124 idVendor=3D0xccd idProduct=3D0x1=
3=0D
[    2.620945] usb_match_id: id=3Dc1e1813c idVendor=3D0xccd idProduct=3D0x1=
4=0D
[    2.621673] usb_match_id: id=3Dc1e18154 idVendor=3D0xccd idProduct=3D0x2=
8=0D
[    2.622412] usb_match_id: id=3Dc1e1816c idVendor=3D0xccd idProduct=3D0x3=
5=0D
[    2.623141] usb_match_id: id=3Dc1e18184 idVendor=3D0x103d idProduct=3D0x=
100=0D
[    2.623848] usb_match_id: id=3Dc1e1819c idVendor=3D0x103d idProduct=3D0x=
101=0D
[    2.624566] usb_match_id: id=3Dc1e181b4 idVendor=3D0x1235 idProduct=3D0x=
1=0D
[    2.625244] usb_match_id: id=3Dc1e181cc idVendor=3D0x1235 idProduct=3D0x=
2=0D
[    2.625926] usb_match_id: id=3Dc1e181e4 idVendor=3D0x1235 idProduct=3D0x=
e=0D
[    2.626627] usb_match_id: id=3Dc1e181fc idVendor=3D0x1235 idProduct=3D0x=
4661=0D
[    2.627336] usb_match_id: id=3Dc1e18214 idVendor=3D0x133e idProduct=3D0x=
815=0D
[    2.628042] usb_match_id: id=3Dc1e1822c idVendor=3D0x13e5 idProduct=3D0x=
1=0D
[    2.628727] usb_match_id: id=3Dc1e18244 idVendor=3D0x17cc idProduct=3D0x=
1000=0D
[    2.629458] usb_match_id: id=3Dc1e1825c idVendor=3D0x17cc idProduct=3D0x=
1010=0D
[    2.630160] usb_match_id: id=3Dc1e18274 idVendor=3D0x17cc idProduct=3D0x=
1020=0D
[    2.630882] usb_match_id: id=3Dc1e1828c idVendor=3D0x1f38 idProduct=3D0x=
1=0D
[    2.631580] usb_match_id: id=3Dc1e182a4 idVendor=3D0x4752 idProduct=3D0x=
11=0D
[    2.632272] usb_match_id: id=3Dc1e182bc idVendor=3D0x7104 idProduct=3D0x=
2202=0D
[    2.632985] usb_match_id: id=3Dc1e182d4 idVendor=3D0x2040 idProduct=3D0x=
7200=0D
[    2.633710] usb_match_id: id=3Dc1e182ec idVendor=3D0x2040 idProduct=3D0x=
7240=0D
[    2.634436] usb_match_id: id=3Dc1e18304 idVendor=3D0x2040 idProduct=3D0x=
7210=0D
[    2.635134] usb_match_id: id=3Dc1e1831c idVendor=3D0x2040 idProduct=3D0x=
7217=0D
[    2.635850] usb_match_id: id=3Dc1e18334 idVendor=3D0x2040 idProduct=3D0x=
721b=0D
[    2.636583] usb_match_id: id=3Dc1e1834c idVendor=3D0x2040 idProduct=3D0x=
721e=0D
[    2.637295] usb_match_id: id=3Dc1e18364 idVendor=3D0x2040 idProduct=3D0x=
721f=0D
[    2.638022] usb_match_id: id=3Dc1e1837c idVendor=3D0x2040 idProduct=3D0x=
7280=0D
[    2.638756] usb_match_id: id=3Dc1e18394 idVendor=3D0xfd9 idProduct=3D0x8=
=0D
[    2.639466] usb_match_id: id=3Dc1e183ac idVendor=3D0xdba idProduct=3D0x1=
000=0D
[    2.640187] usb_match_id: id=3Dc1e183c4 idVendor=3D0x0 idProduct=3D0x0=0D
[    2.640856] usb_match_id: id=3Dc1e183dc idVendor=3D0x0 idProduct=3D0x0=0D
[    2.641540] usb_device_match: device 1-1:1.0, driver snd-usb-audio =0D
[    2.642225] usb_match_id: id=3Dc1e16d8c idVendor=3D0x403 idProduct=3D0xb=
8d8=0D
[    2.642939] usb_match_id: id=3Dc1e16da4 idVendor=3D0x41e idProduct=3D0x3=
048=0D
[    2.643651] usb_match_id: id=3Dc1e16dbc idVendor=3D0x41e idProduct=3D0x3=
010=0D
[    2.644351] usb_match_id: id=3Dc1e16dd4 idVendor=3D0x41e idProduct=3D0x3=
f02=0D
[    2.645062] usb_match_id: id=3Dc1e16dec idVendor=3D0x41e idProduct=3D0x3=
f04=0D
[    2.645778] usb_match_id: id=3Dc1e16e04 idVendor=3D0x41e idProduct=3D0x3=
f0a=0D
[    2.646501] usb_match_id: id=3Dc1e16e1c idVendor=3D0x41e idProduct=3D0x3=
f19=0D
[    2.647194] usb_match_id: id=3Dc1e16e34 idVendor=3D0x46d idProduct=3D0x8=
50=0D
[    2.647893] usb_match_id: id=3Dc1e16e4c idVendor=3D0x46d idProduct=3D0x8=
ae=0D
[    2.648605] usb_match_id: id=3Dc1e16e64 idVendor=3D0x46d idProduct=3D0x8=
c6=0D
[    2.649297] usb_match_id: id=3Dc1e16e7c idVendor=3D0x46d idProduct=3D0x8=
f0=0D
[    2.650017] usb_match_id: id=3Dc1e16e94 idVendor=3D0x46d idProduct=3D0x8=
f5=0D
[    2.650719] usb_match_id: id=3Dc1e16eac idVendor=3D0x46d idProduct=3D0x8=
f6=0D
[    2.651426] usb_match_id: id=3Dc1e16ec4 idVendor=3D0x46d idProduct=3D0x9=
90=0D
[    2.652104] usb_match_id: id=3Dc1e16edc idVendor=3D0x499 idProduct=3D0x1=
000=0D
[    2.652817] usb_match_id: id=3Dc1e16ef4 idVendor=3D0x499 idProduct=3D0x1=
001=0D
[    2.653546] usb_match_id: id=3Dc1e16f0c idVendor=3D0x499 idProduct=3D0x1=
002=0D
[    2.654245] usb_match_id: id=3Dc1e16f24 idVendor=3D0x499 idProduct=3D0x1=
003=0D
[    2.654969] usb_match_id: id=3Dc1e16f3c idVendor=3D0x499 idProduct=3D0x1=
004=0D
[    2.655694] usb_match_id: id=3Dc1e16f54 idVendor=3D0x499 idProduct=3D0x1=
005=0D
[    2.656418] usb_match_id: id=3Dc1e16f6c idVendor=3D0x499 idProduct=3D0x1=
006=0D
[    2.657111] usb_match_id: id=3Dc1e16f84 idVendor=3D0x499 idProduct=3D0x1=
007=0D
[    2.657823] usb_match_id: id=3Dc1e16f9c idVendor=3D0x499 idProduct=3D0x1=
008=0D
[    2.658536] usb_match_id: id=3Dc1e16fb4 idVendor=3D0x499 idProduct=3D0x1=
009=0D
[    2.659238] usb_match_id: id=3Dc1e16fcc idVendor=3D0x499 idProduct=3D0x1=
00a=0D
[    2.659941] usb_match_id: id=3Dc1e16fe4 idVendor=3D0x499 idProduct=3D0x1=
00c=0D
[    2.660669] usb_match_id: id=3Dc1e16ffc idVendor=3D0x499 idProduct=3D0x1=
00d=0D
[    2.661391] usb_match_id: id=3Dc1e17014 idVendor=3D0x499 idProduct=3D0x1=
00e=0D
[    2.662082] usb_match_id: id=3Dc1e1702c idVendor=3D0x499 idProduct=3D0x1=
00f=0D
[    2.662788] usb_match_id: id=3Dc1e17044 idVendor=3D0x499 idProduct=3D0x1=
010=0D
[    2.663517] usb_match_id: id=3Dc1e1705c idVendor=3D0x499 idProduct=3D0x1=
011=0D
[    2.664215] usb_match_id: id=3Dc1e17074 idVendor=3D0x499 idProduct=3D0x1=
012=0D
[    2.664923] usb_match_id: id=3Dc1e1708c idVendor=3D0x499 idProduct=3D0x1=
013=0D
[    2.665640] usb_match_id: id=3Dc1e170a4 idVendor=3D0x499 idProduct=3D0x1=
014=0D
[    2.666339] usb_match_id: id=3Dc1e170bc idVendor=3D0x499 idProduct=3D0x1=
015=0D
[    2.667053] usb_match_id: id=3Dc1e170d4 idVendor=3D0x499 idProduct=3D0x1=
016=0D
[    2.667805] usb_match_id: id=3Dc1e170ec idVendor=3D0x499 idProduct=3D0x1=
017=0D
[    2.668545] usb_match_id: id=3Dc1e17104 idVendor=3D0x499 idProduct=3D0x1=
018=0D
[    2.669239] usb_match_id: id=3Dc1e1711c idVendor=3D0x499 idProduct=3D0x1=
019=0D
[    2.669962] usb_match_id: id=3Dc1e17134 idVendor=3D0x499 idProduct=3D0x1=
01a=0D
[    2.670707] usb_match_id: id=3Dc1e1714c idVendor=3D0x499 idProduct=3D0x1=
01b=0D
[    2.671451] usb_match_id: id=3Dc1e17164 idVendor=3D0x499 idProduct=3D0x1=
01c=0D
[    2.672140] usb_match_id: id=3Dc1e1717c idVendor=3D0x499 idProduct=3D0x1=
01d=0D
[    2.672870] usb_match_id: id=3Dc1e17194 idVendor=3D0x499 idProduct=3D0x1=
01e=0D
[    2.673623] usb_match_id: id=3Dc1e171ac idVendor=3D0x499 idProduct=3D0x1=
01f=0D
[    2.674326] usb_match_id: id=3Dc1e171c4 idVendor=3D0x499 idProduct=3D0x1=
020=0D
[    2.675043] usb_match_id: id=3Dc1e171dc idVendor=3D0x499 idProduct=3D0x1=
021=0D
[    2.675777] usb_match_id: id=3Dc1e171f4 idVendor=3D0x499 idProduct=3D0x1=
022=0D
[    2.676530] usb_match_id: id=3Dc1e1720c idVendor=3D0x499 idProduct=3D0x1=
023=0D
[    2.677233] usb_match_id: id=3Dc1e17224 idVendor=3D0x499 idProduct=3D0x1=
024=0D
[    2.677969] usb_match_id: id=3Dc1e1723c idVendor=3D0x499 idProduct=3D0x1=
025=0D
[    2.678711] usb_match_id: id=3Dc1e17254 idVendor=3D0x499 idProduct=3D0x1=
026=0D
[    2.679445] usb_match_id: id=3Dc1e1726c idVendor=3D0x499 idProduct=3D0x1=
027=0D
[    2.680139] usb_match_id: id=3Dc1e17284 idVendor=3D0x499 idProduct=3D0x1=
028=0D
[    2.680880] usb_match_id: id=3Dc1e1729c idVendor=3D0x499 idProduct=3D0x1=
029=0D
[    2.681624] usb_match_id: id=3Dc1e172b4 idVendor=3D0x499 idProduct=3D0x1=
02a=0D
[    2.682328] usb_match_id: id=3Dc1e172cc idVendor=3D0x499 idProduct=3D0x1=
02b=0D
[    2.683056] usb_match_id: id=3Dc1e172e4 idVendor=3D0x499 idProduct=3D0x1=
02e=0D
[    2.683791] usb_match_id: id=3Dc1e172fc idVendor=3D0x499 idProduct=3D0x1=
030=0D
[    2.684530] usb_match_id: id=3Dc1e17314 idVendor=3D0x499 idProduct=3D0x1=
031=0D
[    2.685228] usb_match_id: id=3Dc1e1732c idVendor=3D0x499 idProduct=3D0x1=
032=0D
[    2.685955] usb_match_id: id=3Dc1e17344 idVendor=3D0x499 idProduct=3D0x1=
033=0D
[    2.686714] usb_match_id: id=3Dc1e1735c idVendor=3D0x499 idProduct=3D0x1=
034=0D
[    2.687471] usb_match_id: id=3Dc1e17374 idVendor=3D0x499 idProduct=3D0x1=
035=0D
[    2.688163] usb_match_id: id=3Dc1e1738c idVendor=3D0x499 idProduct=3D0x1=
036=0D
[    2.688894] usb_match_id: id=3Dc1e173a4 idVendor=3D0x499 idProduct=3D0x1=
037=0D
[    2.689639] usb_match_id: id=3Dc1e173bc idVendor=3D0x499 idProduct=3D0x1=
038=0D
[    2.690339] usb_match_id: id=3Dc1e173d4 idVendor=3D0x499 idProduct=3D0x1=
039=0D
[    2.691075] usb_match_id: id=3Dc1e173ec idVendor=3D0x499 idProduct=3D0x1=
03a=0D
[    2.691812] usb_match_id: id=3Dc1e17404 idVendor=3D0x499 idProduct=3D0x1=
03b=0D
[    2.692556] usb_match_id: id=3Dc1e1741c idVendor=3D0x499 idProduct=3D0x1=
03c=0D
[    2.693263] usb_match_id: id=3Dc1e17434 idVendor=3D0x499 idProduct=3D0x1=
03d=0D
[    2.693993] usb_match_id: id=3Dc1e1744c idVendor=3D0x499 idProduct=3D0x1=
03e=0D
[    2.694762] usb_match_id: id=3Dc1e17464 idVendor=3D0x499 idProduct=3D0x1=
03f=0D
[    2.695504] usb_match_id: id=3Dc1e1747c idVendor=3D0x499 idProduct=3D0x1=
040=0D
[    2.696211] usb_match_id: id=3Dc1e17494 idVendor=3D0x499 idProduct=3D0x1=
041=0D
[    2.696941] usb_match_id: id=3Dc1e174ac idVendor=3D0x499 idProduct=3D0x1=
042=0D
[    2.697675] usb_match_id: id=3Dc1e174c4 idVendor=3D0x499 idProduct=3D0x1=
043=0D
[    2.698421] usb_match_id: id=3Dc1e174dc idVendor=3D0x499 idProduct=3D0x1=
044=0D
[    2.699112] usb_match_id: id=3Dc1e174f4 idVendor=3D0x499 idProduct=3D0x1=
045=0D
[    2.699850] usb_match_id: id=3Dc1e1750c idVendor=3D0x499 idProduct=3D0x1=
04e=0D
[    2.700593] usb_match_id: id=3Dc1e17524 idVendor=3D0x499 idProduct=3D0x1=
04f=0D
[    2.701287] usb_match_id: id=3Dc1e1753c idVendor=3D0x499 idProduct=3D0x1=
050=0D
[    2.702016] usb_match_id: id=3Dc1e17554 idVendor=3D0x499 idProduct=3D0x1=
051=0D
[    2.702769] usb_match_id: id=3Dc1e1756c idVendor=3D0x499 idProduct=3D0x1=
052=0D
[    2.703532] usb_match_id: id=3Dc1e17584 idVendor=3D0x499 idProduct=3D0x1=
053=0D
[    2.704237] usb_match_id: id=3Dc1e1759c idVendor=3D0x499 idProduct=3D0x1=
054=0D
[    2.704957] usb_match_id: id=3Dc1e175b4 idVendor=3D0x499 idProduct=3D0x1=
055=0D
[    2.705710] usb_match_id: id=3Dc1e175cc idVendor=3D0x499 idProduct=3D0x1=
056=0D
[    2.706432] usb_match_id: id=3Dc1e175e4 idVendor=3D0x499 idProduct=3D0x1=
057=0D
[    2.707127] usb_match_id: id=3Dc1e175fc idVendor=3D0x499 idProduct=3D0x1=
058=0D
[    2.707836] usb_match_id: id=3Dc1e17614 idVendor=3D0x499 idProduct=3D0x1=
059=0D
[    2.708567] usb_match_id: id=3Dc1e1762c idVendor=3D0x499 idProduct=3D0x1=
05a=0D
[    2.709271] usb_match_id: id=3Dc1e17644 idVendor=3D0x499 idProduct=3D0x1=
05b=0D
[    2.709985] usb_match_id: id=3Dc1e1765c idVendor=3D0x499 idProduct=3D0x1=
05c=0D
[    2.710718] usb_match_id: id=3Dc1e17674 idVendor=3D0x499 idProduct=3D0x1=
05d=0D
[    2.711434] usb_match_id: id=3Dc1e1768c idVendor=3D0x499 idProduct=3D0x1=
503=0D
[    2.712131] usb_match_id: id=3Dc1e176a4 idVendor=3D0x499 idProduct=3D0x2=
000=0D
[    2.712852] usb_match_id: id=3Dc1e176bc idVendor=3D0x499 idProduct=3D0x2=
001=0D
[    2.713577] usb_match_id: id=3Dc1e176d4 idVendor=3D0x499 idProduct=3D0x2=
002=0D
[    2.714284] usb_match_id: id=3Dc1e176ec idVendor=3D0x499 idProduct=3D0x2=
003=0D
[    2.715011] usb_match_id: id=3Dc1e17704 idVendor=3D0x499 idProduct=3D0x5=
000=0D
[    2.715728] usb_match_id: id=3Dc1e1771c idVendor=3D0x499 idProduct=3D0x5=
001=0D
[    2.716446] usb_match_id: id=3Dc1e17734 idVendor=3D0x499 idProduct=3D0x5=
002=0D
[    2.717149] usb_match_id: id=3Dc1e1774c idVendor=3D0x499 idProduct=3D0x5=
003=0D
[    2.717867] usb_match_id: id=3Dc1e17764 idVendor=3D0x499 idProduct=3D0x5=
004=0D
[    2.718599] usb_match_id: id=3Dc1e1777c idVendor=3D0x499 idProduct=3D0x5=
005=0D
[    2.719299] usb_match_id: id=3Dc1e17794 idVendor=3D0x499 idProduct=3D0x5=
006=0D
[    2.720014] usb_match_id: id=3Dc1e177ac idVendor=3D0x499 idProduct=3D0x5=
007=0D
[    2.720741] usb_match_id: id=3Dc1e177c4 idVendor=3D0x499 idProduct=3D0x5=
008=0D
[    2.721466] usb_match_id: id=3Dc1e177dc idVendor=3D0x499 idProduct=3D0x5=
009=0D
[    2.722168] usb_match_id: id=3Dc1e177f4 idVendor=3D0x499 idProduct=3D0x5=
00a=0D
[    2.722884] usb_match_id: id=3Dc1e1780c idVendor=3D0x499 idProduct=3D0x5=
00b=0D
[    2.723609] usb_match_id: id=3Dc1e17824 idVendor=3D0x499 idProduct=3D0x5=
00c=0D
[    2.724317] usb_match_id: id=3Dc1e1783c idVendor=3D0x499 idProduct=3D0x5=
00d=0D
[    2.725028] usb_match_id: id=3Dc1e17854 idVendor=3D0x499 idProduct=3D0x5=
00e=0D
[    2.725758] usb_match_id: id=3Dc1e1786c idVendor=3D0x499 idProduct=3D0x5=
00f=0D
[    2.726487] usb_match_id: id=3Dc1e17884 idVendor=3D0x499 idProduct=3D0x7=
000=0D
[    2.727187] usb_match_id: id=3Dc1e1789c idVendor=3D0x499 idProduct=3D0x7=
010=0D
[    2.727903] usb_match_id: id=3Dc1e178b4 idVendor=3D0x582 idProduct=3D0x0=
=0D
[    2.728600] usb_match_id: id=3Dc1e178cc idVendor=3D0x582 idProduct=3D0x2=
=0D
[    2.729276] usb_match_id: id=3Dc1e178e4 idVendor=3D0x582 idProduct=3D0x3=
=0D
[    2.729961] usb_match_id: id=3Dc1e178fc idVendor=3D0x582 idProduct=3D0x4=
=0D
[    2.730651] usb_match_id: id=3Dc1e17914 idVendor=3D0x582 idProduct=3D0x5=
=0D
[    2.731327] usb_match_id: id=3Dc1e1792c idVendor=3D0x582 idProduct=3D0x7=
=0D
[    2.731996] usb_match_id: id=3Dc1e17944 idVendor=3D0x582 idProduct=3D0x8=
=0D
[    2.732692] usb_match_id: id=3Dc1e1795c idVendor=3D0x582 idProduct=3D0x9=
=0D
[    2.733396] usb_match_id: id=3Dc1e17974 idVendor=3D0x582 idProduct=3D0xb=
=0D
[    2.734064] usb_match_id: id=3Dc1e1798c idVendor=3D0x582 idProduct=3D0xc=
=0D
[    2.734760] usb_match_id: id=3Dc1e179a4 idVendor=3D0x582 idProduct=3D0x1=
0=0D
[    2.735487] usb_match_id: id=3Dc1e179bc idVendor=3D0x582 idProduct=3D0x1=
2=0D
[    2.736166] usb_match_id: id=3Dc1e179d4 idVendor=3D0x582 idProduct=3D0x1=
4=0D
[    2.736872] usb_match_id: id=3Dc1e179ec idVendor=3D0x582 idProduct=3D0x1=
6=0D
[    2.737584] usb_match_id: id=3Dc1e17a04 idVendor=3D0x582 idProduct=3D0x1=
b=0D
[    2.738262] usb_match_id: id=3Dc1e17a1c idVendor=3D0x582 idProduct=3D0x1=
d=0D
[    2.738944] usb_match_id: id=3Dc1e17a34 idVendor=3D0x582 idProduct=3D0x2=
3=0D
[    2.739642] usb_match_id: id=3Dc1e17a4c idVendor=3D0x582 idProduct=3D0x2=
5=0D
[    2.740327] usb_match_id: id=3Dc1e17a64 idVendor=3D0x582 idProduct=3D0x2=
7=0D
[    2.741011] usb_match_id: id=3Dc1e17a7c idVendor=3D0x582 idProduct=3D0x2=
9=0D
[    2.741713] usb_match_id: id=3Dc1e17a94 idVendor=3D0x582 idProduct=3D0x2=
b=0D
[    2.742416] usb_match_id: id=3Dc1e17aac idVendor=3D0x582 idProduct=3D0x2=
d=0D
[    2.743099] usb_match_id: id=3Dc1e17ac4 idVendor=3D0x582 idProduct=3D0x2=
f=0D
[    2.743799] usb_match_id: id=3Dc1e17adc idVendor=3D0x582 idProduct=3D0x3=
3=0D
[    2.744499] usb_match_id: id=3Dc1e17af4 idVendor=3D0x582 idProduct=3D0x3=
7=0D
[    2.745184] usb_match_id: id=3Dc1e17b0c idVendor=3D0x582 idProduct=3D0x3=
b=0D
[    2.745879] usb_match_id: id=3Dc1e17b24 idVendor=3D0x582 idProduct=3D0x4=
0=0D
[    2.746576] usb_match_id: id=3Dc1e17b3c idVendor=3D0x582 idProduct=3D0x4=
2=0D
[    2.747258] usb_match_id: id=3Dc1e17b54 idVendor=3D0x582 idProduct=3D0x4=
7=0D
[    2.747943] usb_match_id: id=3Dc1e17b6c idVendor=3D0x582 idProduct=3D0x4=
8=0D
[    2.748640] usb_match_id: id=3Dc1e17b84 idVendor=3D0x582 idProduct=3D0x4=
c=0D
[    2.749332] usb_match_id: id=3Dc1e17b9c idVendor=3D0x582 idProduct=3D0x4=
d=0D
[    2.750021] usb_match_id: id=3Dc1e17bb4 idVendor=3D0x582 idProduct=3D0x5=
0=0D
[    2.750724] usb_match_id: id=3Dc1e17bcc idVendor=3D0x582 idProduct=3D0x5=
2=0D
[    2.751449] usb_match_id: id=3Dc1e17be4 idVendor=3D0x582 idProduct=3D0x6=
0=0D
[    2.752122] usb_match_id: id=3Dc1e17bfc idVendor=3D0x582 idProduct=3D0x6=
4=0D
[    2.752826] usb_match_id: id=3Dc1e17c14 idVendor=3D0x582 idProduct=3D0x6=
5=0D
[    2.753535] usb_match_id: id=3Dc1e17c2c idVendor=3D0x582 idProduct=3D0x6=
a=0D
[    2.754222] usb_match_id: id=3Dc1e17c44 idVendor=3D0x582 idProduct=3D0x6=
d=0D
[    2.754903] usb_match_id: id=3Dc1e17c5c idVendor=3D0x582 idProduct=3D0x7=
4=0D
[    2.755603] usb_match_id: id=3Dc1e17c74 idVendor=3D0x582 idProduct=3D0x7=
5=0D
[    2.756286] usb_match_id: id=3Dc1e17c8c idVendor=3D0x582 idProduct=3D0x7=
a=0D
[    2.756971] usb_match_id: id=3Dc1e17ca4 idVendor=3D0x582 idProduct=3D0x8=
0=0D
[    2.757671] usb_match_id: id=3Dc1e17cbc idVendor=3D0x582 idProduct=3D0x8=
b=0D
[    2.758374] usb_match_id: id=3Dc1e17cd4 idVendor=3D0x582 idProduct=3D0x9=
6=0D
[    2.759054] usb_match_id: id=3Dc1e17cec idVendor=3D0x582 idProduct=3D0x9=
a=0D
[    2.759749] usb_match_id: id=3Dc1e17d04 idVendor=3D0x582 idProduct=3D0xa=
3=0D
[    2.760453] usb_match_id: id=3Dc1e17d1c idVendor=3D0x582 idProduct=3D0xa=
6=0D
[    2.761137] usb_match_id: id=3Dc1e17d34 idVendor=3D0x582 idProduct=3D0xa=
d=0D
[    2.761836] usb_match_id: id=3Dc1e17d4c idVendor=3D0x582 idProduct=3D0xc=
2=0D
[    2.762544] usb_match_id: id=3Dc1e17d64 idVendor=3D0x582 idProduct=3D0xc=
4=0D
[    2.763230] usb_match_id: id=3Dc1e17d7c idVendor=3D0x582 idProduct=3D0xd=
a=0D
[    2.763913] usb_match_id: id=3Dc1e17d94 idVendor=3D0x582 idProduct=3D0xe=
6=0D
[    2.764615] usb_match_id: id=3Dc1e17dac idVendor=3D0x582 idProduct=3D0xe=
9=0D
[    2.765301] usb_match_id: id=3Dc1e17dc4 idVendor=3D0x582 idProduct=3D0x1=
04=0D
[    2.766006] usb_match_id: id=3Dc1e17ddc idVendor=3D0x582 idProduct=3D0x1=
08=0D
[    2.766726] usb_match_id: id=3Dc1e17df4 idVendor=3D0x582 idProduct=3D0x1=
09=0D
[    2.767468] usb_match_id: id=3Dc1e17e0c idVendor=3D0x582 idProduct=3D0x1=
0f=0D
[    2.768158] usb_match_id: id=3Dc1e17e24 idVendor=3D0x582 idProduct=3D0x1=
11=0D
[    2.768854] usb_match_id: id=3Dc1e17e3c idVendor=3D0x582 idProduct=3D0x1=
13=0D
[    2.769565] usb_match_id: id=3Dc1e17e54 idVendor=3D0x582 idProduct=3D0x1=
27=0D
[    2.770259] usb_match_id: id=3Dc1e17e6c idVendor=3D0x582 idProduct=3D0x1=
2a=0D
[    2.770958] usb_match_id: id=3Dc1e17e84 idVendor=3D0x582 idProduct=3D0x1=
1e=0D
[    2.771660] usb_match_id: id=3Dc1e17e9c idVendor=3D0x582 idProduct=3D0x1=
30=0D
[    2.772347] usb_match_id: id=3Dc1e17eb4 idVendor=3D0x582 idProduct=3D0x1=
4d=0D
[    2.773053] usb_match_id: id=3Dc1e17ecc idVendor=3D0x6f8 idProduct=3D0xb=
000=0D
[    2.773767] usb_match_id: id=3Dc1e17ee4 idVendor=3D0x763 idProduct=3D0x1=
002=0D
[    2.774483] usb_match_id: id=3Dc1e17efc idVendor=3D0x763 idProduct=3D0x1=
011=0D
[    2.775173] usb_match_id: id=3Dc1e17f14 idVendor=3D0x763 idProduct=3D0x1=
015=0D
[    2.775887] usb_match_id: id=3Dc1e17f2c idVendor=3D0x763 idProduct=3D0x1=
021=0D
[    2.776619] usb_match_id: id=3Dc1e17f44 idVendor=3D0x763 idProduct=3D0x1=
031=0D
[    2.777316] usb_match_id: id=3Dc1e17f5c idVendor=3D0x763 idProduct=3D0x1=
033=0D
[    2.778031] usb_match_id: id=3Dc1e17f74 idVendor=3D0x763 idProduct=3D0x1=
041=0D
[    2.778745] usb_match_id: id=3Dc1e17f8c idVendor=3D0x763 idProduct=3D0x2=
001=0D
[    2.779455] usb_match_id: id=3Dc1e17fa4 idVendor=3D0x763 idProduct=3D0x2=
003=0D
[    2.780144] usb_match_id: id=3Dc1e17fbc idVendor=3D0x763 idProduct=3D0x2=
008=0D
[    2.780851] usb_match_id: id=3Dc1e17fd4 idVendor=3D0x763 idProduct=3D0x2=
00d=0D
[    2.781572] usb_match_id: id=3Dc1e17fec idVendor=3D0x763 idProduct=3D0x2=
019=0D
[    2.782276] usb_match_id: id=3Dc1e18004 idVendor=3D0x763 idProduct=3D0x2=
080=0D
[    2.783004] usb_match_id: id=3Dc1e1801c idVendor=3D0x763 idProduct=3D0x2=
081=0D
[    2.783724] usb_match_id: id=3Dc1e18034 idVendor=3D0x7cf idProduct=3D0x6=
801=0D
[    2.784443] usb_match_id: id=3Dc1e1804c idVendor=3D0x7cf idProduct=3D0x6=
802=0D
[    2.785135] usb_match_id: id=3Dc1e18064 idVendor=3D0x7fd idProduct=3D0x1=
=0D
[    2.785812] usb_match_id: id=3Dc1e1807c idVendor=3D0x86a idProduct=3D0x1=
=0D
[    2.786511] usb_match_id: id=3Dc1e18094 idVendor=3D0x86a idProduct=3D0x2=
=0D
[    2.787175] usb_match_id: id=3Dc1e180ac idVendor=3D0x86a idProduct=3D0x3=
=0D
[    2.787856] usb_match_id: id=3Dc1e180c4 idVendor=3D0x944 idProduct=3D0x2=
00=0D
[    2.788551] usb_match_id: id=3Dc1e180dc idVendor=3D0x944 idProduct=3D0x2=
01=0D
[    2.789243] usb_match_id: id=3Dc1e180f4 idVendor=3D0x9e8 idProduct=3D0x6=
2=0D
[    2.789930] usb_match_id: id=3Dc1e1810c idVendor=3D0xccd idProduct=3D0x1=
2=0D
[    2.790638] usb_match_id: id=3Dc1e18124 idVendor=3D0xccd idProduct=3D0x1=
3=0D
[    2.791323] usb_match_id: id=3Dc1e1813c idVendor=3D0xccd idProduct=3D0x1=
4=0D
[    2.792006] usb_match_id: id=3Dc1e18154 idVendor=3D0xccd idProduct=3D0x2=
8=0D
[    2.792700] usb_match_id: id=3Dc1e1816c idVendor=3D0xccd idProduct=3D0x3=
5=0D
[    2.793400] usb_match_id: id=3Dc1e18184 idVendor=3D0x103d idProduct=3D0x=
100=0D
[    2.794099] usb_match_id: id=3Dc1e1819c idVendor=3D0x103d idProduct=3D0x=
101=0D
[    2.794813] usb_match_id: id=3Dc1e181b4 idVendor=3D0x1235 idProduct=3D0x=
1=0D
[    2.795511] usb_match_id: id=3Dc1e181cc idVendor=3D0x1235 idProduct=3D0x=
2=0D
[    2.796183] usb_match_id: id=3Dc1e181e4 idVendor=3D0x1235 idProduct=3D0x=
e=0D
[    2.796882] usb_match_id: id=3Dc1e181fc idVendor=3D0x1235 idProduct=3D0x=
4661=0D
[    2.797612] usb_match_id: id=3Dc1e18214 idVendor=3D0x133e idProduct=3D0x=
815=0D
[    2.798316] usb_match_id: id=3Dc1e1822c idVendor=3D0x13e5 idProduct=3D0x=
1=0D
[    2.799021] usb_match_id: id=3Dc1e18244 idVendor=3D0x17cc idProduct=3D0x=
1000=0D
[    2.799756] usb_match_id: id=3Dc1e1825c idVendor=3D0x17cc idProduct=3D0x=
1010=0D
[    2.800479] usb_match_id: id=3Dc1e18274 idVendor=3D0x17cc idProduct=3D0x=
1020=0D
[    2.801181] usb_match_id: id=3Dc1e1828c idVendor=3D0x1f38 idProduct=3D0x=
1=0D
[    2.801869] usb_match_id: id=3Dc1e182a4 idVendor=3D0x4752 idProduct=3D0x=
11=0D
[    2.802579] usb_match_id: id=3Dc1e182bc idVendor=3D0x7104 idProduct=3D0x=
2202=0D
[    2.803293] usb_match_id: id=3Dc1e182d4 idVendor=3D0x2040 idProduct=3D0x=
7200=0D
[    2.804005] usb_match_id: id=3Dc1e182ec idVendor=3D0x2040 idProduct=3D0x=
7240=0D
[    2.804735] usb_match_id: id=3Dc1e18304 idVendor=3D0x2040 idProduct=3D0x=
7210=0D
[    2.805476] usb_match_id: id=3Dc1e1831c idVendor=3D0x2040 idProduct=3D0x=
7217=0D
[    2.806173] usb_match_id: id=3Dc1e18334 idVendor=3D0x2040 idProduct=3D0x=
721b=0D
[    2.806891] usb_match_id: id=3Dc1e1834c idVendor=3D0x2040 idProduct=3D0x=
721e=0D
[    2.807611] usb_match_id: id=3Dc1e18364 idVendor=3D0x2040 idProduct=3D0x=
721f=0D
[    2.808320] usb_match_id: id=3Dc1e1837c idVendor=3D0x2040 idProduct=3D0x=
7280=0D
[    2.809029] usb_match_id: id=3Dc1e18394 idVendor=3D0xfd9 idProduct=3D0x8=
=0D
[    2.809713] usb_match_id: id=3Dc1e183ac idVendor=3D0xdba idProduct=3D0x1=
000=0D
[    2.810433] usb_match_id: id=3Dc1e183c4 idVendor=3D0x0 idProduct=3D0x0=0D
[    2.811082] usb_match_id: id=3Dc1e183dc idVendor=3D0x0 idProduct=3D0x0=0D
[    2.811748] usb_device_match: device 1-1:1.1, driver snd-usb-audio =0D
[    2.812450] usb_match_id: id=3Dc1e16d8c idVendor=3D0x403 idProduct=3D0xb=
8d8=0D
[    2.813152] usb_match_id: id=3Dc1e16da4 idVendor=3D0x41e idProduct=3D0x3=
048=0D
[    2.813863] usb_match_id: id=3Dc1e16dbc idVendor=3D0x41e idProduct=3D0x3=
010=0D
[    2.814599] usb_match_id: id=3Dc1e16dd4 idVendor=3D0x41e idProduct=3D0x3=
f02=0D
[    2.815298] usb_match_id: id=3Dc1e16dec idVendor=3D0x41e idProduct=3D0x3=
f04=0D
[    2.816012] usb_match_id: id=3Dc1e16e04 idVendor=3D0x41e idProduct=3D0x3=
f0a=0D
[    2.816728] usb_match_id: id=3Dc1e16e1c idVendor=3D0x41e idProduct=3D0x3=
f19=0D
[    2.817447] usb_match_id: id=3Dc1e16e34 idVendor=3D0x46d idProduct=3D0x8=
50=0D
[    2.818138] usb_match_id: id=3Dc1e16e4c idVendor=3D0x46d idProduct=3D0x8=
ae=0D
[    2.818836] usb_match_id: id=3Dc1e16e64 idVendor=3D0x46d idProduct=3D0x8=
c6=0D
[    2.819551] usb_match_id: id=3Dc1e16e7c idVendor=3D0x46d idProduct=3D0x8=
f0=0D
[    2.820256] usb_match_id: id=3Dc1e16e94 idVendor=3D0x46d idProduct=3D0x8=
f5=0D
[    2.820944] usb_match_id: id=3Dc1e16eac idVendor=3D0x46d idProduct=3D0x8=
f6=0D
[    2.821658] usb_match_id: id=3Dc1e16ec4 idVendor=3D0x46d idProduct=3D0x9=
90=0D
[    2.822353] usb_match_id: id=3Dc1e16edc idVendor=3D0x499 idProduct=3D0x1=
000=0D
[    2.823061] usb_match_id: id=3Dc1e16ef4 idVendor=3D0x499 idProduct=3D0x1=
001=0D
[    2.823769] usb_match_id: id=3Dc1e16f0c idVendor=3D0x499 idProduct=3D0x1=
002=0D
[    2.824486] usb_match_id: id=3Dc1e16f24 idVendor=3D0x499 idProduct=3D0x1=
003=0D
[    2.825178] usb_match_id: id=3Dc1e16f3c idVendor=3D0x499 idProduct=3D0x1=
004=0D
[    2.825885] usb_match_id: id=3Dc1e16f54 idVendor=3D0x499 idProduct=3D0x1=
005=0D
[    2.826613] usb_match_id: id=3Dc1e16f6c idVendor=3D0x499 idProduct=3D0x1=
006=0D
[    2.827316] usb_match_id: id=3Dc1e16f84 idVendor=3D0x499 idProduct=3D0x1=
007=0D
[    2.828021] usb_match_id: id=3Dc1e16f9c idVendor=3D0x499 idProduct=3D0x1=
008=0D
[    2.828730] usb_match_id: id=3Dc1e16fb4 idVendor=3D0x499 idProduct=3D0x1=
009=0D
[    2.829454] usb_match_id: id=3Dc1e16fcc idVendor=3D0x499 idProduct=3D0x1=
00a=0D
[    2.830143] usb_match_id: id=3Dc1e16fe4 idVendor=3D0x499 idProduct=3D0x1=
00c=0D
[    2.830860] usb_match_id: id=3Dc1e16ffc idVendor=3D0x499 idProduct=3D0x1=
00d=0D
[    2.831594] usb_match_id: id=3Dc1e17014 idVendor=3D0x499 idProduct=3D0x1=
00e=0D
[    2.832303] usb_match_id: id=3Dc1e1702c idVendor=3D0x499 idProduct=3D0x1=
00f=0D
[    2.833018] usb_match_id: id=3Dc1e17044 idVendor=3D0x499 idProduct=3D0x1=
010=0D
[    2.833726] usb_match_id: id=3Dc1e1705c idVendor=3D0x499 idProduct=3D0x1=
011=0D
[    2.834440] usb_match_id: id=3Dc1e17074 idVendor=3D0x499 idProduct=3D0x1=
012=0D
[    2.835149] usb_match_id: id=3Dc1e1708c idVendor=3D0x499 idProduct=3D0x1=
013=0D
[    2.835859] usb_match_id: id=3Dc1e170a4 idVendor=3D0x499 idProduct=3D0x1=
014=0D
[    2.836576] usb_match_id: id=3Dc1e170bc idVendor=3D0x499 idProduct=3D0x1=
015=0D
[    2.837272] usb_match_id: id=3Dc1e170d4 idVendor=3D0x499 idProduct=3D0x1=
016=0D
[    2.837973] usb_match_id: id=3Dc1e170ec idVendor=3D0x499 idProduct=3D0x1=
017=0D
[    2.838681] usb_match_id: id=3Dc1e17104 idVendor=3D0x499 idProduct=3D0x1=
018=0D
[    2.839390] usb_match_id: id=3Dc1e1711c idVendor=3D0x499 idProduct=3D0x1=
019=0D
[    2.840085] usb_match_id: id=3Dc1e17134 idVendor=3D0x499 idProduct=3D0x1=
01a=0D
[    2.840794] usb_match_id: id=3Dc1e1714c idVendor=3D0x499 idProduct=3D0x1=
01b=0D
[    2.841511] usb_match_id: id=3Dc1e17164 idVendor=3D0x499 idProduct=3D0x1=
01c=0D
[    2.842213] usb_match_id: id=3Dc1e1717c idVendor=3D0x499 idProduct=3D0x1=
01d=0D
[    2.842913] usb_match_id: id=3Dc1e17194 idVendor=3D0x499 idProduct=3D0x1=
01e=0D
[    2.843631] usb_match_id: id=3Dc1e171ac idVendor=3D0x499 idProduct=3D0x1=
01f=0D
[    2.844330] usb_match_id: id=3Dc1e171c4 idVendor=3D0x499 idProduct=3D0x1=
020=0D
[    2.845040] usb_match_id: id=3Dc1e171dc idVendor=3D0x499 idProduct=3D0x1=
021=0D
[    2.845756] usb_match_id: id=3Dc1e171f4 idVendor=3D0x499 idProduct=3D0x1=
022=0D
[    2.846489] usb_match_id: id=3Dc1e1720c idVendor=3D0x499 idProduct=3D0x1=
023=0D
[    2.847186] usb_match_id: id=3Dc1e17224 idVendor=3D0x499 idProduct=3D0x1=
024=0D
[    2.847891] usb_match_id: id=3Dc1e1723c idVendor=3D0x499 idProduct=3D0x1=
025=0D
[    2.848616] usb_match_id: id=3Dc1e17254 idVendor=3D0x499 idProduct=3D0x1=
026=0D
[    2.849314] usb_match_id: id=3Dc1e1726c idVendor=3D0x499 idProduct=3D0x1=
027=0D
[    2.850027] usb_match_id: id=3Dc1e17284 idVendor=3D0x499 idProduct=3D0x1=
028=0D
[    2.850742] usb_match_id: id=3Dc1e1729c idVendor=3D0x499 idProduct=3D0x1=
029=0D
[    2.851461] usb_match_id: id=3Dc1e172b4 idVendor=3D0x499 idProduct=3D0x1=
02a=0D
[    2.852150] usb_match_id: id=3Dc1e172cc idVendor=3D0x499 idProduct=3D0x1=
02b=0D
[    2.852858] usb_match_id: id=3Dc1e172e4 idVendor=3D0x499 idProduct=3D0x1=
02e=0D
[    2.853599] usb_match_id: id=3Dc1e172fc idVendor=3D0x499 idProduct=3D0x1=
030=0D
[    2.854306] usb_match_id: id=3Dc1e17314 idVendor=3D0x499 idProduct=3D0x1=
031=0D
[    2.855010] usb_match_id: id=3Dc1e1732c idVendor=3D0x499 idProduct=3D0x1=
032=0D
[    2.855726] usb_match_id: id=3Dc1e17344 idVendor=3D0x499 idProduct=3D0x1=
033=0D
[    2.856438] usb_match_id: id=3Dc1e1735c idVendor=3D0x499 idProduct=3D0x1=
034=0D
[    2.857140] usb_match_id: id=3Dc1e17374 idVendor=3D0x499 idProduct=3D0x1=
035=0D
[    2.857850] usb_match_id: id=3Dc1e1738c idVendor=3D0x499 idProduct=3D0x1=
036=0D
[    2.858574] usb_match_id: id=3Dc1e173a4 idVendor=3D0x499 idProduct=3D0x1=
037=0D
[    2.859265] usb_match_id: id=3Dc1e173bc idVendor=3D0x499 idProduct=3D0x1=
038=0D
[    2.859976] usb_match_id: id=3Dc1e173d4 idVendor=3D0x499 idProduct=3D0x1=
039=0D
[    2.860687] usb_match_id: id=3Dc1e173ec idVendor=3D0x499 idProduct=3D0x1=
03a=0D
[    2.861410] usb_match_id: id=3Dc1e17404 idVendor=3D0x499 idProduct=3D0x1=
03b=0D
[    2.862112] usb_match_id: id=3Dc1e1741c idVendor=3D0x499 idProduct=3D0x1=
03c=0D
[    2.862831] usb_match_id: id=3Dc1e17434 idVendor=3D0x499 idProduct=3D0x1=
03d=0D
[    2.863553] usb_match_id: id=3Dc1e1744c idVendor=3D0x499 idProduct=3D0x1=
03e=0D
[    2.864258] usb_match_id: id=3Dc1e17464 idVendor=3D0x499 idProduct=3D0x1=
03f=0D
[    2.864963] usb_match_id: id=3Dc1e1747c idVendor=3D0x499 idProduct=3D0x1=
040=0D
[    2.865693] usb_match_id: id=3Dc1e17494 idVendor=3D0x499 idProduct=3D0x1=
041=0D
[    2.866420] usb_match_id: id=3Dc1e174ac idVendor=3D0x499 idProduct=3D0x1=
042=0D
[    2.867119] usb_match_id: id=3Dc1e174c4 idVendor=3D0x499 idProduct=3D0x1=
043=0D
[    2.867830] usb_match_id: id=3Dc1e174dc idVendor=3D0x499 idProduct=3D0x1=
044=0D
[    2.868560] usb_match_id: id=3Dc1e174f4 idVendor=3D0x499 idProduct=3D0x1=
045=0D
[    2.869258] usb_match_id: id=3Dc1e1750c idVendor=3D0x499 idProduct=3D0x1=
04e=0D
[    2.869974] usb_match_id: id=3Dc1e17524 idVendor=3D0x499 idProduct=3D0x1=
04f=0D
[    2.870700] usb_match_id: id=3Dc1e1753c idVendor=3D0x499 idProduct=3D0x1=
050=0D
[    2.871428] usb_match_id: id=3Dc1e17554 idVendor=3D0x499 idProduct=3D0x1=
051=0D
[    2.872112] usb_match_id: id=3Dc1e1756c idVendor=3D0x499 idProduct=3D0x1=
052=0D
[    2.872828] usb_match_id: id=3Dc1e17584 idVendor=3D0x499 idProduct=3D0x1=
053=0D
[    2.873557] usb_match_id: id=3Dc1e1759c idVendor=3D0x499 idProduct=3D0x1=
054=0D
[    2.874270] usb_match_id: id=3Dc1e175b4 idVendor=3D0x499 idProduct=3D0x1=
055=0D
[    2.874974] usb_match_id: id=3Dc1e175cc idVendor=3D0x499 idProduct=3D0x1=
056=0D
[    2.875699] usb_match_id: id=3Dc1e175e4 idVendor=3D0x499 idProduct=3D0x1=
057=0D
[    2.876426] usb_match_id: id=3Dc1e175fc idVendor=3D0x499 idProduct=3D0x1=
058=0D
[    2.877122] usb_match_id: id=3Dc1e17614 idVendor=3D0x499 idProduct=3D0x1=
059=0D
[    2.877830] usb_match_id: id=3Dc1e1762c idVendor=3D0x499 idProduct=3D0x1=
05a=0D
[    2.878565] usb_match_id: id=3Dc1e17644 idVendor=3D0x499 idProduct=3D0x1=
05b=0D
[    2.879272] usb_match_id: id=3Dc1e1765c idVendor=3D0x499 idProduct=3D0x1=
05c=0D
[    2.879979] usb_match_id: id=3Dc1e17674 idVendor=3D0x499 idProduct=3D0x1=
05d=0D
[    2.880701] usb_match_id: id=3Dc1e1768c idVendor=3D0x499 idProduct=3D0x1=
503=0D
[    2.881423] usb_match_id: id=3Dc1e176a4 idVendor=3D0x499 idProduct=3D0x2=
000=0D
[    2.882123] usb_match_id: id=3Dc1e176bc idVendor=3D0x499 idProduct=3D0x2=
001=0D
[    2.882832] usb_match_id: id=3Dc1e176d4 idVendor=3D0x499 idProduct=3D0x2=
002=0D
[    2.883548] usb_match_id: id=3Dc1e176ec idVendor=3D0x499 idProduct=3D0x2=
003=0D
[    2.884259] usb_match_id: id=3Dc1e17704 idVendor=3D0x499 idProduct=3D0x5=
000=0D
[    2.884965] usb_match_id: id=3Dc1e1771c idVendor=3D0x499 idProduct=3D0x5=
001=0D
[    2.885685] usb_match_id: id=3Dc1e17734 idVendor=3D0x499 idProduct=3D0x5=
002=0D
[    2.886411] usb_match_id: id=3Dc1e1774c idVendor=3D0x499 idProduct=3D0x5=
003=0D
[    2.887097] usb_match_id: id=3Dc1e17764 idVendor=3D0x499 idProduct=3D0x5=
004=0D
[    2.887801] usb_match_id: id=3Dc1e1777c idVendor=3D0x499 idProduct=3D0x5=
005=0D
[    2.888537] usb_match_id: id=3Dc1e17794 idVendor=3D0x499 idProduct=3D0x5=
006=0D
[    2.889244] usb_match_id: id=3Dc1e177ac idVendor=3D0x499 idProduct=3D0x5=
007=0D
[    2.889949] usb_match_id: id=3Dc1e177c4 idVendor=3D0x499 idProduct=3D0x5=
008=0D
[    2.890665] usb_match_id: id=3Dc1e177dc idVendor=3D0x499 idProduct=3D0x5=
009=0D
[    2.891392] usb_match_id: id=3Dc1e177f4 idVendor=3D0x499 idProduct=3D0x5=
00a=0D
[    2.892088] usb_match_id: id=3Dc1e1780c idVendor=3D0x499 idProduct=3D0x5=
00b=0D
[    2.892796] usb_match_id: id=3Dc1e17824 idVendor=3D0x499 idProduct=3D0x5=
00c=0D
[    2.893515] usb_match_id: id=3Dc1e1783c idVendor=3D0x499 idProduct=3D0x5=
00d=0D
[    2.894222] usb_match_id: id=3Dc1e17854 idVendor=3D0x499 idProduct=3D0x5=
00e=0D
[    2.894932] usb_match_id: id=3Dc1e1786c idVendor=3D0x499 idProduct=3D0x5=
00f=0D
[    2.895665] usb_match_id: id=3Dc1e17884 idVendor=3D0x499 idProduct=3D0x7=
000=0D
[    2.896387] usb_match_id: id=3Dc1e1789c idVendor=3D0x499 idProduct=3D0x7=
010=0D
[    2.897082] usb_match_id: id=3Dc1e178b4 idVendor=3D0x582 idProduct=3D0x0=
=0D
[    2.897778] usb_match_id: id=3Dc1e178cc idVendor=3D0x582 idProduct=3D0x2=
=0D
[    2.898480] usb_match_id: id=3Dc1e178e4 idVendor=3D0x582 idProduct=3D0x3=
=0D
[    2.899152] usb_match_id: id=3Dc1e178fc idVendor=3D0x582 idProduct=3D0x4=
=0D
[    2.899833] usb_match_id: id=3Dc1e17914 idVendor=3D0x582 idProduct=3D0x5=
=0D
[    2.900525] usb_match_id: id=3Dc1e1792c idVendor=3D0x582 idProduct=3D0x7=
=0D
[    2.901191] usb_match_id: id=3Dc1e17944 idVendor=3D0x582 idProduct=3D0x8=
=0D
[    2.901874] usb_match_id: id=3Dc1e1795c idVendor=3D0x582 idProduct=3D0x9=
=0D
[    2.902578] usb_match_id: id=3Dc1e17974 idVendor=3D0x582 idProduct=3D0xb=
=0D
[    2.903265] usb_match_id: id=3Dc1e1798c idVendor=3D0x582 idProduct=3D0xc=
=0D
[    2.903935] usb_match_id: id=3Dc1e179a4 idVendor=3D0x582 idProduct=3D0x1=
0=0D
[    2.904646] usb_match_id: id=3Dc1e179bc idVendor=3D0x582 idProduct=3D0x1=
2=0D
[    2.905330] usb_match_id: id=3Dc1e179d4 idVendor=3D0x582 idProduct=3D0x1=
4=0D
[    2.906023] usb_match_id: id=3Dc1e179ec idVendor=3D0x582 idProduct=3D0x1=
6=0D
[    2.906719] usb_match_id: id=3Dc1e17a04 idVendor=3D0x582 idProduct=3D0x1=
b=0D
[    2.907425] usb_match_id: id=3Dc1e17a1c idVendor=3D0x582 idProduct=3D0x1=
d=0D
[    2.908102] usb_match_id: id=3Dc1e17a34 idVendor=3D0x582 idProduct=3D0x2=
3=0D
[    2.908804] usb_match_id: id=3Dc1e17a4c idVendor=3D0x582 idProduct=3D0x2=
5=0D
[    2.909512] usb_match_id: id=3Dc1e17a64 idVendor=3D0x582 idProduct=3D0x2=
7=0D
[    2.910214] usb_match_id: id=3Dc1e17a7c idVendor=3D0x582 idProduct=3D0x2=
9=0D
[    2.910927] usb_match_id: id=3Dc1e17a94 idVendor=3D0x582 idProduct=3D0x2=
b=0D
[    2.911632] usb_match_id: id=3Dc1e17aac idVendor=3D0x582 idProduct=3D0x2=
d=0D
[    2.912310] usb_match_id: id=3Dc1e17ac4 idVendor=3D0x582 idProduct=3D0x2=
f=0D
[    2.913001] usb_match_id: id=3Dc1e17adc idVendor=3D0x582 idProduct=3D0x3=
3=0D
[    2.913695] usb_match_id: id=3Dc1e17af4 idVendor=3D0x582 idProduct=3D0x3=
7=0D
[    2.914395] usb_match_id: id=3Dc1e17b0c idVendor=3D0x582 idProduct=3D0x3=
b=0D
[    2.915067] usb_match_id: id=3Dc1e17b24 idVendor=3D0x582 idProduct=3D0x4=
0=0D
[    2.915760] usb_match_id: id=3Dc1e17b3c idVendor=3D0x582 idProduct=3D0x4=
2=0D
[    2.916467] usb_match_id: id=3Dc1e17b54 idVendor=3D0x582 idProduct=3D0x4=
7=0D
[    2.917146] usb_match_id: id=3Dc1e17b6c idVendor=3D0x582 idProduct=3D0x4=
8=0D
[    2.917843] usb_match_id: id=3Dc1e17b84 idVendor=3D0x582 idProduct=3D0x4=
c=0D
[    2.918543] usb_match_id: id=3Dc1e17b9c idVendor=3D0x582 idProduct=3D0x4=
d=0D
[    2.919227] usb_match_id: id=3Dc1e17bb4 idVendor=3D0x582 idProduct=3D0x5=
0=0D
[    2.919915] usb_match_id: id=3Dc1e17bcc idVendor=3D0x582 idProduct=3D0x5=
2=0D
[    2.920612] usb_match_id: id=3Dc1e17be4 idVendor=3D0x582 idProduct=3D0x6=
0=0D
[    2.921296] usb_match_id: id=3Dc1e17bfc idVendor=3D0x582 idProduct=3D0x6=
4=0D
[    2.921984] usb_match_id: id=3Dc1e17c14 idVendor=3D0x582 idProduct=3D0x6=
5=0D
[    2.922679] usb_match_id: id=3Dc1e17c2c idVendor=3D0x582 idProduct=3D0x6=
a=0D
[    2.923372] usb_match_id: id=3Dc1e17c44 idVendor=3D0x582 idProduct=3D0x6=
d=0D
[    2.924044] usb_match_id: id=3Dc1e17c5c idVendor=3D0x582 idProduct=3D0x7=
4=0D
[    2.924746] usb_match_id: id=3Dc1e17c74 idVendor=3D0x582 idProduct=3D0x7=
5=0D
[    2.925457] usb_match_id: id=3Dc1e17c8c idVendor=3D0x582 idProduct=3D0x7=
a=0D
[    2.926149] usb_match_id: id=3Dc1e17ca4 idVendor=3D0x582 idProduct=3D0x8=
0=0D
[    2.926860] usb_match_id: id=3Dc1e17cbc idVendor=3D0x582 idProduct=3D0x8=
b=0D
[    2.927577] usb_match_id: id=3Dc1e17cd4 idVendor=3D0x582 idProduct=3D0x9=
6=0D
[    2.928259] usb_match_id: id=3Dc1e17cec idVendor=3D0x582 idProduct=3D0x9=
a=0D
[    2.928956] usb_match_id: id=3Dc1e17d04 idVendor=3D0x582 idProduct=3D0xa=
3=0D
[    2.929653] usb_match_id: id=3Dc1e17d1c idVendor=3D0x582 idProduct=3D0xa=
6=0D
[    2.930332] usb_match_id: id=3Dc1e17d34 idVendor=3D0x582 idProduct=3D0xa=
d=0D
[    2.931022] usb_match_id: id=3Dc1e17d4c idVendor=3D0x582 idProduct=3D0xc=
2=0D
[    2.931721] usb_match_id: id=3Dc1e17d64 idVendor=3D0x582 idProduct=3D0xc=
4=0D
[    2.932435] usb_match_id: id=3Dc1e17d7c idVendor=3D0x582 idProduct=3D0xd=
a=0D
[    2.933111] usb_match_id: id=3Dc1e17d94 idVendor=3D0x582 idProduct=3D0xe=
6=0D
[    2.933807] usb_match_id: id=3Dc1e17dac idVendor=3D0x582 idProduct=3D0xe=
9=0D
[    2.934522] usb_match_id: id=3Dc1e17dc4 idVendor=3D0x582 idProduct=3D0x1=
04=0D
[    2.935208] usb_match_id: id=3Dc1e17ddc idVendor=3D0x582 idProduct=3D0x1=
08=0D
[    2.935903] usb_match_id: id=3Dc1e17df4 idVendor=3D0x582 idProduct=3D0x1=
09=0D
[    2.936616] usb_match_id: id=3Dc1e17e0c idVendor=3D0x582 idProduct=3D0x1=
0f=0D
[    2.937302] usb_match_id: id=3Dc1e17e24 idVendor=3D0x582 idProduct=3D0x1=
11=0D
[    2.937998] usb_match_id: id=3Dc1e17e3c idVendor=3D0x582 idProduct=3D0x1=
13=0D
[    2.938703] usb_match_id: id=3Dc1e17e54 idVendor=3D0x582 idProduct=3D0x1=
27=0D
[    2.939409] usb_match_id: id=3Dc1e17e6c idVendor=3D0x582 idProduct=3D0x1=
2a=0D
[    2.940091] usb_match_id: id=3Dc1e17e84 idVendor=3D0x582 idProduct=3D0x1=
1e=0D
[    2.940793] usb_match_id: id=3Dc1e17e9c idVendor=3D0x582 idProduct=3D0x1=
30=0D
[    2.941512] usb_match_id: id=3Dc1e17eb4 idVendor=3D0x582 idProduct=3D0x1=
4d=0D
[    2.942209] usb_match_id: id=3Dc1e17ecc idVendor=3D0x6f8 idProduct=3D0xb=
000=0D
[    2.942933] usb_match_id: id=3Dc1e17ee4 idVendor=3D0x763 idProduct=3D0x1=
002=0D
[    2.943676] usb_match_id: id=3Dc1e17efc idVendor=3D0x763 idProduct=3D0x1=
011=0D
[    2.944401] usb_match_id: id=3Dc1e17f14 idVendor=3D0x763 idProduct=3D0x1=
015=0D
[    2.945097] usb_match_id: id=3Dc1e17f2c idVendor=3D0x763 idProduct=3D0x1=
021=0D
[    2.945807] usb_match_id: id=3Dc1e17f44 idVendor=3D0x763 idProduct=3D0x1=
031=0D
[    2.946521] usb_match_id: id=3Dc1e17f5c idVendor=3D0x763 idProduct=3D0x1=
033=0D
[    2.947220] usb_match_id: id=3Dc1e17f74 idVendor=3D0x763 idProduct=3D0x1=
041=0D
[    2.947930] usb_match_id: id=3Dc1e17f8c idVendor=3D0x763 idProduct=3D0x2=
001=0D
[    2.948646] usb_match_id: id=3Dc1e17fa4 idVendor=3D0x763 idProduct=3D0x2=
003=0D
[    2.949347] usb_match_id: id=3Dc1e17fbc idVendor=3D0x763 idProduct=3D0x2=
008=0D
[    2.950069] usb_match_id: id=3Dc1e17fd4 idVendor=3D0x763 idProduct=3D0x2=
00d=0D
[    2.950777] usb_match_id: id=3Dc1e17fec idVendor=3D0x763 idProduct=3D0x2=
019=0D
[    2.951497] usb_match_id: id=3Dc1e18004 idVendor=3D0x763 idProduct=3D0x2=
080=0D
[    2.952184] usb_match_id: id=3Dc1e1801c idVendor=3D0x763 idProduct=3D0x2=
081=0D
[    2.952901] usb_match_id: id=3Dc1e18034 idVendor=3D0x7cf idProduct=3D0x6=
801=0D
[    2.953618] usb_match_id: id=3Dc1e1804c idVendor=3D0x7cf idProduct=3D0x6=
802=0D
[    2.954323] usb_match_id: id=3Dc1e18064 idVendor=3D0x7fd idProduct=3D0x1=
=0D
[    2.954994] usb_match_id: id=3Dc1e1807c idVendor=3D0x86a idProduct=3D0x1=
=0D
[    2.955691] usb_match_id: id=3Dc1e18094 idVendor=3D0x86a idProduct=3D0x2=
=0D
[    2.956385] usb_match_id: id=3Dc1e180ac idVendor=3D0x86a idProduct=3D0x3=
=0D
[    2.957049] usb_match_id: id=3Dc1e180c4 idVendor=3D0x944 idProduct=3D0x2=
00=0D
[    2.957758] usb_match_id: id=3Dc1e180dc idVendor=3D0x944 idProduct=3D0x2=
01=0D
[    2.958474] usb_match_id: id=3Dc1e180f4 idVendor=3D0x9e8 idProduct=3D0x6=
2=0D
[    2.959166] usb_match_id: id=3Dc1e1810c idVendor=3D0xccd idProduct=3D0x1=
2=0D
[    2.959860] usb_match_id: id=3Dc1e18124 idVendor=3D0xccd idProduct=3D0x1=
3=0D
[    2.960567] usb_match_id: id=3Dc1e1813c idVendor=3D0xccd idProduct=3D0x1=
4=0D
[    2.961253] usb_match_id: id=3Dc1e18154 idVendor=3D0xccd idProduct=3D0x2=
8=0D
[    2.961945] usb_match_id: id=3Dc1e1816c idVendor=3D0xccd idProduct=3D0x3=
5=0D
[    2.962652] usb_match_id: id=3Dc1e18184 idVendor=3D0x103d idProduct=3D0x=
100=0D
[    2.963354] usb_match_id: id=3Dc1e1819c idVendor=3D0x103d idProduct=3D0x=
101=0D
[    2.964060] usb_match_id: id=3Dc1e181b4 idVendor=3D0x1235 idProduct=3D0x=
1=0D
[    2.964758] usb_match_id: id=3Dc1e181cc idVendor=3D0x1235 idProduct=3D0x=
2=0D
[    2.965476] usb_match_id: id=3Dc1e181e4 idVendor=3D0x1235 idProduct=3D0x=
e=0D
[    2.966142] usb_match_id: id=3Dc1e181fc idVendor=3D0x1235 idProduct=3D0x=
4661=0D
[    2.966860] usb_match_id: id=3Dc1e18214 idVendor=3D0x133e idProduct=3D0x=
815=0D
[    2.967576] usb_match_id: id=3Dc1e1822c idVendor=3D0x13e5 idProduct=3D0x=
1=0D
[    2.968261] usb_match_id: id=3Dc1e18244 idVendor=3D0x17cc idProduct=3D0x=
1000=0D
[    2.968970] usb_match_id: id=3Dc1e1825c idVendor=3D0x17cc idProduct=3D0x=
1010=0D
[    2.969696] usb_match_id: id=3Dc1e18274 idVendor=3D0x17cc idProduct=3D0x=
1020=0D
[    2.970464] usb_match_id: id=3Dc1e1828c idVendor=3D0x1f38 idProduct=3D0x=
1=0D
[    2.971142] usb_match_id: id=3Dc1e182a4 idVendor=3D0x4752 idProduct=3D0x=
11=0D
[    2.971851] usb_match_id: id=3Dc1e182bc idVendor=3D0x7104 idProduct=3D0x=
2202=0D
[    2.972650] usb_match_id: id=3Dc1e182d4 idVendor=3D0x2040 idProduct=3D0x=
7200=0D
[    2.973472] usb_match_id: id=3Dc1e182ec idVendor=3D0x2040 idProduct=3D0x=
7240=0D
[    2.974259] usb_match_id: id=3Dc1e18304 idVendor=3D0x2040 idProduct=3D0x=
7210=0D
[    2.975003] usb_match_id: id=3Dc1e1831c idVendor=3D0x2040 idProduct=3D0x=
7217=0D
[    2.975819] usb_match_id: id=3Dc1e18334 idVendor=3D0x2040 idProduct=3D0x=
721b=0D
[    2.976683] usb_match_id: id=3Dc1e1834c idVendor=3D0x2040 idProduct=3D0x=
721e=0D
[    2.977438] usb_match_id: id=3Dc1e18364 idVendor=3D0x2040 idProduct=3D0x=
721f=0D
[    2.978234] usb_match_id: id=3Dc1e1837c idVendor=3D0x2040 idProduct=3D0x=
7280=0D
[    2.978955] usb_match_id: id=3Dc1e18394 idVendor=3D0xfd9 idProduct=3D0x8=
=0D
[    2.979706] usb_match_id: id=3Dc1e183ac idVendor=3D0xdba idProduct=3D0x1=
000=0D
[    2.980473] usb_match_id: id=3Dc1e183c4 idVendor=3D0x0 idProduct=3D0x0=0D
[    2.981138] usb_match_id: id=3Dc1e183dc idVendor=3D0x0 idProduct=3D0x0=0D
[    2.981861] usbcore: registered new interface driver snd-usb-audio=0D
[    2.982636] usb_device_match: device 1-0:1.0, driver snd-ua101 =0D
[    2.983317] usb_match_id: id=3Dc1e1d12c idVendor=3D0x582 idProduct=3D0x4=
4=0D
[    2.984014] usb_match_id: id=3Dc1e1d144 idVendor=3D0x582 idProduct=3D0x7=
d=0D
[    2.984742] usb_match_id: id=3Dc1e1d15c idVendor=3D0x582 idProduct=3D0x8=
d=0D
[    2.985473] usb_device_match: device 1-1:1.0, driver snd-ua101 =0D
[    2.986116] usb_match_id: id=3Dc1e1d12c idVendor=3D0x582 idProduct=3D0x4=
4=0D
[    2.986823] usb_match_id: id=3Dc1e1d144 idVendor=3D0x582 idProduct=3D0x7=
d=0D
[    2.987553] usb_match_id: id=3Dc1e1d15c idVendor=3D0x582 idProduct=3D0x8=
d=0D
[    2.988264] usb_device_match: device 1-1:1.1, driver snd-ua101 =0D
[    2.988929] usb_match_id: id=3Dc1e1d12c idVendor=3D0x582 idProduct=3D0x4=
4=0D
[    2.989663] usb_match_id: id=3Dc1e1d144 idVendor=3D0x582 idProduct=3D0x7=
d=0D
[    2.990402] usb_match_id: id=3Dc1e1d15c idVendor=3D0x582 idProduct=3D0x8=
d=0D
[    2.991105] usbcore: registered new interface driver snd-ua101=0D
[    2.991805] usb_device_match: device 1-0:1.0, driver snd-usb-usx2y =0D
[    2.992556] usb_match_id: id=3Dc1e1d944 idVendor=3D0x1604 idProduct=3D0x=
8001=0D
[    2.993306] usb_match_id: id=3Dc1e1d95c idVendor=3D0x1604 idProduct=3D0x=
8007=0D
[    2.994028] usb_match_id: id=3Dc1e1d974 idVendor=3D0x1604 idProduct=3D0x=
8005=0D
[    2.994801] usb_device_match: device 1-1:1.0, driver snd-usb-usx2y =0D
[    2.995558] usb_match_id: id=3Dc1e1d944 idVendor=3D0x1604 idProduct=3D0x=
8001=0D
[    2.996308] usb_match_id: id=3Dc1e1d95c idVendor=3D0x1604 idProduct=3D0x=
8007=0D
[    2.997040] usb_match_id: id=3Dc1e1d974 idVendor=3D0x1604 idProduct=3D0x=
8005=0D
[    2.997797] usb_device_match: device 1-1:1.1, driver snd-usb-usx2y =0D
[    2.998537] usb_match_id: id=3Dc1e1d944 idVendor=3D0x1604 idProduct=3D0x=
8001=0D
[    2.999280] usb_match_id: id=3Dc1e1d95c idVendor=3D0x1604 idProduct=3D0x=
8007=0D
[    3.000006] usb_match_id: id=3Dc1e1d974 idVendor=3D0x1604 idProduct=3D0x=
8005=0D
[    3.000785] usbcore: registered new interface driver snd-usb-usx2y=0D
[    3.001544] usb_device_match: device 1-0:1.0, driver snd-usb-caiaq =0D
[    3.002277] usb_match_id: id=3Dc1e1e654 idVendor=3D0x17cc idProduct=3D0x=
1969=0D
[    3.003055] usb_match_id: id=3Dc1e1e66c idVendor=3D0x17cc idProduct=3D0x=
1940=0D
[    3.003831] usb_match_id: id=3Dc1e1e684 idVendor=3D0x17cc idProduct=3D0x=
4711=0D
[    3.004624] usb_match_id: id=3Dc1e1e69c idVendor=3D0x17cc idProduct=3D0x=
4712=0D
[    3.005413] usb_match_id: id=3Dc1e1e6b4 idVendor=3D0x17cc idProduct=3D0x=
815=0D
[    3.006113] usb_match_id: id=3Dc1e1e6cc idVendor=3D0x17cc idProduct=3D0x=
1978=0D
[    3.006886] usb_match_id: id=3Dc1e1e6e4 idVendor=3D0x17cc idProduct=3D0x=
1915=0D
[    3.007867] usb_match_id: id=3Dc1e1e6fc idVendor=3D0x17cc idProduct=3D0x=
d8d=0D
[    3.008852] usb_match_id: id=3Dc1e1e714 idVendor=3D0x17cc idProduct=3D0x=
839=0D
[    3.009606] usb_match_id: id=3Dc1e1e72c idVendor=3D0x17cc idProduct=3D0x=
41c=0D
[    3.010315] usb_match_id: id=3Dc1e1e744 idVendor=3D0x17cc idProduct=3D0x=
2305=0D
[    3.011059] usb_match_id: id=3Dc1e1e75c idVendor=3D0x17cc idProduct=3D0x=
baff=0D
[    3.011803] usb_match_id: id=3Dc1e1e774 idVendor=3D0x17cc idProduct=3D0x=
41d=0D
[    3.012542] usb_match_id: id=3Dc1e1e78c idVendor=3D0x17cc idProduct=3D0x=
808=0D
[    3.013255] usb_device_match: device 1-1:1.0, driver snd-usb-caiaq =0D
[    3.013971] usb_match_id: id=3Dc1e1e654 idVendor=3D0x17cc idProduct=3D0x=
1969=0D
[    3.014711] usb_match_id: id=3Dc1e1e66c idVendor=3D0x17cc idProduct=3D0x=
1940=0D
[    3.015466] usb_match_id: id=3Dc1e1e684 idVendor=3D0x17cc idProduct=3D0x=
4711=0D
[    3.016180] usb_match_id: id=3Dc1e1e69c idVendor=3D0x17cc idProduct=3D0x=
4712=0D
[    3.016911] usb_match_id: id=3Dc1e1e6b4 idVendor=3D0x17cc idProduct=3D0x=
815=0D
[    3.017650] usb_match_id: id=3Dc1e1e6cc idVendor=3D0x17cc idProduct=3D0x=
1978=0D
[    3.018384] usb_match_id: id=3Dc1e1e6e4 idVendor=3D0x17cc idProduct=3D0x=
1915=0D
[    3.019098] usb_match_id: id=3Dc1e1e6fc idVendor=3D0x17cc idProduct=3D0x=
d8d=0D
[    3.019817] usb_match_id: id=3Dc1e1e714 idVendor=3D0x17cc idProduct=3D0x=
839=0D
[    3.020544] usb_match_id: id=3Dc1e1e72c idVendor=3D0x17cc idProduct=3D0x=
41c=0D
[    3.021246] usb_match_id: id=3Dc1e1e744 idVendor=3D0x17cc idProduct=3D0x=
2305=0D
[    3.021977] usb_match_id: id=3Dc1e1e75c idVendor=3D0x17cc idProduct=3D0x=
baff=0D
[    3.022742] usb_match_id: id=3Dc1e1e774 idVendor=3D0x17cc idProduct=3D0x=
41d=0D
[    3.023477] usb_match_id: id=3Dc1e1e78c idVendor=3D0x17cc idProduct=3D0x=
808=0D
[    3.024180] usb_device_match: device 1-1:1.1, driver snd-usb-caiaq =0D
[    3.024885] usb_match_id: id=3Dc1e1e654 idVendor=3D0x17cc idProduct=3D0x=
1969=0D
[    3.025641] usb_match_id: id=3Dc1e1e66c idVendor=3D0x17cc idProduct=3D0x=
1940=0D
[    3.026352] usb_match_id: id=3Dc1e1e684 idVendor=3D0x17cc idProduct=3D0x=
4711=0D
[    3.027086] usb_match_id: id=3Dc1e1e69c idVendor=3D0x17cc idProduct=3D0x=
4712=0D
[    3.027810] usb_match_id: id=3Dc1e1e6b4 idVendor=3D0x17cc idProduct=3D0x=
815=0D
[    3.028541] usb_match_id: id=3Dc1e1e6cc idVendor=3D0x17cc idProduct=3D0x=
1978=0D
[    3.029261] usb_match_id: id=3Dc1e1e6e4 idVendor=3D0x17cc idProduct=3D0x=
1915=0D
[    3.029994] usb_match_id: id=3Dc1e1e6fc idVendor=3D0x17cc idProduct=3D0x=
d8d=0D
[    3.030727] usb_match_id: id=3Dc1e1e714 idVendor=3D0x17cc idProduct=3D0x=
839=0D
[    3.031460] usb_match_id: id=3Dc1e1e72c idVendor=3D0x17cc idProduct=3D0x=
41c=0D
[    3.032161] usb_match_id: id=3Dc1e1e744 idVendor=3D0x17cc idProduct=3D0x=
2305=0D
[    3.032883] usb_match_id: id=3Dc1e1e75c idVendor=3D0x17cc idProduct=3D0x=
baff=0D
[    3.033622] usb_match_id: id=3Dc1e1e774 idVendor=3D0x17cc idProduct=3D0x=
41d=0D
[    3.034333] usb_match_id: id=3Dc1e1e78c idVendor=3D0x17cc idProduct=3D0x=
808=0D
[    3.035057] usbcore: registered new interface driver snd-usb-caiaq=0D
[    3.035769] NET: Registered protocol family 26=0D
[    3.036280] netem: version 1.3=0D
[    3.036645] NET: Registered protocol family 17=0D
[    3.041772] NET: Registered protocol family 11=0D
[    3.042300] NET: Registered protocol family 3=0D
[    3.042795] can: controller area network core (rev 20120528 abi 9)=0D
[    3.043525] can: failed to create /proc/net/can . CONFIG_PROC_FS missing=
?=0D
[    3.044267] NET: Registered protocol family 29=0D
[    3.044764] can: broadcast manager protocol (rev 20120528 t)=0D
[    3.045411] can: netlink gateway (rev 20101209)=0D
[    3.045938] IrCOMM protocol (Dag Brattli)=0D
[    3.046912] Bluetooth: RFCOMM TTY layer initialized=0D
[    3.047478] Bluetooth: RFCOMM socket layer initialized=0D
[    3.048043] Bluetooth: RFCOMM ver 1.11=0D
[    3.048472] Bluetooth: BNEP (Ethernet Emulation) ver 1.3=0D
[    3.049049] Bluetooth: BNEP filters: protocol multicast=0D
[    3.049638] Bluetooth: HIDP (Human Interface Emulation) ver 1.2=0D
[    3.050285] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team=0D
[    3.051220] DECnet: Routing cache hash table of 1024 buckets, 8Kbytes=0D
[    3.051942] NET: Registered protocol family 12=0D
[    3.052458] 8021q: 802.1Q VLAN Support v1.8=0D
[    3.052924] lib80211: common routines for IEEE802.11 drivers=0D
[    3.053566] lib80211_crypt: registered algorithm 'NULL'=0D
[    3.054144] lib80211_crypt: registered algorithm 'WEP'=0D
[    3.054722] lib80211_crypt: registered algorithm 'CCMP'=0D
[    3.055296] lib80211_crypt: registered algorithm 'TKIP'=0D
[    3.055890] Key type dns_resolver registered=0D
[    3.056514] batman_adv: B.A.T.M.A.N. advanced 2012.3.0 (compatibility ve=
rsion 14) loaded=0D
[    3.058046] =0D
[    3.058046] printing PIC contents=0D
[    3.058589] ... PIC  IMR: ffff=0D
[    3.058924] ... PIC  IRR: 1113=0D
[    3.059281] ... PIC  ISR: 0000=0D
[    3.059632] ... PIC ELCR: 0c00=0D
[    3.059974] printing local APIC contents on CPU#0/0:=0D
[    3.060279] ... APIC ID:      00000000 (0)=0D
[    3.060279] ... APIC VERSION: 00050014=0D
[    3.060279] ... APIC TASKPRI: 00000000 (00)=0D
[    3.060279] ... APIC PROCPRI: 00000000=0D
[    3.060279] ... APIC LDR: 01000000=0D
[    3.060279] ... APIC DFR: ffffffff=0D
[    3.060279] ... APIC SPIV: 000001ff=0D
[    3.060279] ... APIC ISR field:=0D
[    3.060279] 000000000000000000000000000000000000000000000000000000000000=
0000=0D
[    3.060279] ... APIC TMR field:=0D
[    3.060279] 000000000000000000000000000000000000000000000000000000000000=
0000=0D
[    3.060279] ... APIC IRR field:=0D
[    3.060279] 000000000000000000000000000000000000000000000000000000000000=
8000=0D
[    3.060279] ... APIC ESR: 00000000=0D
[    3.060279] ... APIC ICR: 000008fd=0D
[    3.060279] ... APIC ICR2: 02000000=0D
[    3.060279] ... APIC LVTT: 000200ef=0D
[    3.060279] ... APIC LVTPC: 00010000=0D
[    3.060279] ... APIC LVT0: 00010700=0D
[    3.060279] ... APIC LVT1: 00000400=0D
[    3.060279] ... APIC LVTERR: 000000fe=0D
[    3.060279] ... APIC TMICT: 0000f423=0D
[    3.060279] ... APIC TMCCT: 0000362f=0D
[    3.060279] ... APIC TDCR: 00000003=0D
[    3.060279] =0D
[    3.071786] number of MP IRQ sources: 15.=0D
[    3.072238] number of IO-APIC #2 registers: 24.=0D
[    3.072741] testing the IO APIC.......................=0D
[    3.073316] IO APIC #2......=0D
[    3.073648] .... register #00: 00000000=0D
[    3.074079] .......    : physical APIC id: 00=0D
[    3.074561] .......    : Delivery Type: 0=0D
[    3.074996] .......    : LTS          : 0=0D
[    3.075457] .... register #01: 00170011=0D
[    3.075876] .......     : max redirection entries: 17=0D
[    3.076463] .......     : PRQ implemented: 0=0D
[    3.076929] .......     : IO APIC version: 11=0D
[    3.077438] .... register #02: 00000000=0D
[    3.077852] .......     : arbitration: 00=0D
[    3.078298] .... IRQ redirection table:=0D
[    3.078729]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:=0D
[    3.079332]  00 00  1    0    0   0   0    0    0    00=0D
[    3.079936]  01 03  0    0    0   0   0    1    1    41=0D
[    3.080544]  02 03  0    0    0   0   0    1    1    51=0D
[    3.081138]  03 01  0    0    0   0   0    1    1    61=0D
[    3.081739]  04 01  1    0    0   0   0    1    1    71=0D
[    3.082340]  05 01  1    1    0   0   0    1    1    81=0D
[    3.082941]  06 01  0    0    0   0   0    1    1    91=0D
[    3.083555]  07 01  0    0    0   0   0    1    1    A1=0D
[    3.084145]  08 01  0    0    0   0   0    1    1    B1=0D
[    3.084743]  09 01  0    1    0   0   0    1    1    C1=0D
[    3.085340]  0a 01  1    1    0   0   0    1    1    D1=0D
[    3.085937]  0b 01  1    1    0   0   0    1    1    E1=0D
[    3.086557]  0c 03  0    0    0   0   0    1    1    22=0D
[    3.087149]  0d 01  0    0    0   0   0    1    1    42=0D
[    3.087747]  0e 01  0    0    0   0   0    1    1    52=0D
[    3.088349]  0f 01  0    0    0   0   0    1    1    62=0D
[    3.088943]  10 00  1    0    0   0   0    0    0    00=0D
[    3.089555]  11 00  1    0    0   0   0    0    0    00=0D
[    3.090151]  12 00  1    0    0   0   0    0    0    00=0D
[    3.090757]  13 00  1    0    0   0   0    0    0    00=0D
[    3.091345]  14 00  1    0    0   0   0    0    0    00=0D
[    3.091946]  15 00  1    0    0   0   0    0    0    00=0D
[    3.092556]  16 00  1    0    0   0   0    0    0    00=0D
[    3.093155]  17 00  1    0    0   0   0    0    0    00=0D
[    3.093752] IRQ to pin mappings:=0D
[    3.094121] IRQ0 -> 0:2=0D
[    3.094436] IRQ1 -> 0:1=0D
[    3.094736] IRQ3 -> 0:3=0D
[    3.095042] IRQ4 -> 0:4=0D
[    3.095342] IRQ5 -> 0:5=0D
[    3.095657] IRQ6 -> 0:6=0D
[    3.095957] IRQ7 -> 0:7=0D
[    3.096268] IRQ8 -> 0:8=0D
[    3.096583] IRQ9 -> 0:9=0D
[    3.096883] IRQ10 -> 0:10=0D
[    3.097213] IRQ11 -> 0:11=0D
[    3.097551] IRQ12 -> 0:12=0D
[    3.097869] IRQ13 -> 0:13=0D
[    3.098198] IRQ14 -> 0:14=0D
[    3.098532] IRQ15 -> 0:15=0D
[    3.098849] .................................... done.=0D
[    3.099426] Using IPI Shortcut mode=0D
[    3.099938] registered taskstats version 1=0D
[    3.100725] Key type encrypted registered=0D
[    3.101445] IMA: No TPM chip found, activating TPM-bypass!=0D
[    3.103029] dmaengine: __dma_request_channel: fail ((null))=0D
[    3.104138] rtc_cmos 00:01: setting system clock to 2012-08-17 05:40:41 =
UTC (1345182041)=0D
[ 2201.628491] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found=0D
[ 2201.629184] EDD information not available.=0D
[ 2201.629679] ALSA device list:=0D
[ 2201.630003]   No soundcards found.=0D
[ 2201.630763] debug: unmapping init [mem 0xc1e66000-0xc1fa9fff]=0D
[ 2201.631664] Write protecting the kernel text: 10152k=0D
[ 2201.632266] Write protecting the kernel read-only data: 2220k=0D
/bin/sh: /proc/self/fd/9: No such file or directory=0D
/bin/sh: /proc/self/fd/9: No such file or directory=0D
/bin/sh: /proc/self/fd/9: No such file or directory=0D
plymouth-upstart-bridge: ply-event-loop.c:497: ply_event_loop_new: Assertio=
n `loop->epoll_fd >=3D 0' failed.=0D
/etc/lsb-base-logging.sh: line 5:   124 Aborted                 plymouth --=
ping > /dev/null 2>&1=0D
 * Asking all remaining processes to terminate...       =1B[80G mount: proc=
 has wrong device number or fs type proc not supported=0D
killall5[127]: mount returned non-zero exit status=0D=0D
killall5[127]: /proc not mounted, failed to mount.=0D=0D
/etc/lsb-base-logging.sh: line 5:   129 Aborted                 plymouth --=
ping > /dev/null 2>&1=0D
=0D=1B[74G[ OK ]=0D
mount: proc has wrong device number or fs type proc not supported=0D
killall5[135]: mount returned non-zero exit status=0D=0D
killall5[135]: /proc not mounted, failed to mount.=0D=0D
/etc/lsb-base-logging.sh: line 5:   145 Aborted                 plymouth --=
ping > /dev/null 2>&1=0D
 * All processes ended within 1 seconds....       =1B[80G /etc/lsb-base-log=
ging.sh: line 5:   148 Aborted                 plymouth --ping > /dev/null =
2>&1=0D
=0D=1B[74G[ OK ]=0D
/etc/rc6.d/S40umountfs: line 20: /proc/mounts: No such file or directory=0D
cat: /proc/1/maps: No such file or directory=0D
cat: /proc/1/maps: No such file or directory=0D
cat: /proc/1/maps: No such file or directory=0D
cat: /proc/1/maps: No such file or directory=0D
cat: /proc/1/maps: No such file or directory=0D
cat: /proc/1/maps: No such file or directory=0D
umount: /var/run: not mounted=0D
umount: /var/lock: not mounted=0D
umount: /dev/shm: not mounted=0D
 * Will now restart=0D
[ 2266.899225] Unregister pv shared memory for cpu 0=0D
[ 2266.900124] Unregister pv shared memory for cpu 1=0D
[ 2266.902987] Restarting system.=0D
[ 2266.903539] reboot: machine restart=0D

--liOOAslEiF7prFVr--
