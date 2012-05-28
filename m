Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab2E1OE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 10:04:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899Ab2E1OEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 10:04:55 -0400
Date: Mon, 28 May 2012 16:04:50 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Kamil Grzebien <ciptok@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Initializing iwl3945 error
Message-ID: <20120528140448.GA22783@redhat.com>
References: <CANHD2=rF6dBkLLkWAj8uS3nq0B1wCt7Uvu=HzO84UNz2kuiaFg@mail.gmail.com>
 <20120313081235.GC15333@redhat.com>
 <CAErSpo6t-cVBdJfyARi3ifEuBUvopbG5GQSP5YywrvumDK8HFA@mail.gmail.com>
 <CANHD2=qSWRv76mjwhTNMgO=u5yYCh2QZzxbNLNaPWm1d52FtOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANHD2=qSWRv76mjwhTNMgO=u5yYCh2QZzxbNLNaPWm1d52FtOg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 08, 2012 at 12:51:30PM +0100, Kamil Grzebien wrote:
> I've attached logs as you asked for. It was done on kernel 3.3.0-4.fc16.i686.

Below are iomem and dmesg diffs between bad and good (noapic) case. In
dmesg I only see this suspicious difference:

-system 00:0c: [mem 0xfec00000-0xfec0ffff] could not be reserved
+system 00:0c: [mem 0xfec00000-0xfec0ffff] has been reserved

but this is for "pnp 00:0c" not for iwl3945 which has f1eff000-f1efffff
addresses. So I have no idea why IO memory is not correcly mapped
for iwl3945. Any chance that pci folks could look on that? Here is mail
thread with previous information:
https://lkml.org/lkml/2012/3/11/112

Stanislaw


iomem.diff:
-----------

--- bad/iomem.log	2012-04-08 13:43:00.000000000 +0200
+++ good/iomem_noapic.log	2012-04-08 13:43:00.000000000 +0200
@@ -21,8 +21,8 @@ e0000000-f7ffffff : PCI Bus 0000:00
   f0200000-f03fffff : PCI Bus 0000:0b
   f0400000-f05fffff : PCI Bus 0000:09
   f1b00000-f1bfffff : PCI Bus 0000:03
-    f1bff400-f1bff4ff : 0000:03:09.1
-      f1bff400-f1bff4ff : mmc0
+    f1bff500-f1bff5ff : 0000:03:09.1
+      f1bff500-f1bff5ff : mmc0
     f1bff600-f1bff6ff : 0000:03:09.2
       f1bff600-f1bff6ff : r592
     f1bff700-f1bff7ff : 0000:03:09.3
@@ -32,6 +32,7 @@ e0000000-f7ffffff : PCI Bus 0000:00
   f1c00000-f1dfffff : PCI Bus 0000:0c
   f1e00000-f1efffff : PCI Bus 0000:0b
     f1eff000-f1efffff : 0000:0b:00.0
+      f1eff000-f1efffff : iwl3945
   f1f00000-f1ffffff : PCI Bus 0000:09
     f1ffc000-f1ffffff : 0000:09:00.0
       f1ffc000-f1ffffff : sky2
@@ -49,7 +50,7 @@ f8000000-fbffffff : PCI MMCONFIG 0000 [b
     f8000000-fbffffff : pnp 00:0c
 fc000000-febfffff : PCI Bus 0000:00
 fec00000-fec0ffff : reserved
-  fec00000-fec003ff : IOAPIC 0
+  fec00000-fec0ffff : pnp 00:0c
 fec10000-fecfffff : PCI Bus 0000:00
 fed00000-fed003ff : HPET 0
   fed00000-fed003ff : pnp 00:09

dmesg.diff:
-----------

--- bad/dmesg.log	2012-05-28 15:12:13.559424823 +0200
+++ good/dmesg_noapic.log	2012-05-28 15:12:19.016266833 +0200
@@ -101,17 +101,11 @@ enabled)
 enabled)
 high edge lint[0x1])
 high edge lint[0x1])
-gsi_base[0])
-IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
-ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
-ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
-ACPI: IRQ0 used by override.
-ACPI: IRQ2 used by override.
-ACPI: IRQ9 used by override.
-Using ACPI (MADT) for SMP configuration information
+ACPI: Skipping IOAPIC probe due to 'noapic' option.
+Using ACPI for processor (LAPIC) configuration information
 ACPI: HPET id: 0x8086a201 base: 0xfed00000
 SMP: Allowing 2 CPUs, 0 hotplug CPUs
-nr_irqs_gsi: 40
+nr_irqs_gsi: 16
 PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
 PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
 Allocating PCI resources starting at e0000000 (gap: e0000000:18000000)
@@ -121,7 +115,7 @@ PERCPU: Embedded 13 pages/cpu @f3c00000 
 pcpu-alloc: s31168 r0 d22080 u2097152 alloc=1*4194304
 0 1 
 Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 909828
-Kernel command line: BOOT_IMAGE=/vmlinuz-3.3.0-4.fc16.i686 root=UUID=7417d839-a647-466e-b57d-fc65d20a6342 ro rd.md=0 rd.lvm=0 rd.dm=0 quiet SYSFONT=latarcyrheb-sun16 rhgb rd.luks=0 KEYTABLE=pl2 LANG=en_US.UTF-8
+Kernel command line: BOOT_IMAGE=/vmlinuz-3.3.0-4.fc16.i686 root=UUID=7417d839-a647-466e-b57d-fc65d20a6342 ro rd.md=0 rd.lvm=0 rd.dm=0 quiet SYSFONT=latarcyrheb-sun16 rhgb rd.luks=0 KEYTABLE=pl2 LANG=en_US.UTF-8 noapic
 PID hash table entries: 4096 (order: 2, 16384 bytes)
 Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
 Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
@@ -142,15 +136,15 @@ Checking if this processor honours the W
 SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
 Hierarchical RCU implementation.
 	RCU dyntick-idle grace-period acceleration is enabled.
-NR_IRQS:2304 nr_irqs:512 16
+NR_IRQS:2304 nr_irqs:288 16
 CPU 0 irqstacks, hard=f3008000 soft=f300a000
 Extended CMOS year: 2000
 Console: colour dummy device 80x25
 enabled
 hpet clockevent registered
 Fast TSC calibration using PIT
-Detected 2394.148 MHz processor.
-Calibrating delay loop (skipped), value calculated using timer frequency.. 4788.29 BogoMIPS (lpj=2394148)
+Detected 2393.887 MHz processor.
+Calibrating delay loop (skipped), value calculated using timer frequency.. 4787.77 BogoMIPS (lpj=2393887)
 pid_max: default: 32768 minimum: 301
 Security Framework initialized
 SELinux:  Initializing.
@@ -169,9 +163,9 @@ mce: CPU supports 6 MCE banks
 CPU0: Thermal monitoring enabled (TM2)
 using mwait in idle threads.
 ACPI: Core revision 20120111
+ACPI: setting ELCR to 0200 (from 0ea0)
 ftrace: allocating 21899 entries in 43 pages
-Enabling APIC mode:  Flat.  Using 1 I/O APICs
-..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
+Enabling APIC mode:  Flat.  Using 0 I/O APICs
 CPU0: Intel(R) Core(TM)2 Duo CPU     T8300  @ 2.40GHz stepping 06
 Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
 ... version:                2
@@ -188,10 +182,10 @@ smpboot cpu 1: start_ip = 9b000
 Initializing CPU#1
 NMI watchdog enabled, takes one hw-pmu counter.
 Brought up 2 CPUs
-Total of 2 processors activated (9576.59 BogoMIPS).
+Total of 2 processors activated (9575.54 BogoMIPS).
 devtmpfs: initialized
 atomic64 test passed for i586+ platform with CX8 and with SSE
-RTC time: 12:29:27, date: 04/08/12
+RTC time: 12:34:58, date: 04/08/12
 NET: Registered protocol family 16
 ACPI: bus type pci registered
 PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
@@ -219,7 +213,7 @@ ACPI: Dynamic OEM Table Load:
 ACPI: SSDT   (null) 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20050624)
 ACPI: Interpreter enabled
 ACPI: (supports S0 S3 S4 S5)
-ACPI: Using IOAPIC for interrupt routing
+ACPI: Using PIC for interrupt routing
 ACPI: No dock devices found.
 PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
 (domain 0000 [bus 00-ff])
@@ -330,13 +324,11 @@ pci 0000:00:1c.4:   bridge window [io  0
 pci 0000:00:1c.4:   bridge window [mem 0xf1c00000-0xf1dfffff]
 pci 0000:00:1c.4:   bridge window [mem 0xf0000000-0xf01fffff 64bit pref]
 type 0 class 0x000c00
-pci 0000:03:09.0: proprietary Ricoh MMC controller disabled (via firewire function)
-pci 0000:03:09.0: MMC cards are now supported by standard SDHCI controller
 pci 0000:03:09.0: reg 10: [mem 0xf1bff800-0xf1bfffff]
 pci 0000:03:09.0: supports D1 D2
 pci 0000:03:09.0: PME# supported from D0 D1 D2 D3hot D3cold
 type 0 class 0x000805
-pci 0000:03:09.1: reg 10: [mem 0xf1bff400-0xf1bff4ff]
+pci 0000:03:09.1: reg 10: [mem 0xf1bff500-0xf1bff5ff]
 pci 0000:03:09.1: supports D1 D2
 pci 0000:03:09.1: PME# supported from D0 D1 D2 D3hot D3cold
 type 0 class 0x000880
@@ -516,7 +508,7 @@ system 00:0c: [mem 0xdfe72000-0xdfefffff
 system 00:0c: [mem 0xdff00000-0xdfffffff] has been reserved
 system 00:0c: [mem 0xffe00000-0xffffffff] has been reserved
 system 00:0c: [mem 0xffa00000-0xffbfffff] has been reserved
-system 00:0c: [mem 0xfec00000-0xfec0ffff] could not be reserved
+system 00:0c: [mem 0xfec00000-0xfec0ffff] has been reserved
 system 00:0c: [mem 0xfee00000-0xfee0ffff] has been reserved
 system 00:0c: [mem 0xfed20000-0xfed8ffff] has been reserved
 system 00:0c: [mem 0xfeda0000-0xfeda3fff] has been reserved
@@ -551,6 +543,10 @@ pci 0000:00:1c.4:   bridge window [mem 0
 pci 0000:00:1c.4:   bridge window [mem 0xf0000000-0xf01fffff 64bit pref]
 pci 0000:00:1e.0: PCI bridge to [bus 03-03]
 pci 0000:00:1e.0:   bridge window [mem 0xf1b00000-0xf1bfffff]
+ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
+PCI: setting IRQ 11 as level-triggered
+ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 7
+PCI: setting IRQ 7 as level-triggered
 pci 0000:00:1e.0: setting latency timer to 64
 pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
 pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
@@ -598,6 +594,11 @@ TCP reno registered
 UDP hash table entries: 512 (order: 2, 16384 bytes)
 UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
 NET: Registered protocol family 1
+ACPI: PCI Interrupt Link [LNKE] enabled at IRQ 11
+ACPI: PCI Interrupt Link [LNKF] enabled at IRQ 10
+PCI: setting IRQ 10 as level-triggered
+ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 9
+PCI: setting IRQ 9 as level-triggered
 pci 0000:01:00.0: Boot video device
 PCI: CLS 64 bytes, default 64
 Unpacking initramfs...
@@ -606,7 +607,7 @@ Simple Boot Flag at 0x79 set to 0x1
 apm: BIOS not found.
 Intel AES-NI instructions are not detected.
 audit: initializing netlink socket (disabled)
-type=2000 audit(1333888166.549:1): initialized
+type=2000 audit(1333888497.540:1): initialized
 highmem bounce pool size: 64 pages
 HugeTLB registered 4 MB page size, pre-allocated 0 pages
 VFS: Disk quotas dquot_6.5.2
@@ -619,10 +620,10 @@ Block layer SCSI generic (bsg) driver ve
 io scheduler noop registered
 io scheduler deadline registered
 io scheduler cfq registered (default)
-pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
-pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
-pcieport 0000:00:1c.1: irq 42 for MSI/MSI-X
-pcieport 0000:00:1c.4: irq 43 for MSI/MSI-X
+pcieport 0000:00:01.0: irq 16 for MSI/MSI-X
+pcieport 0000:00:1c.0: irq 17 for MSI/MSI-X
+pcieport 0000:00:1c.1: irq 18 for MSI/MSI-X
+pcieport 0000:00:1c.4: irq 19 for MSI/MSI-X
 pci_hotplug: PCI Hot Plug PCI Core version: 0.5
 pciehp: PCI Express Hot Plug Controller Driver version: 0.4
 acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
@@ -648,7 +649,7 @@ Monitor-Mwait will be used to enter C-3 
 Marking TSC unstable due to TSC halts in idle
 ACPI: acpi_idle registered with cpuidle
 thermal LNXTHERM:00: registered as thermal_zone0
-ACPI: Thermal Zone [THM] (32 C)
+ACPI: Thermal Zone [THM] (55 C)
 GHES: HEST is not enabled!
 isapnp: Scanning for PnP cards...
 (battery present)
@@ -658,17 +659,18 @@ Non-volatile memory driver v1.3
 Linux agpgart interface v0.103
 loop: module loaded
 ahci 0000:00:1f.2: version 3.0
-ahci 0000:00:1f.2: irq 44 for MSI/MSI-X
+ahci 0000:00:1f.2: irq 20 for MSI/MSI-X
 ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x5 impl SATA mode
 ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc ems 
 ahci 0000:00:1f.2: setting latency timer to 64
 scsi0 : ahci
 scsi1 : ahci
 scsi2 : ahci
-ata1: SATA max UDMA/133 abar m2048@0xf6ffb800 port 0xf6ffb900 irq 44
+ata1: SATA max UDMA/133 abar m2048@0xf6ffb800 port 0xf6ffb900 irq 20
 ata2: DUMMY
-ata3: SATA max UDMA/133 abar m2048@0xf6ffb800 port 0xf6ffba00 irq 44
+ata3: SATA max UDMA/133 abar m2048@0xf6ffb800 port 0xf6ffba00 irq 20
 ata_piix 0000:00:1f.1: version 2.13
+ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
 ata_piix 0000:00:1f.1: setting latency timer to 64
 scsi3 : ata_piix
 scsi4 : ata_piix
@@ -682,7 +684,7 @@ ehci_hcd 0000:00:1a.7: EHCI Host Control
 ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
 ehci_hcd 0000:00:1a.7: debug port 1
 ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
-ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfed1c400
+ehci_hcd 0000:00:1a.7: irq 9, io mem 0xfed1c400
 ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
 usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
 usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
@@ -696,7 +698,7 @@ ehci_hcd 0000:00:1d.7: EHCI Host Control
 ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
 ehci_hcd 0000:00:1d.7: debug port 1
 ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
-ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfed1c000
+ehci_hcd 0000:00:1d.7: irq 11, io mem 0xfed1c000
 ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
 usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
 usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
@@ -710,7 +712,7 @@ uhci_hcd: USB Universal Host Controller 
 uhci_hcd 0000:00:1a.0: setting latency timer to 64
 uhci_hcd 0000:00:1a.0: UHCI Host Controller
 uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
-uhci_hcd 0000:00:1a.0: irq 20, io base 0x00006f20
+uhci_hcd 0000:00:1a.0: irq 11, io base 0x00006f20
 usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
 usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
 usb usb3: Product: UHCI Host Controller
@@ -721,7 +723,7 @@ hub 3-0:1.0: 2 ports detected
 uhci_hcd 0000:00:1a.1: setting latency timer to 64
 uhci_hcd 0000:00:1a.1: UHCI Host Controller
 uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
-uhci_hcd 0000:00:1a.1: irq 21, io base 0x00006f00
+uhci_hcd 0000:00:1a.1: irq 10, io base 0x00006f00
 usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
 usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
 usb usb4: Product: UHCI Host Controller
@@ -732,7 +734,7 @@ hub 4-0:1.0: 2 ports detected
 uhci_hcd 0000:00:1d.0: setting latency timer to 64
 uhci_hcd 0000:00:1d.0: UHCI Host Controller
 uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
-uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006f80
+uhci_hcd 0000:00:1d.0: irq 11, io base 0x00006f80
 usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
 usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
 usb usb5: Product: UHCI Host Controller
@@ -743,7 +745,7 @@ hub 5-0:1.0: 2 ports detected
 uhci_hcd 0000:00:1d.1: setting latency timer to 64
 uhci_hcd 0000:00:1d.1: UHCI Host Controller
 uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
-uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006f60
+uhci_hcd 0000:00:1d.1: irq 10, io base 0x00006f60
 usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
 usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
 usb usb6: Product: UHCI Host Controller
@@ -754,7 +756,7 @@ hub 6-0:1.0: 2 ports detected
 uhci_hcd 0000:00:1d.2: setting latency timer to 64
 uhci_hcd 0000:00:1d.2: UHCI Host Controller
 uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
-uhci_hcd 0000:00:1d.2: irq 22, io base 0x00006f40
+uhci_hcd 0000:00:1d.2: irq 9, io base 0x00006f40
 usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
 usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
 usb usb7: Product: UHCI Host Controller
@@ -790,14 +792,14 @@ Registering the dns_resolver key type
 Using IPI No-Shortcut mode
 PM: Hibernation image not present or could not be loaded.
 registered taskstats version 1
-  Magic number: 8:784:480
-rtc_cmos 00:04: setting system clock to 2012-04-08 12:29:28 UTC (1333888168)
+  Magic number: 8:887:581
+rtc_cmos 00:04: setting system clock to 2012-04-08 12:34:59 UTC (1333888499)
 Initializing network drop monitor service
 input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
 ata4.00: ATAPI: Optiarc DVD+/-RW AD-7640A, JD05, max UDMA/33
 ata4.00: configured for UDMA/33
-ata3: SATA link down (SStatus 0 SControl 300)
 ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
+ata3: SATA link down (SStatus 0 SControl 300)
 ata1.00: ATA-7: ST9200420ASG, 3.ADD, max UDMA/133
 ata1.00: 390721968 sectors, multi 8: LBA48 NCQ (depth 31/32)
 ata1.00: configured for UDMA/133
@@ -813,19 +815,19 @@ sr0: scsi3-mmc drive: 24x/24x writer dvd
 cdrom: Uniform CD-ROM driver Revision: 3.20
 sr 3:0:0:0: Attached scsi CD-ROM sr0
 sr 3:0:0:0: Attached scsi generic sg1 type 5
+usb 1-1: New USB device found, idVendor=05a9, idProduct=2640
+usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
+usb 1-1: Product: Laptop Integrated Webcam
+usb 1-1: Manufacturer: OmniVision Technologies, Inc. -2640-07.07.20.3
  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 >
 sd 0:0:0:0: [sda] Attached SCSI disk
 Freeing unused kernel memory: 620k freed
 Write protecting the kernel text: 5340k
 Write protecting the kernel read-only data: 2096k
-usb 1-1: New USB device found, idVendor=05a9, idProduct=2640
-usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
-usb 1-1: Product: Laptop Integrated Webcam
-usb 1-1: Manufacturer: OmniVision Technologies, Inc. -2640-07.07.20.3
 dracut: dracut-013-20.fc16
 dracut: rd.luks=0: removing cryptoluks activation
 dracut: rd.lvm=0: removing LVM activation
-udevd[111]: starting version 173
+udevd[112]: starting version 173
 wmi: Mapper loaded
 acpi device:31: registered as cooling_device2
 input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:2e/LNXVIDEO:00/input/input4
@@ -859,36 +861,34 @@ usb 2-2: new high-speed USB device numbe
 [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xCB78
 [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xD5C8
 [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xD6BA
-usb 2-2: New USB device found, idVendor=0bb4, idProduct=0c99
-usb 2-2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
-usb 2-2: Product: Android Phone
 [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xD8ED
 [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0xD952
-usb 2-2: Manufacturer: HTC
-usb 2-2: SerialNumber: HT999L903452
 [drm] nouveau 0000:01:00.0: 0xD952: Condition still not met after 20ms, skipping following opcodes
-Initializing USB Mass Storage driver...
-scsi5 : usb-storage 2-2:1.0
 [drm] nouveau 0000:01:00.0: 3 available performance level(s)
 [drm] nouveau 0000:01:00.0: 0: core 169MHz shader 338MHz memory 100MHz timing 0 voltage 1150mV fanspeed 100%
 [drm] nouveau 0000:01:00.0: 1: core 275MHz shader 550MHz memory 301MHz timing 1 voltage 1150mV fanspeed 100%
 [drm] nouveau 0000:01:00.0: 2: core 475MHz shader 950MHz memory 702MHz timing 2 voltage 1200mV fanspeed 100%
 [drm] nouveau 0000:01:00.0: c: core 275MHz shader 550MHz memory 302MHz voltage 1150mV
-usbcore: registered new interface driver usb-storage
-USB Mass Storage support registered.
 [TTM] Zone  kernel: Available graphics memory: 429556 kiB.
 [TTM] Zone highmem: Available graphics memory: 1811164 kiB.
 [TTM] Initializing pool allocator.
 [drm] nouveau 0000:01:00.0: Detected 256MiB VRAM
 mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
 [drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
+usb 2-2: New USB device found, idVendor=0bb4, idProduct=0c99
+usb 2-2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
+usb 2-2: Product: Android Phone
+usb 2-2: Manufacturer: HTC
+usb 2-2: SerialNumber: HT999L903452
+Initializing USB Mass Storage driver...
+scsi5 : usb-storage 2-2:1.0
+usbcore: registered new interface driver usb-storage
+USB Mass Storage support registered.
 [drm] nouveau 0000:01:00.0: DCB encoder 1 unknown
 [drm] nouveau 0000:01:00.0: TV-1 has no encoders, removing
 [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
 [drm] No driver support for vblank timestamp query.
 [drm] nouveau 0000:01:00.0: ACPI backlight interface available, not registering our own
-input: PS/2 Mouse as /devices/platform/i8042/serio1/input/input5
-input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio1/input/input6
 usb 3-2: new full-speed USB device number 2 using uhci_hcd
 usb 3-2: New USB device found, idVendor=0483, idProduct=2016
 usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
@@ -899,13 +899,15 @@ usb 5-1: New USB device found, idVendor=
 usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
 usb 5-1: Product: USB Full Speed
 usb 5-1: Manufacturer: A4Tech
-input: A4Tech USB Full Speed as /devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1:1.0/input/input7
+input: A4Tech USB Full Speed as /devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1:1.0/input/input5
 generic-usb 0003:09DA:8090.0001: input,hidraw0: USB HID v1.11 Mouse [A4Tech USB Full Speed] on usb-0000:00:1d.0-1/input0
-input: A4Tech USB Full Speed as /devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1:1.1/input/input8
+input: A4Tech USB Full Speed as /devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1:1.1/input/input6
 generic-usb 0003:09DA:8090.0002: input,hiddev0,hidraw1: USB HID v1.11 Keyboard [A4Tech USB Full Speed] on usb-0000:00:1d.0-1/input1
 scsi 5:0:0:0: Direct-Access     HTC      Android Phone    0100 PQ: 0 ANSI: 2
 sd 5:0:0:0: Attached scsi generic sg2 type 0
 sd 5:0:0:0: [sdb] Attached SCSI removable disk
+input: PS/2 Mouse as /devices/platform/i8042/serio1/input/input7
+input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio1/input/input8
 usb 6-1: new full-speed USB device number 2 using uhci_hcd
 usb 6-1: New USB device found, idVendor=054c, idProduct=03d5
 usb 6-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
@@ -914,7 +916,7 @@ usb 6-1: Manufacturer: Sony Computer Ent
 input: Sony Computer Entertainment Motion Controller as /devices/pci0000:00/0000:00:1d.1/usb6/6-1/6-1:1.0/input/input9
 generic-usb 0003:054C:03D5.0003: input,hiddev0,hidraw2: USB HID v1.10 Gamepad [Sony Computer Entertainment Motion Controller] on usb-0000:00:1d.1-1/input0
 composite sync not supported
-[drm] nouveau 0000:01:00.0: allocated 1440x900 fb: 0x320000, bo f28cf600
+[drm] nouveau 0000:01:00.0: allocated 1440x900 fb: 0x320000, bo f65ee800
 fbcon: nouveaufb (fb0) is primary device
 Console: switching to colour frame buffer device 180x56
 fb0: nouveaufb frame buffer device
@@ -923,20 +925,20 @@ drm: registered panic notifier
 dracut: Starting plymouth daemon
 usb 7-2: new full-speed USB device number 2 using uhci_hcd
 composite sync not supported
-dracut: rd.dm=0: removing DM RAID activation
 usb 7-2: New USB device found, idVendor=0a5c, idProduct=4500
 usb 7-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
 usb 7-2: Product: BCM2045B2
 usb 7-2: Manufacturer: Broadcom
-dracut: rd.md=0: removing MD RAID activation
 hub 7-2:1.0: USB hub found
 hub 7-2:1.0: 3 ports detected
+dracut: rd.dm=0: removing DM RAID activation
+dracut: rd.md=0: removing MD RAID activation
 sdhci: Secure Digital Host Controller Interface driver
 sdhci: Copyright(c) Pierre Ossman
+firewire_ohci: Added fw-ohci device 0000:03:09.0, OHCI v1.10, 4 IR + 4 IT contexts, quirks 0x11
 (rev 22)
 Registered led device: mmc0::
 using DMA
-firewire_ohci: Added fw-ohci device 0000:03:09.0, OHCI v1.10, 4 IR + 4 IT contexts, quirks 0x11
 usb 7-2.2: new full-speed USB device number 3 using uhci_hcd
 usb 7-2.2: New USB device found, idVendor=0a5c, idProduct=4502
 usb 7-2.2: New USB device strings: Mfr=1, Product=0, SerialNumber=0
@@ -944,21 +946,21 @@ usb 7-2.2: Manufacturer: Broadcom Corp
 input: Broadcom Corp as /devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2.2/7-2.2:1.0/input/input10
 generic-usb 0003:0A5C:4502.0004: input,hidraw3: USB HID v1.11 Keyboard [Broadcom Corp] on usb-0000:00:1d.2-2.2/input0
 usb 7-2.3: new full-speed USB device number 4 using uhci_hcd
-firewire_core: created device fw0: GUID 334fc0001cece070, S400
 usb 7-2.3: New USB device found, idVendor=0a5c, idProduct=4503
 usb 7-2.3: New USB device strings: Mfr=1, Product=0, SerialNumber=0
 usb 7-2.3: Manufacturer: Broadcom Corp
 input: Broadcom Corp as /devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2.3/7-2.3:1.0/input/input11
 generic-usb 0003:0A5C:4503.0005: input,hidraw4: USB HID v1.11 Mouse [Broadcom Corp] on usb-0000:00:1d.2-2.3/input0
+firewire_core: created device fw0: GUID 334fc0001cece070, S400
 EXT4-fs (sda7): mounted filesystem with ordered data mode. Opts: (null)
 dracut: Checking ext4: /dev/disk/by-uuid/7417d839-a647-466e-b57d-fc65d20a6342
 dracut: issuing e2fsck -a  /dev/disk/by-uuid/7417d839-a647-466e-b57d-fc65d20a6342
-dracut: _Fedora-16-i686-: clean, 238747/901120 files, 1776110/3584000 blocks
+dracut: _Fedora-16-i686-: clean, 238750/901120 files, 1775993/3584000 blocks
 dracut: Remounting /dev/disk/by-uuid/7417d839-a647-466e-b57d-fc65d20a6342 with -o ro
 EXT4-fs (sda7): mounted filesystem with ordered data mode. Opts: (null)
 dracut: Mounted root filesystem /dev/sda7
 dracut: Switching root
-type=1404 audit(1333888173.684:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
+type=1404 audit(1333888504.678:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
 SELinux: 2048 avtab hash slots, 97362 rules.
 SELinux: 2048 avtab hash slots, 97362 rules.
 SELinux:  9 users, 13 roles, 3912 types, 215 bools, 1 sens, 1024 cats
@@ -984,13 +986,13 @@ SELinux: initialized (dev sysfs, type sy
 SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
 SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
 SELinux: initialized (dev sda7, type ext4), uses xattr
-type=1403 audit(1333888173.953:3): policy loaded auid=4294967295 ses=4294967295
-systemd[1]: Successfully loaded SELinux policy in 347ms 981us.
-systemd[1]: Successfully loaded SELinux database in 54ms 927us, size on heap is 365K.
+type=1403 audit(1333888504.936:3): policy loaded auid=4294967295 ses=4294967295
+systemd[1]: Successfully loaded SELinux policy in 331ms 344us.
+systemd[1]: Successfully loaded SELinux database in 63ms 586us, size on heap is 365K.
 systemd[1]: RTC configured in localtime, applying delta of 60 minutes to system time.
 SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
 SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
-systemd[1]: Relabelled /dev and /run in 42ms 476us.
+systemd[1]: Relabelled /dev and /run in 42ms 435us.
 SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
 SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
 SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
@@ -1002,11 +1004,11 @@ SELinux: initialized (dev cgroup, type c
 systemd[1]: systemd 37 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +SYSVINIT +LIBCRYPTSETUP; fedora)
 systemd[1]: Set hostname to <xps>.
 SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
-udevd[521]: starting version 173
-udevd[521]: specified group 'plugdev' unknown
-SELinux: initialized (dev configfs, type configfs), uses genfs_contexts
+udevd[524]: starting version 173
+udevd[524]: specified group 'plugdev' unknown
 SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
 SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
+SELinux: initialized (dev configfs, type configfs), uses genfs_contexts
 SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
 EXT4-fs (sda7): re-mounted. Opts: (null)
 RPC: Registered named UNIX socket transport module.
@@ -1017,44 +1019,39 @@ SELinux: initialized (dev rpc_pipefs, ty
 SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
 sky2: driver version 1.30
 sky2 0000:09:00.0: Yukon-2 FE+ chip revision 0
-sky2 0000:09:00.0: irq 45 for MSI/MSI-X
+sky2 0000:09:00.0: irq 21 for MSI/MSI-X
 sky2 0000:09:00.0: eth0: addr 00:21:9b:cd:55:50
 cfg80211: Calling CRDA to update world regulatory domain
 iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, in-tree:ds
 iwl3945: Copyright(c) 2003-2011 Intel Corporation
-iwl3945 0000:0b:00.0: enabling device (0000 -> 0002)
-iwl3945 0000:0b:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
+r592: driver successfully loaded
 iTCO_vendor_support: vendor-support=0
-iwl3945 0000:0b:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
-iwl3945 0000:0b:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
-iwl3945 0000:0b:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
-iwl3945 0000:0b:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
-iwl3945 0000:0b:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
-iwl3945 0000:0b:00.0: bad EEPROM signature,EEPROM_GP=0x00000007
-iwl3945 0000:0b:00.0: EEPROM not found, EEPROM_GP=0xffffffff
-iwl3945 0000:0b:00.0: Unable to init EEPROM
 iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
 iTCO_wdt: Found a ICH8M TCO device (Version=2, TCOBASE=0x1060)
 iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
-iwl3945: probe of 0000:0b:00.0 failed with error -2
+iwl3945 0000:0b:00.0: Tunable channels: 13 802.11bg, 23 802.11a channels
+iwl3945 0000:0b:00.0: Detected Intel Wireless WiFi Link 3945ABG
+iwl3945 0000:0b:00.0: irq 22 for MSI/MSI-X
+Registered led device: phy0-led
+mtp-probe[676]: checking bus 3, device 2: "/sys/devices/pci0000:00/0000:00:1a.0/usb3/3-2"
+mtp-probe[694]: checking bus 2, device 3: "/sys/devices/pci0000:00/0000:00:1d.7/usb2/2-2"
+mtp-probe[692]: checking bus 1, device 2: "/sys/devices/pci0000:00/0000:00:1a.7/usb1/1-1"
 microcode: CPU0 sig=0x10676, pf=0x80, revision=0x60c
-r592: driver successfully loaded
-mtp-probe[674]: checking bus 6, device 2: "/sys/devices/pci0000:00/0000:00:1d.1/usb6/6-1"
+mtp-probe[695]: checking bus 5, device 2: "/sys/devices/pci0000:00/0000:00:1d.0/usb5/5-1"
+mtp-probe[716]: checking bus 6, device 2: "/sys/devices/pci0000:00/0000:00:1d.1/usb6/6-1"
+mtp-probe[694]: bus: 2, device: 3 was not an MTP device
+mtp-probe[692]: bus: 1, device: 2 was not an MTP device
+mtp-probe[716]: bus: 6, device: 2 was not an MTP device
+mtp-probe[676]: bus: 3, device: 2 was not an MTP device
 mtp-probe[724]: checking bus 7, device 3: "/sys/devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2.2"
-mtp-probe[670]: checking bus 5, device 2: "/sys/devices/pci0000:00/0000:00:1d.0/usb5/5-1"
-mtp-probe[691]: checking bus 2, device 3: "/sys/devices/pci0000:00/0000:00:1d.7/usb2/2-2"
-mtp-probe[684]: checking bus 1, device 2: "/sys/devices/pci0000:00/0000:00:1a.7/usb1/1-1"
-mtp-probe[650]: checking bus 3, device 2: "/sys/devices/pci0000:00/0000:00:1a.0/usb3/3-2"
-mtp-probe[730]: checking bus 7, device 4: "/sys/devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2.3"
-mtp-probe[691]: bus: 2, device: 3 was not an MTP device
+mtp-probe[729]: checking bus 7, device 4: "/sys/devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2.3"
+mtp-probe[729]: bus: 7, device: 4 was not an MTP device
+mtp-probe[695]: bus: 5, device: 2 was not an MTP device
 mtp-probe[724]: bus: 7, device: 3 was not an MTP device
-mtp-probe[670]: bus: 5, device: 2 was not an MTP device
-mtp-probe[684]: bus: 1, device: 2 was not an MTP device
-mtp-probe[674]: bus: 6, device: 2 was not an MTP device
-mtp-probe[730]: bus: 7, device: 4 was not an MTP device
-mtp-probe[650]: bus: 3, device: 2 was not an MTP device
-dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
 r852: driver loaded successfully
+dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
+Linux media interface: v0.10
+ieee80211 phy0: Selected rate control algorithm 'iwl-3945-rs'
 cfg80211: World regulatory domain updated:
 cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
 cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
@@ -1062,19 +1059,19 @@ cfg80211:   (2457000 KHz - 2482000 KHz @
 cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
 cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
 cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
+input: Dell WMI hotkeys as /devices/virtual/input/input12
 microcode: CPU0 updated to revision 0x60f, date = 2010-09-29
 microcode: CPU1 sig=0x10676, pf=0x80, revision=0x60c
 microcode: CPU1 updated to revision 0x60f, date = 2010-09-29
 microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
-Linux media interface: v0.10
 Linux video capture interface: v2.00
-input: Dell WMI hotkeys as /devices/virtual/input/input12
-snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
+udevd[583]: renamed network interface eth0 to p2p1
 uvcvideo: Found UVC 1.00 device Laptop Integrated Webcam (05a9:2640)
 uvcvideo: UVC non compliance - GET_DEF(PROBE) not supported. Enabling workaround.
 input: Laptop Integrated Webcam as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1:1.0/input/input13
 usbcore: registered new interface driver uvcvideo
 USB Video Class driver (1.1.1)
+snd_hda_intel 0000:00:1b.0: irq 23 for MSI/MSI-X
 ALSA sound/pci/hda/hda_codec.c:4927 autoconfig: line_outs=1 (0xd/0x0/0x0/0x0/0x0) type:speaker
 ALSA sound/pci/hda/hda_codec.c:4931    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
 ALSA sound/pci/hda/hda_codec.c:4935    hp_outs=2 (0xa/0xf/0x0/0x0/0x0)
@@ -1085,59 +1082,65 @@ ALSA sound/pci/hda/hda_codec.c:4944  Int
 ALSA sound/pci/hda/hda_codec.c:4944  Mic=0xe
 ALSA sound/pci/hda/hda_codec.c:4946 
 ALSA sound/pci/hda/patch_sigmatel.c:3090 stac92xx: dac_nids=2 (0x2/0x5/0x0/0x0/0x0)
-udevd[609]: renamed network interface eth0 to p2p1
+cfg80211: Calling CRDA for country: GB
+cfg80211: Regulatory domain changed to country: GB
+cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
+cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
+cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
+cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
+cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
+Adding 2047996k swap on /dev/sda8.  Priority:0 extents:1 across:2047996k 
 fuse init (API version 7.18)
 SELinux: initialized (dev fusectl, type fusectl), uses genfs_contexts
-mount[900]: mount: fusectl already mounted or /sys/fs/fuse/connections busy
-mount[900]: mount: according to mtab, fusectl is already mounted on /sys/fs/fuse/connections
+mount[931]: mount: fusectl already mounted or /sys/fs/fuse/connections busy
+mount[931]: mount: according to mtab, fusectl is already mounted on /sys/fs/fuse/connections
 systemd[1]: sys-fs-fuse-connections.mount mount process exited, code=exited status=32
-Adding 2047996k swap on /dev/sda8.  Priority:0 extents:1 across:2047996k 
-systemd-fsck[893]: /dev/sda5: clean, 281/76304 files, 117477/304216 blocks
 SELinux: initialized (dev sda3, type fuseblk), uses genfs_contexts
-ntfs-3g[923]: Version 2011.4.12 integrated FUSE 27
-ntfs-3g[923]: Mounted /dev/sda3 (Read-Write, label "", NTFS 3.1)
-ntfs-3g[923]: Cmdline options: rw
-ntfs-3g[923]: Mount options: rw,allow_other,nonempty,atime,fsname=/dev/sda3,blkdev,blksize=4096
-ntfs-3g[923]: Ownership and permissions disabled, configuration type 1
-fedora-storage-init[912]: Setting up Logical Volume Management:   No volume groups found
-fedora-storage-init[912]: [  OK  ]
-EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
-SELinux: initialized (dev sda5, type ext4), uses xattr
-fedora-storage-init[925]: Setting up Logical Volume Management:   No volume groups found
-fedora-storage-init[925]: [  OK  ]
-systemd-fsck[903]: /home: clean, 1056585/5799936 files, 19080578/23175424 blocks
-lvm[935]: No volume groups found
+ntfs-3g[950]: Version 2011.4.12 integrated FUSE 27
+ntfs-3g[950]: Mounted /dev/sda3 (Read-Write, label "", NTFS 3.1)
+ntfs-3g[950]: Cmdline options: rw
+ntfs-3g[950]: Mount options: rw,allow_other,nonempty,atime,fsname=/dev/sda3,blkdev,blksize=4096
+ntfs-3g[950]: Ownership and permissions disabled, configuration type 1
+systemd-fsck[925]: /home: clean, 1056585/5799936 files, 19080275/23175424 blocks
 EXT4-fs (sda6): mounting ext3 file system using the ext4 subsystem
+fedora-storage-init[944]: Setting up Logical Volume Management:   No volume groups found
+fedora-storage-init[944]: [  OK  ]
 EXT4-fs (sda6): mounted filesystem with ordered data mode. Opts: (null)
 SELinux: initialized (dev sda6, type ext3), uses xattr
+systemd-fsck[935]: /dev/sda5: clean, 281/76304 files, 117477/304216 blocks
 EXT4-fs (sda9): warning: maximal mount count reached, running e2fsck is recommended
 EXT4-fs (sda9): mounted filesystem with ordered data mode. Opts: (null)
 SELinux: initialized (dev sda9, type ext4), uses xattr
-systemd-tmpfiles[951]: Successfully loaded SELinux database in 13ms 399us, size on heap is 366K.
+fedora-storage-init[957]: Setting up Logical Volume Management:   No volume groups found
+fedora-storage-init[957]: [  OK  ]
+EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
+SELinux: initialized (dev sda5, type ext4), uses xattr
+lvm[975]: No volume groups found
+systemd-tmpfiles[982]: Successfully loaded SELinux database in 14ms 107us, size on heap is 366K.
+mcelog[1015]: mcelog read: No such device
 nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
-auditd[965]: Started dispatcher: /sbin/audispd pid: 990
-iptables.init[959]: iptables: Applying firewall rules: [  OK  ]
-audispd[990]: priority_boost_parser called with: 4
-audispd[990]: max_restarts_parser called with: 10
-audispd[990]: audispd initialized with q_depth=120 and 1 active plugins
 ip6_tables: (C) 2000-2006 Netfilter Core Team
-ip6tables.init[960]: ip6tables: Applying firewall rules: [  OK  ]
-NetworkManager[1003]: <info> NetworkManager (version 0.9.2-1.fc16) is starting...
-NetworkManager[1003]: <info> Read config file /etc/NetworkManager/NetworkManager.conf
-NetworkManager[1003]: NetworkManager[1003]: <info> NetworkManager (version 0.9.2-1.fc16) is starting...
-NetworkManager[1003]: NetworkManager[1003]: <info> Read config file /etc/NetworkManager/NetworkManager.conf
-mcelog[996]: mcelog read: No such device
-auditctl[973]: No rules
-auditctl[973]: AUDIT_STATUS: enabled=0 flag=1 pid=965 rate_limit=0 backlog_limit=320 lost=0 backlog=0
-abrtd[1011]: Init complete, entering main loop
-acpid[1026]: starting up with netlink and the input layer
-acpid[1026]: skipping incomplete file /etc/acpi/events/videoconf
-acpid[1026]: 1 rule loaded
-acpid[1026]: waiting for events: event logging is off
-avahi-daemon[1025]: Found user 'avahi' (UID 70) and group 'avahi' (GID 70).
-avahi-daemon[1025]: Successfully dropped root privileges.
-avahi-daemon[1025]: avahi-daemon 0.6.30 starting up.
-auditd[965]: Init complete, auditd 2.1.3 listening for events (startup state enable)
+iptables.init[991]: iptables: Applying firewall rules: [  OK  ]
+ip6tables.init[993]: ip6tables: Applying firewall rules: [  OK  ]
+NetworkManager[1029]: <info> NetworkManager (version 0.9.2-1.fc16) is starting...
+NetworkManager[1029]: <info> Read config file /etc/NetworkManager/NetworkManager.conf
+NetworkManager[1029]: NetworkManager[1029]: <info> NetworkManager (version 0.9.2-1.fc16) is starting...
+NetworkManager[1029]: NetworkManager[1029]: <info> Read config file /etc/NetworkManager/NetworkManager.conf
+auditd[995]: Started dispatcher: /sbin/audispd pid: 1042
+audispd[1042]: priority_boost_parser called with: 4
+audispd[1042]: max_restarts_parser called with: 10
+audispd[1042]: audispd initialized with q_depth=120 and 1 active plugins
+auditctl[1001]: No rules
+auditctl[1001]: AUDIT_STATUS: enabled=0 flag=1 pid=0 rate_limit=0 backlog_limit=320 lost=0 backlog=0
+abrtd[1038]: Init complete, entering main loop
+avahi-daemon[1051]: Found user 'avahi' (UID 70) and group 'avahi' (GID 70).
+avahi-daemon[1051]: Successfully dropped root privileges.
+avahi-daemon[1051]: avahi-daemon 0.6.30 starting up.
+acpid[1064]: starting up with netlink and the input layer
+acpid[1064]: skipping incomplete file /etc/acpi/events/videoconf
+acpid[1064]: 1 rule loaded
+acpid[1064]: waiting for events: event logging is off
+auditd[995]: Init complete, auditd 2.1.3 listening for events (startup state enable)
 Loading iSCSI transport class v2.0-870.
 iscsi: registered transport (tcp)
 iscsi: registered transport (iser)
@@ -1153,6 +1156,8 @@ iscsi: registered transport (bnx2i)
 iscsi: registered transport (be2iscsi)
 sky2 0000:09:00.0: p2p1: enabling interface
 ADDRCONF(NETDEV_UP): p2p1: link is not ready
+iwl3945 0000:0b:00.0: loaded firmware version 15.32.2.9
+ADDRCONF(NETDEV_UP): wlan0: link is not ready
 8021q: 802.1Q VLAN Support v1.8
 netlink: 12 bytes leftover after parsing attributes.
 netlink: 12 bytes leftover after parsing attributes.
@@ -1160,5 +1165,15 @@ netlink: 12 bytes leftover after parsing
 composite sync not supported
 composite sync not supported
 composite sync not supported
+wlan0: authenticate with 00:8b:5d:90:fa:8a (try 1)
+wlan0: authenticated
+wlan0: associate with 00:8b:5d:90:fa:8a (try 1)
+wlan0: RX AssocResp from 00:8b:5d:90:fa:8a (capab=0x431 status=0 aid=1)
+wlan0: associated
+wlan0: moving STA 00:8b:5d:90:fa:8a to state 1
+wlan0: moving STA 00:8b:5d:90:fa:8a to state 2
+ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
+wlan0: moving STA 00:8b:5d:90:fa:8a to state 3
 composite sync not supported
 hda-intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
+wlan0: no IPv6 routers present
