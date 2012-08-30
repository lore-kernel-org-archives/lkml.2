Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab2H3Mm1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 08:42:27 -0400
Received: from mail.anarazel.de ([217.115.131.40]:36750 "EHLO mail.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327Ab2H3MmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 08:42:19 -0400
X-Greylist: delayed 453 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Aug 2012 08:42:17 EDT
From: Andres Freund <andres@anarazel.de>
To: LKML <linux-kernel@vger.kernel.org>,
        Bernhard Seibold <mail@bernhard-seibold.de>,
        Jiri Kosina <jkosina@suse.cz>
Subject: regression 3.5->3.6: usb keyboard not working anymore
Date: Thu, 30 Aug 2012 14:34:25 +0200
User-Agent: KMail/1.13.7 (Linux/3.5.0-rc6-andres-00196-gfdb1335; KDE/4.8.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_S31PQ8LoqFLmOJE"
Message-Id: <201208301434.26195.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_S31PQ8LoqFLmOJE
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

Somewhere between: v3.5-rc6-196-gfdb1335 and v3.6-rc1-355-gddf343f my usb 
keyboard/trackpoint combination stopped working. At first I thought that would 
be some early merge related issue and waited (yeayea, sorry), but up to v3.6-
rc3-177-gc182ae4 its still not working.
Since then no relevant commits seem to have gone in.

Interestingly the keyboard/mouse is successfully recognized and shows up in 
lsub.

With a quick grep I just discovered that a new driver for this (or similar?) 
keyboards has been added. I have *not* compiled this in though:
+# CONFIG_HID_LENOVO_TPKBD is not set

Is the new, unconditional, entry in the hid_have_special_driver struct the 
problem?
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 8e3a6b2..f695680 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1544,6 +1544,7 @@ static const struct hid_device_id 
hid_have_special_driver[] = {
    { HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_EASYPEN_M610X) },
    { HID_USB_DEVICE(USB_VENDOR_ID_LABTEC, 
USB_DEVICE_ID_LABTEC_WIRELESS_KEYBOARD) },
    { HID_USB_DEVICE(USB_VENDOR_ID_LCPOWER, USB_DEVICE_ID_LCPOWER_LC1000 ) },
+   { HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_TPKBD) },
    { HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_MX3000_RECEIVER) },
    { HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER) },
    { HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER_2) },

Other entries seem to be protected via things like:
#if IS_ENABLED(CONFIG_HID_LOGITECH_DJ)

I have somewhat obsoleted my original line of thought in this email, but hell. 
Will try this and send a patch if it works.

Greetings,

Andres

--Boundary-00=_S31PQ8LoqFLmOJE
Content-Type: text/plain;
  charset="UTF-8";
  name="dmesg-3.6-rc3"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg-3.6-rc3"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.0-rc3-andres-00177-gc182ae4 (andres@awork2) (gcc version 4.7.1 (Debian 4.7.1-7) ) #143 SMP Mon Aug 27 00:41:38 CEST 2012
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.6.0-rc3-andres-00177-gc182ae4 root=UUID=58ba7a04-b424-4a46-acbe-b6ca208f61e1 ro clocksource=hpet netconsole=4444@192.168.224.176/eth0,4444@192.168.224.203/00:21:86:60:5d:d6
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009c3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009c400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bf76ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bf770000-0x00000000bf77dfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bf77e000-0x00000000bf7cffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf7d0000-0x00000000bf7dffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf7ec000-0x00000000bfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffa00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000063fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: empty empty/S7020, BIOS 'V1.03  ' 03/09/2010
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x640000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D7FFF write-protect
[    0.000000]   D8000-DFFFF uncachable
[    0.000000]   E0000-E7FFF write-protect
[    0.000000]   E8000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FC00000000 write-back
[    0.000000]   1 base 0400000000 mask FE00000000 write-back
[    0.000000]   2 base 0600000000 mask FFC0000000 write-back
[    0.000000]   3 base 00C0000000 mask FFC0000000 uncachable
[    0.000000]   4 base 00BF800000 mask FFFF800000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xbf800000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xbf770 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000ff780-0x000ff78f] mapped at [ffff8800000ff780]
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000095000] 95000 size 28672
[    0.000000] init_memory_mapping: [mem 0x00000000-0xbf76ffff]
[    0.000000]  [mem 0x00000000-0xbf5fffff] page 2M
[    0.000000]  [mem 0xbf600000-0xbf76ffff] page 4k
[    0.000000] kernel direct mapping tables up to 0xbf76ffff @ [mem 0x1fa00000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x63fffffff]
[    0.000000]  [mem 0x100000000-0x63fffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x63fffffff @ [mem 0xbf756000-0xbf76ffff]
[    0.000000] RAMDISK: [mem 0x37174000-0x378b1fff]
[    0.000000] ACPI: RSDP 00000000000fa840 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000bf770100 0006C (v01 030910 XSDT1851 20100309 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000bf770290 000F4 (v04 030910 FACP1851 20100309 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000bf770540 06537 (v02  7020_ 7020_001 00000001 INTL 20051117)
[    0.000000] ACPI: FACS 00000000bf77e000 00040
[    0.000000] ACPI: APIC 00000000bf770390 0011E (v02 030910 APIC1851 20100309 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000bf7704b0 0003C (v01 030910 OEMMCFG  20100309 MSFT 00000097)
[    0.000000] ACPI: SPMI 00000000bf7704f0 00041 (v05 030910 OEMSPMI  20100309 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000bf77e040 00082 (v01 030910 OEMB1851 20100309 MSFT 00000097)
[    0.000000] ACPI: SRAT 00000000bf77a540 001D0 (v02 030910 OEMSRAT  00000001 INTL 00000001)
[    0.000000] ACPI: HPET 00000000bf77a710 00038 (v01 030910 OEMHPET  20100309 MSFT 00000097)
[    0.000000] ACPI: DMAR 00000000bf77e0d0 00128 (v01    AMI  OEMDMAR 00000001 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000bf781e00 00363 (v01 DpgPmm    CpuPm 00000012 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x06 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x07 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x10 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x12 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x14 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x16 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x11 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x13 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x15 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x17 -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x0009ffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00100000-0xbfffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x33fffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x340000000-0x63fffffff]
[    0.000000] NUMA: Node 0 [mem 0x00000000-0x0009ffff] + [mem 0x00100000-0xbfffffff] -> [mem 0x00000000-0xbfffffff]
[    0.000000] NUMA: Node 0 [mem 0x00000000-0xbfffffff] + [mem 0x100000000-0x33fffffff] -> [mem 0x00000000-0x33fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x33fffffff]
[    0.000000]   NODE_DATA [mem 0x33fffc000-0x33fffffff]
[    0.000000] Initmem setup node 1 [mem 0x340000000-0x63fffffff]
[    0.000000]   NODE_DATA [mem 0x63fffc000-0x63fffffff]
[    0.000000]  [ffffea0000000000-ffffea000cffffff] PMD -> [ffff880333e00000-ffff88033fdfffff] on node 0
[    0.000000]  [ffffea000d000000-ffffea0018ffffff] PMD -> [ffff880633600000-ffff88063f5fffff] on node 1
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x63fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009bfff]
[    0.000000]   node   0: [mem 0x00100000-0xbf76ffff]
[    0.000000]   node   0: [mem 0x100000000-0x33fffffff]
[    0.000000]   node   1: [mem 0x340000000-0x63fffffff]
[    0.000000] On node 0 totalpages: 3143420
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 7 pages reserved
[    0.000000]   DMA zone: 3909 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 763824 pages, LIFO batch:31
[    0.000000]   Normal zone: 36864 pages used for memmap
[    0.000000]   Normal zone: 2322432 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 3145728
[    0.000000]   Normal zone: 49152 pages used for memmap
[    0.000000]   Normal zone: 3096576 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x16] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x17] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x90] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x91] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x92] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x93] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x94] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x95] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x96] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x97] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec8a000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec8a000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 24 CPUs, 8 hotplug CPUs
[    0.000000] nr_irqs_gsi: 64
[    0.000000] PM: Registered nosave memory: 000000000009c000 - 000000000009d000
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bf770000 - 00000000bf77e000
[    0.000000] PM: Registered nosave memory: 00000000bf77e000 - 00000000bf7d0000
[    0.000000] PM: Registered nosave memory: 00000000bf7d0000 - 00000000bf7e0000
[    0.000000] PM: Registered nosave memory: 00000000bf7e0000 - 00000000bf7ec000
[    0.000000] PM: Registered nosave memory: 00000000bf7ec000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffa00000
[    0.000000] PM: Registered nosave memory: 00000000ffa00000 - 0000000100000000
[    0.000000] e820: [mem 0xc0000000-0xdfffffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:24 nr_node_ids:2
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880333c00000 s80512 r8192 d21888 u131072
[    0.000000] pcpu-alloc: s80512 r8192 d21888 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 08 09 10 11 16 18 20 22 -- -- -- -- 
[    0.000000] pcpu-alloc: [1] 04 05 06 07 12 13 14 15 17 19 21 23 -- -- -- -- 
[    0.000000] Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 6186741
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.6.0-rc3-andres-00177-gc182ae4 root=UUID=58ba7a04-b424-4a46-acbe-b6ca208f61e1 ro clocksource=hpet netconsole=4444@192.168.224.176/eth0,4444@192.168.224.203/00:21:86:60:5d:d6
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 24665288k/26214400k available (10432k kernel code, 1057808k absent, 491304k reserved, 9069k data, 900k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=24, Nodes=2
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 		    RCU restricting CPUs from NR_CPUS=64 to nr_cpu_ids=24.
[    0.000000] NR_IRQS:4352 nr_irqs:1280 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.003333] tsc: Detected 2266.687 MHz processor
[    0.000007] Calibrating delay loop (skipped), value calculated using timer frequency.. 4535.26 BogoMIPS (lpj=7555623)
[    0.000394] pid_max: default: 32768 minimum: 301
[    0.003241] Dentry cache hash table entries: 4194304 (order: 13, 33554432 bytes)
[    0.011637] Inode-cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.015293] Mount-cache hash table entries: 256
[    0.015784] Initializing cgroup subsys cpuacct
[    0.015978] Initializing cgroup subsys devices
[    0.016169] Initializing cgroup subsys freezer
[    0.016351] Initializing cgroup subsys net_cls
[    0.016547] Initializing cgroup subsys blkio
[    0.016763] CPU: Physical Processor ID: 0
[    0.016959] CPU: Processor Core ID: 0
[    0.017147] mce: CPU supports 9 MCE banks
[    0.017346] CPU0: Thermal monitoring enabled (TM1)
[    0.017541] process: using mwait in idle threads
[    0.017732] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
[    0.017732] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    0.017732] tlb_flushall_shift is 0x6
[    0.018218] ACPI: Core revision 20120711
[    0.044682] ftrace: allocating 34716 entries in 136 pages
[    0.065554] dmar: Host address width 40
[    0.065750] dmar: DRHD base: 0x000000fbffe000 flags: 0x1
[    0.065964] dmar: IOMMU 0: reg_base_addr fbffe000 ver 1:0 cap c90780106f0462 ecap f0207e
[    0.066251] dmar: RMRR base: 0x000000000ec000 end: 0x000000000effff
[    0.066451] dmar: RMRR base: 0x000000bf7ec000 end: 0x000000bf7fffff
[    0.066649] dmar: ATSR flags: 0x0
[    0.069783] IOAPIC id 8 under DRHD base  0xfbffe000 IOMMU 0
[    0.069987] IOAPIC id 9 under DRHD base  0xfbffe000 IOMMU 0
[    0.070377] Enabled IRQ remapping in xapic mode
[    0.070580] Switched APIC routing to physical flat.
[    0.071451] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.104592] smpboot: CPU0: Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz stepping 05
[    0.227729] APIC calibration not consistent with PM-Timer: 116ms instead of 100ms
[    0.228012] APIC delta adjusted to PM-Timer: 833361 (972246)
[    0.228221] Performance Events: PEBS fmt1+, 16-deep LBR, Nehalem events, Intel PMU driver.
[    0.228942] perf_event_intel: CPU erratum AAJ80 worked around
[    0.229142] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
[    0.229347] ... version:                3
[    0.229547] ... bit width:              48
[    0.229750] ... generic registers:      4
[    0.229950] ... value mask:             0000ffffffffffff
[    0.230150] ... max period:             000000007fffffff
[    0.230351] ... fixed-purpose events:   3
[    0.230548] ... event mask:             000000070000000f
[    0.231295] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.231867] smpboot: Booting Node   0, Processors  #1 #2 #3 OK
[    0.272549] smpboot: Booting Node   1, Processors  #4 #5 #6 #7 OK
[    0.426073] smpboot: Booting Node   0, Processors  #8 #9 #10 #11 OK
[    0.480111] smpboot: Booting Node   1, Processors  #12 #13 #14 #15
[    0.533874] Brought up 16 CPUs
[    0.534254] smpboot: Total of 16 processors activated (72562.22 BogoMIPS)
[    0.546352] devtmpfs: initialized
[    0.549100] PM: Registering ACPI NVS region [mem 0xbf77e000-0xbf7cffff] (335872 bytes)
[    0.550122] xor: automatically using best checksumming function:
[    0.580968]    generic_sse:  8426.400 MB/sec
[    0.581197] RTC time:  8:42:57, date: 08/29/12
[    0.581442] NET: Registered protocol family 16
[    0.581826] ACPI: bus type pci registered
[    0.582076] dca service started, version 1.12.1
[    0.582291] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.582578] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.599991] PCI: Using configuration type 1 for base access
[    0.602168] bio: create slab <bio-0> at 0
[    0.657511] raid6: sse2x1    5627 MB/s
[    0.714080] raid6: sse2x2    6553 MB/s
[    0.770648] raid6: sse2x4    7151 MB/s
[    0.770846] raid6: using algorithm sse2x4 (7151 MB/s)
[    0.771041] raid6: using ssse3x2 recovery algorithm
[    0.771268] ACPI: Added _OSI(Module Device)
[    0.771461] ACPI: Added _OSI(Processor Device)
[    0.771652] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.771853] ACPI: Added _OSI(Processor Aggregator Device)
[    0.773068] ACPI: EC: Look up EC in DSDT
[    0.774269] ACPI: Executed 1 blocks of module-level executable AML code
[    0.784094] ACPI: SSDT 00000000bf77e200 02B94 (v01 DpgPmm  P001Ist 00000011 INTL 20051117)
[    0.785037] ACPI: Dynamic OEM Table Load:
[    0.785437] ACPI: SSDT           (null) 02B94 (v01 DpgPmm  P001Ist 00000011 INTL 20051117)
[    0.786044] ACPI: SSDT 00000000bf780da0 00961 (v01  PmRef  P001Cst 00003001 INTL 20051117)
[    0.786828] ACPI: Dynamic OEM Table Load:
[    0.787233] ACPI: SSDT           (null) 00961 (v01  PmRef  P001Cst 00003001 INTL 20051117)
[    0.787834] ACPI: SSDT 00000000bf781710 006E2 (v01  PmRef  Cpu0Tst 00003000 INTL 20051117)
[    0.788671] ACPI: Dynamic OEM Table Load:
[    0.789068] ACPI: SSDT           (null) 006E2 (v01  PmRef  Cpu0Tst 00003000 INTL 20051117)
[    0.800963] ACPI: Interpreter enabled
[    0.801163] ACPI: (supports S0 S1 S3 S4 S5)
[    0.801892] ACPI: Using IOAPIC for interrupt routing
[    0.809273] ACPI: No dock devices found.
[    0.809468] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.809834] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.810168] PCI host bridge to bus 0000:00
[    0.810367] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under domain [bus 00-ff]
[    0.810369] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.810570] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.810771] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.810969] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.811175] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000dffff]
[    0.811373] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xdfffffff]
[    0.811576] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfed8ffff]
[    0.811788] pci 0000:00:00.0: [8086:3406] type 00 class 0x060000
[    0.811840] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    0.811863] pci 0000:00:01.0: [8086:3408] type 01 class 0x060400
[    0.811916] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.811942] pci 0000:00:03.0: [8086:340a] type 01 class 0x060400
[    0.811995] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.812023] pci 0000:00:07.0: [8086:340e] type 01 class 0x060400
[    0.812076] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.812103] pci 0000:00:09.0: [8086:3410] type 01 class 0x060400
[    0.812155] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.812182] pci 0000:00:13.0: [8086:342d] type 00 class 0x080020
[    0.812193] pci 0000:00:13.0: reg 10: [mem 0xfec8a000-0xfec8afff]
[    0.812240] pci 0000:00:13.0: PME# supported from D0 D3hot D3cold
[    0.812258] pci 0000:00:14.0: [8086:342e] type 00 class 0x080000
[    0.812324] pci 0000:00:14.1: [8086:3422] type 00 class 0x080000
[    0.812386] pci 0000:00:14.2: [8086:3423] type 00 class 0x080000
[    0.812445] pci 0000:00:14.3: [8086:3438] type 00 class 0x080000
[    0.812505] pci 0000:00:16.0: [8086:3430] type 00 class 0x088000
[    0.812516] pci 0000:00:16.0: reg 10: [mem 0xfb6d8000-0xfb6dbfff 64bit]
[    0.812582] pci 0000:00:16.1: [8086:3431] type 00 class 0x088000
[    0.812593] pci 0000:00:16.1: reg 10: [mem 0xfb6dc000-0xfb6dffff 64bit]
[    0.812659] pci 0000:00:16.2: [8086:3432] type 00 class 0x088000
[    0.812670] pci 0000:00:16.2: reg 10: [mem 0xfb6e0000-0xfb6e3fff 64bit]
[    0.812735] pci 0000:00:16.3: [8086:3433] type 00 class 0x088000
[    0.812746] pci 0000:00:16.3: reg 10: [mem 0xfb6e4000-0xfb6e7fff 64bit]
[    0.812812] pci 0000:00:16.4: [8086:3429] type 00 class 0x088000
[    0.812823] pci 0000:00:16.4: reg 10: [mem 0xfb6e8000-0xfb6ebfff 64bit]
[    0.812891] pci 0000:00:16.5: [8086:342a] type 00 class 0x088000
[    0.812902] pci 0000:00:16.5: reg 10: [mem 0xfb6ec000-0xfb6effff 64bit]
[    0.812968] pci 0000:00:16.6: [8086:342b] type 00 class 0x088000
[    0.812979] pci 0000:00:16.6: reg 10: [mem 0xfb6f0000-0xfb6f3fff 64bit]
[    0.813044] pci 0000:00:16.7: [8086:342c] type 00 class 0x088000
[    0.813055] pci 0000:00:16.7: reg 10: [mem 0xfb6f4000-0xfb6f7fff 64bit]
[    0.813132] pci 0000:00:1a.0: [8086:3a37] type 00 class 0x0c0300
[    0.813175] pci 0000:00:1a.0: reg 20: [io  0x9400-0x941f]
[    0.813233] pci 0000:00:1a.1: [8086:3a38] type 00 class 0x0c0300
[    0.813277] pci 0000:00:1a.1: reg 20: [io  0x9480-0x949f]
[    0.813338] pci 0000:00:1a.2: [8086:3a39] type 00 class 0x0c0300
[    0.813382] pci 0000:00:1a.2: reg 20: [io  0x9800-0x981f]
[    0.813456] pci 0000:00:1a.7: [8086:3a3c] type 00 class 0x0c0320
[    0.813479] pci 0000:00:1a.7: reg 10: [mem 0xfb6f8000-0xfb6f83ff]
[    0.813574] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.813604] pci 0000:00:1c.0: [8086:3a40] type 01 class 0x060400
[    0.813679] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.813718] pci 0000:00:1c.4: [8086:3a48] type 01 class 0x060400
[    0.813793] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.813823] pci 0000:00:1c.5: [8086:3a4a] type 01 class 0x060400
[    0.813897] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.813938] pci 0000:00:1d.0: [8086:3a34] type 00 class 0x0c0300
[    0.813981] pci 0000:00:1d.0: reg 20: [io  0x9880-0x989f]
[    0.814044] pci 0000:00:1d.1: [8086:3a35] type 00 class 0x0c0300
[    0.814087] pci 0000:00:1d.1: reg 20: [io  0x9c00-0x9c1f]
[    0.814149] pci 0000:00:1d.2: [8086:3a36] type 00 class 0x0c0300
[    0.814192] pci 0000:00:1d.2: reg 20: [io  0xa000-0xa01f]
[    0.814267] pci 0000:00:1d.7: [8086:3a3a] type 00 class 0x0c0320
[    0.814290] pci 0000:00:1d.7: reg 10: [mem 0xfb6fa000-0xfb6fa3ff]
[    0.814385] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.814417] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.814493] pci 0000:00:1f.0: [8086:3a16] type 00 class 0x060100
[    0.814578] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0a00 (mask 00ff)
[    0.814854] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0ca0 (mask 000f)
[    0.815143] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at f700 (mask 000f)
[    0.815487] pci 0000:00:1f.2: [8086:3a22] type 00 class 0x010601
[    0.815508] pci 0000:00:1f.2: reg 10: [io  0xa880-0xa887]
[    0.815520] pci 0000:00:1f.2: reg 14: [io  0xa800-0xa803]
[    0.815532] pci 0000:00:1f.2: reg 18: [io  0xa480-0xa487]
[    0.815544] pci 0000:00:1f.2: reg 1c: [io  0xa400-0xa403]
[    0.815556] pci 0000:00:1f.2: reg 20: [io  0xa080-0xa09f]
[    0.815568] pci 0000:00:1f.2: reg 24: [mem 0xfb6fc000-0xfb6fc7ff]
[    0.815621] pci 0000:00:1f.2: PME# supported from D3hot
[    0.815651] pci 0000:00:1f.3: [8086:3a30] type 00 class 0x0c0500
[    0.815664] pci 0000:00:1f.3: reg 10: [mem 0xfb6fe000-0xfb6fe0ff 64bit]
[    0.815688] pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
[    0.815749] pci_bus 0000:09: busn_res: [bus 09-0a] is inserted under [bus 00-ff]
[    0.815764] pci 0000:09:00.0: [8086:032c] type 01 class 0x060400
[    0.815784] pci 0000:09:00.0: PXH quirk detected; SHPC device MSI disabled
[    0.816041] pci 0000:09:00.0: PME# supported from D0 D3hot D3cold
[    0.816065] pci 0000:09:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.816367] pci 0000:00:01.0: PCI bridge to [bus 09-0a]
[    0.816601] pci_bus 0000:0a: busn_res: [bus 0a] is inserted under [bus 09-0a]
[    0.816632] pci 0000:09:00.0: PCI bridge to [bus 0a]
[    0.816867] pci_bus 0000:08: busn_res: [bus 08] is inserted under [bus 00-ff]
[    0.816881] pci 0000:08:00.0: [1002:6738] type 00 class 0x030000
[    0.816896] pci 0000:08:00.0: reg 10: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.816908] pci 0000:08:00.0: reg 18: [mem 0xfbec0000-0xfbedffff 64bit]
[    0.816916] pci 0000:08:00.0: reg 20: [io  0xe000-0xe0ff]
[    0.816931] pci 0000:08:00.0: reg 30: [mem 0xfbea0000-0xfbebffff pref]
[    0.816968] pci 0000:08:00.0: supports D1 D2
[    0.816992] pci 0000:08:00.1: [1002:aa88] type 00 class 0x040300
[    0.817006] pci 0000:08:00.1: reg 10: [mem 0xfbefc000-0xfbefffff 64bit]
[    0.817074] pci 0000:08:00.1: supports D1 D2
[    0.820580] pci 0000:00:03.0: PCI bridge to [bus 08]
[    0.820786] pci 0000:00:03.0:   bridge window [io  0xe000-0xefff]
[    0.820789] pci 0000:00:03.0:   bridge window [mem 0xfbe00000-0xfbefffff]
[    0.820794] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.820827] pci_bus 0000:07: busn_res: [bus 07] is inserted under [bus 00-ff]
[    0.820829] pci 0000:00:07.0: PCI bridge to [bus 07]
[    0.821065] pci_bus 0000:06: busn_res: [bus 06] is inserted under [bus 00-ff]
[    0.821079] pci 0000:06:00.0: [1000:0058] type 00 class 0x010000
[    0.821092] pci 0000:06:00.0: reg 10: [io  0xd000-0xd0ff]
[    0.821106] pci 0000:06:00.0: reg 14: [mem 0xfbdfc000-0xfbdfffff 64bit]
[    0.821120] pci 0000:06:00.0: reg 1c: [mem 0xfbde0000-0xfbdeffff 64bit]
[    0.821133] pci 0000:06:00.0: reg 30: [mem 0xfba00000-0xfbbfffff pref]
[    0.821174] pci 0000:06:00.0: supports D1 D2
[    0.821190] pci 0000:06:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.821469] pci 0000:00:09.0: PCI bridge to [bus 06]
[    0.821669] pci 0000:00:09.0:   bridge window [io  0xd000-0xdfff]
[    0.821672] pci 0000:00:09.0:   bridge window [mem 0xfba00000-0xfbdfffff]
[    0.821715] pci_bus 0000:04: busn_res: [bus 04-05] is inserted under [bus 00-ff]
[    0.821820] pci 0000:04:00.0: [1102:7006] type 01 class 0x060400
[    0.822366] pci 0000:04:00.0: supports D1 D2
[    0.822463] pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.822775] pci 0000:00:1c.0: PCI bridge to [bus 04-05]
[    0.822977] pci 0000:00:1c.0:   bridge window [mem 0xfb900000-0xfb9fffff]
[    0.823063] pci_bus 0000:05: busn_res: [bus 05] is inserted under [bus 04-05]
[    0.823106] pci 0000:05:00.0: [1102:0009] type 00 class 0x040300
[    0.823180] pci 0000:05:00.0: reg 10: [mem 0xfb9fc000-0xfb9fffff]
[    0.823546] pci 0000:05:00.0: supports D1 D2
[    0.823744] pci 0000:04:00.0: PCI bridge to [bus 05]
[    0.823953] pci 0000:04:00.0:   bridge window [mem 0xfb900000-0xfb9fffff]
[    0.824016] pci_bus 0000:03: busn_res: [bus 03] is inserted under [bus 00-ff]
[    0.824167] pci 0000:03:00.0: [8086:10d3] type 00 class 0x020000
[    0.824232] pci 0000:03:00.0: reg 10: [mem 0xfb8e0000-0xfb8fffff]
[    0.824336] pci 0000:03:00.0: reg 18: [io  0xcc00-0xcc1f]
[    0.824388] pci 0000:03:00.0: reg 1c: [mem 0xfb8dc000-0xfb8dffff]
[    0.824854] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.825032] pci 0000:00:1c.4: PCI bridge to [bus 03]
[    0.825227] pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
[    0.825235] pci 0000:00:1c.4:   bridge window [mem 0xfb800000-0xfb8fffff]
[    0.825287] pci_bus 0000:02: busn_res: [bus 02] is inserted under [bus 00-ff]
[    0.825426] pci 0000:02:00.0: [8086:10d3] type 00 class 0x020000
[    0.825494] pci 0000:02:00.0: reg 10: [mem 0xfb7e0000-0xfb7fffff]
[    0.825601] pci 0000:02:00.0: reg 18: [io  0xbc00-0xbc1f]
[    0.825649] pci 0000:02:00.0: reg 1c: [mem 0xfb7dc000-0xfb7dffff]
[    0.826110] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.826281] pci 0000:00:1c.5: PCI bridge to [bus 02]
[    0.826482] pci 0000:00:1c.5:   bridge window [io  0xb000-0xbfff]
[    0.826490] pci 0000:00:1c.5:   bridge window [mem 0xfb700000-0xfb7fffff]
[    0.826526] pci_bus 0000:01: busn_res: [bus 01] is inserted under [bus 00-ff]
[    0.826568] pci 0000:00:1e.0: PCI bridge to [bus 01] (subtractive decode)
[    0.826775] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.826777] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.826779] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.826780] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    0.826782] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xdfffffff] (subtractive decode)
[    0.826784] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfed8ffff] (subtractive decode)
[    0.826821] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.826998] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE1._PRT]
[    0.827027] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE1.PXH_._PRT]
[    0.827061] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE3._PRT]
[    0.827089] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE7._PRT]
[    0.827112] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE9._PRT]
[    0.827140] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.827186] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    0.827216] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
[    0.827251] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
[    0.827278]  pci0000:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.827568]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.845942] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 *10 11 12 14 15)
[    0.847324] ACPI: PCI Interrupt Link [LNKB] (IRQs *5)
[    0.847880] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 11 12 14 *15)
[    0.849270] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 *11 12 14 15)
[    0.850659] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12 14 15) *0, disabled.
[    0.852334] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 7 *10 11 12 14 15)
[    0.853728] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 6 7 10 11 12 14 15) *0, disabled.
[    0.855409] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 6 7 10 11 12 *14 15)
[    0.856838] vgaarb: device added: PCI:0000:08:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.857130] vgaarb: loaded
[    0.857322] vgaarb: bridge control possible 0000:08:00.0
[    0.857570] SCSI subsystem initialized
[    0.857763] ACPI: bus type scsi registered
[    0.857987] libata version 3.00 loaded.
[    0.857993] ACPI: bus type usb registered
[    0.858195] usbcore: registered new interface driver usbfs
[    0.858404] usbcore: registered new interface driver hub
[    0.858615] usbcore: registered new device driver usb
[    0.858862] PCI: Using ACPI for IRQ routing
[    0.864842] PCI: Discovered peer bus fe
[    0.865039] PCI: root bus fe: using default resources
[    0.865040] PCI: Probing PCI hardware (bus fe)
[    0.865062] PCI host bridge to bus 0000:fe
[    0.865261] pci_bus 0000:fe: root bus resource [io  0x0000-0xffff]
[    0.865468] pci_bus 0000:fe: root bus resource [mem 0x00000000-0xffffffffff]
[    0.865667] pci_bus 0000:fe: No busn resource found for root bus, will use [bus fe-ff]
[    0.865948] pci_bus 0000:fe: busn_res: [bus fe-ff] is inserted under domain [bus 00-ff]
[    0.865953] pci 0000:fe:00.0: [8086:2c40] type 00 class 0x060000
[    0.865976] pci 0000:fe:00.1: [8086:2c01] type 00 class 0x060000
[    0.865999] pci 0000:fe:02.0: [8086:2c10] type 00 class 0x060000
[    0.866020] pci 0000:fe:02.1: [8086:2c11] type 00 class 0x060000
[    0.866043] pci 0000:fe:02.4: [8086:2c14] type 00 class 0x060000
[    0.866064] pci 0000:fe:02.5: [8086:2c15] type 00 class 0x060000
[    0.866085] pci 0000:fe:03.0: [8086:2c18] type 00 class 0x060000
[    0.866105] pci 0000:fe:03.1: [8086:2c19] type 00 class 0x060000
[    0.866126] pci 0000:fe:03.2: [8086:2c1a] type 00 class 0x060000
[    0.866146] pci 0000:fe:03.4: [8086:2c1c] type 00 class 0x060000
[    0.866168] pci 0000:fe:04.0: [8086:2c20] type 00 class 0x060000
[    0.866188] pci 0000:fe:04.1: [8086:2c21] type 00 class 0x060000
[    0.866210] pci 0000:fe:04.2: [8086:2c22] type 00 class 0x060000
[    0.866230] pci 0000:fe:04.3: [8086:2c23] type 00 class 0x060000
[    0.866253] pci 0000:fe:05.0: [8086:2c28] type 00 class 0x060000
[    0.866273] pci 0000:fe:05.1: [8086:2c29] type 00 class 0x060000
[    0.866293] pci 0000:fe:05.2: [8086:2c2a] type 00 class 0x060000
[    0.866314] pci 0000:fe:05.3: [8086:2c2b] type 00 class 0x060000
[    0.866336] pci 0000:fe:06.0: [8086:2c30] type 00 class 0x060000
[    0.866357] pci 0000:fe:06.1: [8086:2c31] type 00 class 0x060000
[    0.866378] pci 0000:fe:06.2: [8086:2c32] type 00 class 0x060000
[    0.866399] pci 0000:fe:06.3: [8086:2c33] type 00 class 0x060000
[    0.866433] pci_bus 0000:fe: busn_res: [bus fe-ff] end is updated to fe
[    0.866788] PCI: Discovered peer bus ff
[    0.866977] PCI: root bus ff: using default resources
[    0.866978] PCI: Probing PCI hardware (bus ff)
[    0.866998] PCI host bridge to bus 0000:ff
[    0.867196] pci_bus 0000:ff: root bus resource [io  0x0000-0xffff]
[    0.867400] pci_bus 0000:ff: root bus resource [mem 0x00000000-0xffffffffff]
[    0.867596] pci_bus 0000:ff: No busn resource found for root bus, will use [bus ff-ff]
[    0.867887] pci_bus 0000:ff: busn_res: [bus ff] is inserted under domain [bus 00-ff]
[    0.867892] pci 0000:ff:00.0: [8086:2c40] type 00 class 0x060000
[    0.867911] pci 0000:ff:00.1: [8086:2c01] type 00 class 0x060000
[    0.867932] pci 0000:ff:02.0: [8086:2c10] type 00 class 0x060000
[    0.867949] pci 0000:ff:02.1: [8086:2c11] type 00 class 0x060000
[    0.867968] pci 0000:ff:02.4: [8086:2c14] type 00 class 0x060000
[    0.867986] pci 0000:ff:02.5: [8086:2c15] type 00 class 0x060000
[    0.868007] pci 0000:ff:03.0: [8086:2c18] type 00 class 0x060000
[    0.868026] pci 0000:ff:03.1: [8086:2c19] type 00 class 0x060000
[    0.868044] pci 0000:ff:03.2: [8086:2c1a] type 00 class 0x060000
[    0.868062] pci 0000:ff:03.4: [8086:2c1c] type 00 class 0x060000
[    0.868082] pci 0000:ff:04.0: [8086:2c20] type 00 class 0x060000
[    0.868100] pci 0000:ff:04.1: [8086:2c21] type 00 class 0x060000
[    0.868118] pci 0000:ff:04.2: [8086:2c22] type 00 class 0x060000
[    0.868136] pci 0000:ff:04.3: [8086:2c23] type 00 class 0x060000
[    0.868158] pci 0000:ff:05.0: [8086:2c28] type 00 class 0x060000
[    0.868176] pci 0000:ff:05.1: [8086:2c29] type 00 class 0x060000
[    0.868195] pci 0000:ff:05.2: [8086:2c2a] type 00 class 0x060000
[    0.868213] pci 0000:ff:05.3: [8086:2c2b] type 00 class 0x060000
[    0.868233] pci 0000:ff:06.0: [8086:2c30] type 00 class 0x060000
[    0.868251] pci 0000:ff:06.1: [8086:2c31] type 00 class 0x060000
[    0.868269] pci 0000:ff:06.2: [8086:2c32] type 00 class 0x060000
[    0.868287] pci 0000:ff:06.3: [8086:2c33] type 00 class 0x060000
[    0.868317] pci_bus 0000:ff: busn_res: [bus ff] end is updated to ff
[    0.868676] PCI: pci_cache_line_size set to 64 bytes
[    0.869044] e820: reserve RAM buffer [mem 0x0009c400-0x0009ffff]
[    0.869046] e820: reserve RAM buffer [mem 0xbf770000-0xbfffffff]
[    0.869167] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.869370] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.870089] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.879994] Switching to clocksource hpet
[    0.887932] pnp: PnP ACPI init
[    0.888131] ACPI: bus type pnp registered
[    0.888425] pnp 00:00: [bus 00-ff]
[    0.888428] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.888430] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.888435] pnp 00:00: [io  0x0d00-0xffff window]
[    0.888437] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.888439] pnp 00:00: [mem 0x000d0000-0x000dffff window]
[    0.888441] pnp 00:00: [mem 0xc0000000-0xdfffffff window]
[    0.888443] pnp 00:00: [mem 0xf0000000-0xfed8ffff window]
[    0.888501] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.888511] pnp 00:01: [mem 0xfbf00000-0xfbffffff]
[    0.888513] pnp 00:01: [mem 0xfc000000-0xfcffffff]
[    0.888514] pnp 00:01: [mem 0xfd000000-0xfdffffff]
[    0.888516] pnp 00:01: [mem 0xfe000000-0xfebfffff]
[    0.888518] pnp 00:01: [mem 0xfec8a000-0xfec8afff]
[    0.888519] pnp 00:01: [mem 0xfed10000-0xfed10fff]
[    0.888587] system 00:01: [mem 0xfbf00000-0xfbffffff] could not be reserved
[    0.888793] system 00:01: [mem 0xfc000000-0xfcffffff] has been reserved
[    0.888997] system 00:01: [mem 0xfd000000-0xfdffffff] has been reserved
[    0.889195] system 00:01: [mem 0xfe000000-0xfebfffff] has been reserved
[    0.889399] system 00:01: [mem 0xfec8a000-0xfec8afff] could not be reserved
[    0.889599] system 00:01: [mem 0xfed10000-0xfed10fff] has been reserved
[    0.889797] system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.889843] pnp 00:02: [dma 4]
[    0.889845] pnp 00:02: [io  0x0000-0x000f]
[    0.889847] pnp 00:02: [io  0x0081-0x0083]
[    0.889848] pnp 00:02: [io  0x0087]
[    0.889850] pnp 00:02: [io  0x0089-0x008b]
[    0.889851] pnp 00:02: [io  0x008f]
[    0.889853] pnp 00:02: [io  0x00c0-0x00df]
[    0.889879] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.889888] pnp 00:03: [io  0x0070-0x0071]
[    0.889901] pnp 00:03: [irq 8]
[    0.889923] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.889961] pnp 00:04: [io  0x0061]
[    0.889984] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.889992] pnp 00:05: [io  0x00f0-0x00ff]
[    0.890003] pnp 00:05: [irq 13]
[    0.890029] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.890282] pnp 00:06: [io  0x03f8-0x03ff]
[    0.890292] pnp 00:06: [irq 4]
[    0.890294] pnp 00:06: [dma 0 disabled]
[    0.890353] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.890583] pnp 00:07: [io  0x02f8-0x02ff]
[    0.890595] pnp 00:07: [irq 3]
[    0.890597] pnp 00:07: [dma 0 disabled]
[    0.890677] pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.890751] pnp 00:08: [io  0x0000-0xffffffffffffffff disabled]
[    0.890753] pnp 00:08: [io  0x0a00-0x0a0f]
[    0.890755] pnp 00:08: [io  0x0a10-0x0a1f]
[    0.890814] system 00:08: [io  0x0a00-0x0a0f] has been reserved
[    0.891017] system 00:08: [io  0x0a10-0x0a1f] has been reserved
[    0.891218] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.891319] pnp 00:09: [io  0x0010-0x001f]
[    0.891321] pnp 00:09: [io  0x0022-0x003f]
[    0.891323] pnp 00:09: [io  0x0044-0x005f]
[    0.891324] pnp 00:09: [io  0x0062-0x0063]
[    0.891326] pnp 00:09: [io  0x0065-0x006f]
[    0.891327] pnp 00:09: [io  0x0072-0x007f]
[    0.891329] pnp 00:09: [io  0x0080]
[    0.891330] pnp 00:09: [io  0x0084-0x0086]
[    0.891332] pnp 00:09: [io  0x0088]
[    0.891334] pnp 00:09: [io  0x008c-0x008e]
[    0.891338] pnp 00:09: [io  0x0090-0x009f]
[    0.891340] pnp 00:09: [io  0x00a2-0x00bf]
[    0.891341] pnp 00:09: [io  0x00e0-0x00ef]
[    0.891343] pnp 00:09: [io  0x04d0-0x04d1]
[    0.891344] pnp 00:09: [io  0x0800-0x087f]
[    0.891346] pnp 00:09: [io  0x0000-0xffffffffffffffff disabled]
[    0.891348] pnp 00:09: [io  0x0500-0x057f]
[    0.891350] pnp 00:09: [mem 0xfed1c000-0xfed1ffff]
[    0.891351] pnp 00:09: [mem 0xfed20000-0xfed3ffff]
[    0.891353] pnp 00:09: [mem 0xfed40000-0xfed8ffff]
[    0.891435] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    0.891638] system 00:09: [io  0x0800-0x087f] has been reserved
[    0.891839] system 00:09: [io  0x0500-0x057f] has been reserved
[    0.892038] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.892235] system 00:09: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.892438] system 00:09: [mem 0xfed40000-0xfed8ffff] has been reserved
[    0.892640] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.892695] pnp 00:0a: [mem 0xfed00000-0xfed003ff]
[    0.892720] pnp 00:0a: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.892783] pnp 00:0b: [io  0x0060]
[    0.892785] pnp 00:0b: [io  0x0064]
[    0.892787] pnp 00:0b: [mem 0xfec00000-0xfec00fff]
[    0.892788] pnp 00:0b: [mem 0xfee00000-0xfee00fff]
[    0.892851] system 00:0b: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.893050] system 00:0b: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.893255] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.893666] pnp 00:0c: [io  0x0378-0x037f]
[    0.893676] pnp 00:0c: [irq 7]
[    0.893678] pnp 00:0c: [dma 0 disabled]
[    0.893800] pnp 00:0c: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.893838] pnp 00:0d: [mem 0xe0000000-0xefffffff]
[    0.893897] system 00:0d: [mem 0xe0000000-0xefffffff] has been reserved
[    0.894099] system 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.894273] pnp 00:0e: [io  0x0ca8]
[    0.894275] pnp 00:0e: [io  0x0cac]
[    0.894313] pnp 00:0e: Plug and Play ACPI device, IDs IPI0001 (active)
[    0.894413] pnp 00:0f: [mem 0x00000000-0x0009ffff]
[    0.894415] pnp 00:0f: [mem 0x000c0000-0x000cffff]
[    0.894417] pnp 00:0f: [mem 0x000e0000-0x000fffff]
[    0.894419] pnp 00:0f: [mem 0x00100000-0xbfffffff]
[    0.894421] pnp 00:0f: [mem 0xfed90000-0xffffffff]
[    0.894488] system 00:0f: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.894686] system 00:0f: [mem 0x000c0000-0x000cffff] could not be reserved
[    0.894885] system 00:0f: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.895083] system 00:0f: [mem 0x00100000-0xbfffffff] could not be reserved
[    0.895277] system 00:0f: [mem 0xfed90000-0xffffffff] could not be reserved
[    0.895482] system 00:0f: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.895618] pnp: PnP ACPI: found 16 devices
[    0.895815] ACPI: ACPI bus type pnp unregistered
[    0.903681] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 04-05] add_size 1000
[    0.903685] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 04-05] add_size 200000
[    0.903695] pci 0000:00:1c.4: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 03] add_size 200000
[    0.903707] pci 0000:00:1c.5: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000
[    0.903729] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.903731] pci 0000:00:1c.4: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.903733] pci 0000:00:1c.5: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.903735] pci 0000:00:1c.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.903740] pci 0000:00:1c.0: BAR 15: assigned [mem 0xc0000000-0xc01fffff 64bit pref]
[    0.904021] pci 0000:00:1c.4: BAR 15: assigned [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.904310] pci 0000:00:1c.5: BAR 15: assigned [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.904598] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
[    0.907521] pci 0000:09:00.0: PCI bridge to [bus 0a]
[    0.907723] pci 0000:00:01.0: PCI bridge to [bus 09-0a]
[    0.907922] pci 0000:00:03.0: PCI bridge to [bus 08]
[    0.908121] pci 0000:00:03.0:   bridge window [io  0xe000-0xefff]
[    0.908322] pci 0000:00:03.0:   bridge window [mem 0xfbe00000-0xfbefffff]
[    0.908524] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.908808] pci 0000:00:07.0: PCI bridge to [bus 07]
[    0.909013] pci 0000:00:09.0: PCI bridge to [bus 06]
[    0.909210] pci 0000:00:09.0:   bridge window [io  0xd000-0xdfff]
[    0.909414] pci 0000:00:09.0:   bridge window [mem 0xfba00000-0xfbdfffff]
[    0.909617] pci 0000:04:00.0: PCI bridge to [bus 05]
[    0.909820] pci 0000:04:00.0:   bridge window [mem 0xfb900000-0xfb9fffff]
[    0.910021] pci 0000:00:1c.0: PCI bridge to [bus 04-05]
[    0.910214] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    0.910425] pci 0000:00:1c.0:   bridge window [mem 0xfb900000-0xfb9fffff]
[    0.910627] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc01fffff 64bit pref]
[    0.910914] pci 0000:00:1c.4: PCI bridge to [bus 03]
[    0.911115] pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
[    0.911312] pci 0000:00:1c.4:   bridge window [mem 0xfb800000-0xfb8fffff]
[    0.911504] pci 0000:00:1c.4:   bridge window [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.911795] pci 0000:00:1c.5: PCI bridge to [bus 02]
[    0.912167] pci 0000:00:1c.5:   bridge window [io  0xb000-0xbfff]
[    0.912371] pci 0000:00:1c.5:   bridge window [mem 0xfb700000-0xfb7fffff]
[    0.912573] pci 0000:00:1c.5:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.912859] pci 0000:00:1e.0: PCI bridge to [bus 01]
[    0.913078] pci 0000:00:1c.0: enabling device (0106 -> 0107)
[    0.913321] pci 0000:00:1e.0: setting latency timer to 64
[    0.913330] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.913332] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.913334] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.913336] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.913338] pci_bus 0000:00: resource 8 [mem 0xc0000000-0xdfffffff]
[    0.913339] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfed8ffff]
[    0.913341] pci_bus 0000:08: resource 0 [io  0xe000-0xefff]
[    0.913343] pci_bus 0000:08: resource 1 [mem 0xfbe00000-0xfbefffff]
[    0.913345] pci_bus 0000:08: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.913347] pci_bus 0000:06: resource 0 [io  0xd000-0xdfff]
[    0.913349] pci_bus 0000:06: resource 1 [mem 0xfba00000-0xfbdfffff]
[    0.913351] pci_bus 0000:04: resource 0 [io  0x1000-0x1fff]
[    0.913353] pci_bus 0000:04: resource 1 [mem 0xfb900000-0xfb9fffff]
[    0.913355] pci_bus 0000:04: resource 2 [mem 0xc0000000-0xc01fffff 64bit pref]
[    0.913357] pci_bus 0000:05: resource 1 [mem 0xfb900000-0xfb9fffff]
[    0.913359] pci_bus 0000:03: resource 0 [io  0xc000-0xcfff]
[    0.913361] pci_bus 0000:03: resource 1 [mem 0xfb800000-0xfb8fffff]
[    0.913362] pci_bus 0000:03: resource 2 [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.913364] pci_bus 0000:02: resource 0 [io  0xb000-0xbfff]
[    0.913366] pci_bus 0000:02: resource 1 [mem 0xfb700000-0xfb7fffff]
[    0.913368] pci_bus 0000:02: resource 2 [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.913370] pci_bus 0000:01: resource 4 [io  0x0000-0x0cf7]
[    0.913372] pci_bus 0000:01: resource 5 [io  0x0d00-0xffff]
[    0.913374] pci_bus 0000:01: resource 6 [mem 0x000a0000-0x000bffff]
[    0.913376] pci_bus 0000:01: resource 7 [mem 0x000d0000-0x000dffff]
[    0.913378] pci_bus 0000:01: resource 8 [mem 0xc0000000-0xdfffffff]
[    0.913379] pci_bus 0000:01: resource 9 [mem 0xf0000000-0xfed8ffff]
[    0.913381] pci_bus 0000:fe: resource 4 [io  0x0000-0xffff]
[    0.913383] pci_bus 0000:fe: resource 5 [mem 0x00000000-0xffffffffff]
[    0.913386] pci_bus 0000:ff: resource 4 [io  0x0000-0xffff]
[    0.913388] pci_bus 0000:ff: resource 5 [mem 0x00000000-0xffffffffff]
[    0.913428] NET: Registered protocol family 2
[    0.914247] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.916016] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.916399] TCP: Hash tables configured (established 524288 bind 65536)
[    0.916625] TCP: reno registered
[    0.916853] UDP hash table entries: 16384 (order: 7, 524288 bytes)
[    0.917195] UDP-Lite hash table entries: 16384 (order: 7, 524288 bytes)
[    0.917609] NET: Registered protocol family 1
[    0.917918] RPC: Registered named UNIX socket transport module.
[    0.918112] RPC: Registered udp transport module.
[    0.918310] RPC: Registered tcp transport module.
[    0.918509] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.919111] pci 0000:09:00.0: rerouting interrupts for [8086:032c]
[    0.919319] pci 0000:08:00.0: Boot video device
[    0.919542] PCI: CLS 256 bytes, default 64
[    0.919578] Trying to unpack rootfs image as initramfs...
[    1.066230] Freeing initrd memory: 7416k freed
[    1.067828] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.068030] software IO TLB [mem 0xbb756000-0xbf755fff] (64MB) mapped at [ffff8800bb756000-ffff8800bf755fff]
[    1.068557] kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL does not work properly. Using workaround
[    1.070808] microcode: CPU0 sig=0x106a5, pf=0x1, revision=0x11
[    1.071010] microcode: CPU1 sig=0x106a5, pf=0x1, revision=0x11
[    1.071222] microcode: CPU2 sig=0x106a5, pf=0x1, revision=0x11
[    1.071435] microcode: CPU3 sig=0x106a5, pf=0x1, revision=0x11
[    1.071650] microcode: CPU4 sig=0x106a5, pf=0x1, revision=0x11
[    1.071863] microcode: CPU5 sig=0x106a5, pf=0x1, revision=0x11
[    1.072073] microcode: CPU6 sig=0x106a5, pf=0x1, revision=0x11
[    1.072283] microcode: CPU7 sig=0x106a5, pf=0x1, revision=0x11
[    1.072490] microcode: CPU8 sig=0x106a5, pf=0x1, revision=0x11
[    1.072703] microcode: CPU9 sig=0x106a5, pf=0x1, revision=0x11
[    1.072912] microcode: CPU10 sig=0x106a5, pf=0x1, revision=0x11
[    1.073122] microcode: CPU11 sig=0x106a5, pf=0x1, revision=0x11
[    1.073326] microcode: CPU12 sig=0x106a5, pf=0x1, revision=0x11
[    1.073541] microcode: CPU13 sig=0x106a5, pf=0x1, revision=0x11
[    1.073742] microcode: CPU14 sig=0x106a5, pf=0x1, revision=0x11
[    1.073952] microcode: CPU15 sig=0x106a5, pf=0x1, revision=0x11
[    1.074188] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.075208] sha1_ssse3: Using SSSE3 optimized SHA-1 implementation
[    1.075606] audit: initializing netlink socket (disabled)
[    1.075810] type=2000 audit(1346229776.906:1): initialized
[    1.116524] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.120781] VFS: Disk quotas dquot_6.5.2
[    1.121027] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.122088] NFS: Registering the id_resolver key type
[    1.122297] Key type id_resolver registered
[    1.122495] Key type id_legacy registered
[    1.122690] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    1.123223] Key type cifs.spnego registered
[    1.123420] NTFS driver 2.1.30 [Flags: R/W].
[    1.123752] fuse init (API version 7.20)
[    1.124077] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    1.124978] Btrfs loaded
[    1.125176] msgmni has been set to 32768
[    1.128833] async_tx: api initialized (async)
[    1.129068] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.129354] io scheduler noop registered
[    1.129549] io scheduler deadline registered
[    1.129742] io scheduler cfq registered (default)
[    1.130291] pcieport 0000:00:1c.0: irq 65 for MSI/MSI-X
[    1.130397] pcieport 0000:00:1c.4: irq 66 for MSI/MSI-X
[    1.130496] pcieport 0000:00:1c.5: irq 67 for MSI/MSI-X
[    1.130588] ioapic: probe of 0000:00:13.0 failed with error -22
[    1.130798] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.131022] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.131225] cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver version: 0.1
[    1.131514] cpcihp_generic: not configured, disabling.
[    1.131760] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    1.131962] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.132520] vga16fb: initializing
[    1.132523] vga16fb: mapped to 0xffff8800000a0000
[    1.342208] Console: switching to colour frame buffer device 80x30
[    1.352222] fb0: VGA16 VGA frame buffer device
[    1.352690] intel_idle: MWAIT substates: 0x1120
[    1.352713] intel_idle: v0.4 model 0x1A
[    1.352714] intel_idle: lapic_timer_reliable_states 0x2
[    1.352926] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    1.353611] ACPI: Power Button [PWRB]
[    1.354091] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.403079] ACPI: Power Button [PWRF]
[    1.427889] ACPI: Requesting acpi_cpufreq
[    1.460063] GHES: HEST is not enabled!
[    1.484350] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    1.508815] ioatdma 0000:00:16.0: irq 68 for MSI/MSI-X
[    1.509113] ioatdma 0000:00:16.1: irq 69 for MSI/MSI-X
[    1.509325] ioatdma 0000:00:16.2: irq 70 for MSI/MSI-X
[    1.509518] ioatdma 0000:00:16.3: irq 71 for MSI/MSI-X
[    1.509707] ioatdma 0000:00:16.4: irq 72 for MSI/MSI-X
[    1.509892] ioatdma 0000:00:16.5: irq 73 for MSI/MSI-X
[    1.510090] ioatdma 0000:00:16.6: irq 74 for MSI/MSI-X
[    1.510283] ioatdma 0000:00:16.7: irq 75 for MSI/MSI-X
[    1.510531] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.554337] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.598391] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.642326] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.686430] 00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.710108] Non-volatile memory driver v1.3
[    1.732945] Linux agpgart interface v0.103
[    1.755262] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    1.802433] Hangcheck: Using getrawmonotonic().
[    1.826214] [drm] Initialized drm 1.1.0 20060810
[    1.849761] [drm] radeon defaulting to kernel modesetting.
[    1.873023] [drm] radeon kernel modesetting enabled.
[    1.895969] checking generic (a0000 10000) vs hw (d0000000 10000000)
[    1.895971] fb: conflicting fb hw usage radeondrmfb vs VGA16 VGA - removing generic driver
[    1.964316] Console: switching to colour VGA+ 80x25
[    1.965326] [drm] initializing kernel modesetting (BARTS 0x1002:0x6738 0x174B:0x174B).
[    1.965652] [drm] register mmio base: 0xFBEC0000
[    1.965849] [drm] register mmio size: 131072
[    1.966113] ATOM BIOS: BARTS
[    1.966341] radeon 0000:08:00.0: VRAM: 1024M 0x0000000000000000 - 0x000000003FFFFFFF (1024M used)
[    1.966629] radeon 0000:08:00.0: GTT: 512M 0x0000000040000000 - 0x000000005FFFFFFF
[    1.966919] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[    1.967209] [drm] Detected VRAM RAM=1024M, BAR=256M
[    1.967408] [drm] RAM width 256bits DDR
[    1.967666] [TTM] Zone  kernel: Available graphics memory: 12336352 kiB
[    1.967871] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    1.968072] [TTM] Initializing pool allocator
[    1.968274] [TTM] Initializing DMA pool allocator
[    1.968523] [drm] radeon: 1024M of VRAM memory ready
[    1.968723] [drm] radeon: 512M of GTT memory ready.
[    1.968929] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    1.969131] [drm] Driver supports precise vblank timestamp query.
[    1.969373] radeon 0000:08:00.0: irq 76 for MSI/MSI-X
[    1.969383] radeon 0000:08:00.0: radeon: using MSI.
[    1.969604] [drm] radeon: irq initialized.
[    1.969802] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    1.970575] [drm] probing gen 2 caps for device 8086:340a = 2/0
[    1.970775] [drm] enabling PCIE gen 2 link speeds, disable with radeon.pcie_gen2=0
[    1.971276] [drm] Loading BARTS Microcode
[    1.974167] [drm] PCIE GART of 512M enabled (table at 0x0000000000040000).
[    1.974505] radeon 0000:08:00.0: WB enabled
[    1.974696] radeon 0000:08:00.0: fence driver on ring 0 use gpu addr 0x0000000040000c00 and cpu addr 0xffff8803304ebc00
[    1.991860] [drm] ring test on 0 succeeded in 3 usecs
[    1.992353] [drm] ib test on ring 0 succeeded in 0 usecs
[    1.993001] [drm] Radeon Display Connectors
[    1.993190] [drm] Connector 0:
[    1.993377] [drm]   DP-1
[    1.993563] [drm]   HPD4
[    1.993749] [drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438 0x643c 0x643c
[    1.994018] [drm]   Encoders:
[    1.994201] [drm]     DFP1: INTERNAL_UNIPHY2
[    1.994389] [drm] Connector 1:
[    1.994580] [drm]   HDMI-A-1
[    1.994765] [drm]   HPD3
[    1.994950] [drm]   DDC: 0x6460 0x6460 0x6464 0x6464 0x6468 0x6468 0x646c 0x646c
[    1.995234] [drm]   Encoders:
[    1.995424] [drm]     DFP2: INTERNAL_UNIPHY2
[    1.995616] [drm] Connector 2:
[    1.995804] [drm]   DVI-D-1
[    1.995989] [drm]   HPD1
[    1.996174] [drm]   DDC: 0x6480 0x6480 0x6484 0x6484 0x6488 0x6488 0x648c 0x648c
[    1.996445] [drm]   Encoders:
[    1.996629] [drm]     DFP3: INTERNAL_UNIPHY1
[    1.996821] [drm] Connector 3:
[    1.997005] [drm]   DVI-I-1
[    1.997189] [drm]   HPD6
[    1.997373] [drm]   DDC: 0x6470 0x6470 0x6474 0x6474 0x6478 0x6478 0x647c 0x647c
[    1.997643] [drm]   Encoders:
[    1.997832] [drm]     DFP4: INTERNAL_UNIPHY
[    1.998020] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    1.998311] [drm] Internal thermal controller with fan control
[    1.999683] [drm] radeon: power management initialized
[    2.068335] tsc: Refined TSC clocksource calibration: 2266.746 MHz
[    2.104914] [drm] fb mappable at 0xD0142000
[    2.105050] [drm] vram apper at 0xD0000000
[    2.105178] [drm] size 16384000
[    2.105304] [drm] fb depth is 24
[    2.105430] [drm]    pitch is 10240
[    2.105612] fbcon: radeondrmfb (fb0) is primary device
[    2.431736] Console: switching to colour frame buffer device 240x75
[    2.438656] fb0: radeondrmfb frame buffer device
[    2.438681] drm: registered panic notifier
[    2.438706] [drm] Initialized radeon 2.21.0 20080528 for 0000:08:00.0 on minor 0
[    2.438842] usbcore: registered new interface driver udl
[    2.440532] brd: module loaded
[    2.441459] loop: module loaded
[    2.441692] Loading iSCSI transport class v2.0-870.
[    2.441836] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[    2.441907] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[    2.441961] megasas: 00.00.06.15-rc1 Mon. Mar. 19 17:00:00 PDT 2012
[    2.442013] mpt2sas version 13.100.00.00 loaded
[    2.442164] ahci 0000:00:1f.2: version 3.0
[    2.442225] ahci 0000:00:1f.2: irq 77 for MSI/MSI-X
[    2.442261] ahci: SSS flag set, parallel bus scan disabled
[    2.442335] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    2.442377] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc ems sxs 
[    2.442426] ahci 0000:00:1f.2: setting latency timer to 64
[    2.474722] scsi0 : ahci
[    2.474844] scsi1 : ahci
[    2.474950] scsi2 : ahci
[    2.475051] scsi3 : ahci
[    2.475140] scsi4 : ahci
[    2.475234] scsi5 : ahci
[    2.475290] ata1: SATA max UDMA/133 abar m2048@0xfb6fc000 port 0xfb6fc100 irq 77
[    2.475333] ata2: SATA max UDMA/133 abar m2048@0xfb6fc000 port 0xfb6fc180 irq 77
[    2.475375] ata3: SATA max UDMA/133 abar m2048@0xfb6fc000 port 0xfb6fc200 irq 77
[    2.475413] ata4: SATA max UDMA/133 abar m2048@0xfb6fc000 port 0xfb6fc280 irq 77
[    2.475455] ata5: SATA max UDMA/133 abar m2048@0xfb6fc000 port 0xfb6fc300 irq 77
[    2.475497] ata6: SATA max UDMA/133 abar m2048@0xfb6fc000 port 0xfb6fc380 irq 77
[    2.475786] tun: Universal TUN/TAP device driver, 1.6
[    2.475832] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    2.476002] PPP generic driver version 2.4.2
[    2.476067] Fusion MPT base driver 3.04.20
[    2.476090] Copyright (c) 1999-2008 LSI Corporation
[    2.476120] Fusion MPT SPI Host driver 3.04.20
[    2.476163] Fusion MPT FC Host driver 3.04.20
[    2.476203] Fusion MPT SAS Host driver 3.04.20
[    2.476355] mptbase: ioc0: Initiating bringup
[    2.793787] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.796098] ata1.00: ATA-7: Maxtor 6V320F0, VA111900, max UDMA/133
[    2.796147] ata1.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.799586] ata1.00: configured for UDMA/133
[    2.799762] scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6V320F0   VA11 PQ: 0 ANSI: 5
[    2.799971] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.800033] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    2.800178] sd 0:0:0:0: [sda] Write Protect is off
[    2.800207] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.800245] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.822109]  sda: sda1 sda2
[    2.822426] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.079966] ioc0: LSISAS1068E B3: Capabilities={Initiator}
[    3.116587] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.118882] ata2.00: ATA-7: Maxtor 6V320F0, VA111900, max UDMA/133
[    3.118930] ata2.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    3.124004] ata2.00: configured for UDMA/133
[    3.126002] scsi 1:0:0:0: Direct-Access     ATA      Maxtor 6V320F0   VA11 PQ: 0 ANSI: 5
[    3.128038] sd 1:0:0:0: [sdb] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    3.128057] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    3.131960] sd 1:0:0:0: [sdb] Write Protect is off
[    3.133886] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.133917] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.157220]  sdb: sdb1 sdb2
[    3.159363] sd 1:0:0:0: [sdb] Attached SCSI disk
[    3.446036] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.448262] ata3.00: ATAPI: ATAPI   iHAS324   A, BL1P, max UDMA/100
[    3.450917] ata3.00: configured for UDMA/100
[    3.454450] scsi 2:0:0:0: CD-ROM            ATAPI    iHAS324   A      BL1P PQ: 0 ANSI: 5
[    3.459872] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    3.461845] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.463937] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    3.464018] sr 2:0:0:0: Attached scsi generic sg2 type 5
[    3.785471] ata4: SATA link down (SStatus 0 SControl 300)
[    4.104940] ata5: SATA link down (SStatus 0 SControl 300)
[    4.424410] ata6: SATA link down (SStatus 0 SControl 300)
[   13.412615] scsi6 : ioc0: LSISAS1068E B3, FwRev=011b0000h, Ports=1, MaxQ=277, IRQ=32
[   13.453177] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 8, phy 1, sas_addr 0x816f9b3796d4dac1
[   13.458224] scsi 6:0:0:0: Direct-Access     ATA      Hitachi HDS72202 A20N PQ: 0 ANSI: 5
[   13.461691] sd 6:0:0:0: Attached scsi generic sg3 type 0
[   13.464328] sd 6:0:0:0: [sdc] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   13.466315] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 9, phy 2, sas_addr 0x816f9b4881d8f4c1
[   13.471397] scsi 6:0:1:0: Direct-Access     ATA      Hitachi HDS72202 A20N PQ: 0 ANSI: 5
[   13.474911] sd 6:0:1:0: Attached scsi generic sg4 type 0
[   13.477625] sd 6:0:1:0: [sdd] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   13.479686] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 10, phy 3, sas_addr 0x816f9b40abd2efc1
[   13.484909] scsi 6:0:2:0: Direct-Access     ATA      Hitachi HDS72202 A20N PQ: 0 ANSI: 5
[   13.488501] sd 6:0:2:0: Attached scsi generic sg5 type 0
[   13.491259] sd 6:0:2:0: [sde] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   13.493378] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 11, phy 5, sas_addr 0x816f9b4598b701c2
[   13.498665] scsi 6:0:3:0: Direct-Access     ATA      Hitachi HDS72202 A20N PQ: 0 ANSI: 5
[   13.502276] sd 6:0:3:0: Attached scsi generic sg6 type 0
[   13.505048] sd 6:0:3:0: [sdf] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   13.507209] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 12, phy 6, sas_addr 0x816f9b45a1b6e8c1
[   13.512581] scsi 6:0:4:0: Direct-Access     ATA      Hitachi HDS72202 A20N PQ: 0 ANSI: 5
[   13.516292] sd 6:0:4:0: Attached scsi generic sg7 type 0
[   13.519193] sd 6:0:4:0: [sdg] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   13.521489] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 13, phy 7, sas_addr 0x816f9b40a7c1dec1
[   13.527044] scsi 6:0:5:0: Direct-Access     ATA      Hitachi HDS72202 A20N PQ: 0 ANSI: 5
[   13.530840] sd 6:0:5:0: Attached scsi generic sg8 type 0
[   13.533849] sd 6:0:5:0: [sdh] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   13.536250] Fusion MPT misc device (ioctl) driver 3.04.20
[   13.538644] mptctl: Registered with Fusion MPT base driver
[   13.541027] mptctl: /dev/mptctl @ (major,minor=10,220)
[   13.543389] Fusion MPT LAN driver 3.04.20
[   13.545734] mptlan: ioc0: PortNum=0, ProtocolFlags=09h (ItlB)
[   13.548097] mptlan: ioc0: Hmmm... LAN protocol seems to be disabled on this adapter port!
[   13.550707] aoe: AoE v47 initialised.
[   13.553161] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   13.555609] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[   13.555616] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[   13.558102] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[   13.564474] ehci_hcd 0000:00:1a.7: debug port 1
[   13.566922] ehci_hcd 0000:00:1a.7: cache line size of 256 is not supported
[   13.566944] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfb6f8000
[   13.579215] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[   13.581658] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   13.584089] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   13.586514] usb usb1: Product: EHCI Host Controller
[   13.588902] usb usb1: Manufacturer: Linux 3.6.0-rc3-andres-00177-gc182ae4 ehci_hcd
[   13.591310] usb usb1: SerialNumber: 0000:00:1a.7
[   13.593818] hub 1-0:1.0: USB hub found
[   13.596211] hub 1-0:1.0: 6 ports detected
[   13.598676] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   13.598683] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   13.601079] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[   13.607342] ehci_hcd 0000:00:1d.7: debug port 1
[   13.609706] ehci_hcd 0000:00:1d.7: cache line size of 256 is not supported
[   13.609722] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfb6fa000
[   13.619145] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   13.621492] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   13.623841] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   13.626180] usb usb2: Product: EHCI Host Controller
[   13.628487] usb usb2: Manufacturer: Linux 3.6.0-rc3-andres-00177-gc182ae4 ehci_hcd
[   13.630807] usb usb2: SerialNumber: 0000:00:1d.7
[   13.633220] hub 2-0:1.0: USB hub found
[   13.635520] hub 2-0:1.0: 6 ports detected
[   13.637882] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   13.640171] uhci_hcd: USB Universal Host Controller Interface driver
[   13.642467] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[   13.642474] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   13.644765] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[   13.647073] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00009400
[   13.649362] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   13.651605] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   13.653848] usb usb3: Product: UHCI Host Controller
[   13.656072] usb usb3: Manufacturer: Linux 3.6.0-rc3-andres-00177-gc182ae4 uhci_hcd
[   13.658305] usb usb3: SerialNumber: 0000:00:1a.0
[   13.660653] hub 3-0:1.0: USB hub found
[   13.662895] hub 3-0:1.0: 2 ports detected
[   13.665208] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[   13.665216] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[   13.667498] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[   13.669773] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00009480
[   13.672002] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[   13.674204] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   13.676398] usb usb4: Product: UHCI Host Controller
[   13.678555] usb usb4: Manufacturer: Linux 3.6.0-rc3-andres-00177-gc182ae4 uhci_hcd
[   13.680720] usb usb4: SerialNumber: 0000:00:1a.1
[   13.682964] hub 4-0:1.0: USB hub found
[   13.685075] hub 4-0:1.0: 2 ports detected
[   13.687244] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[   13.687251] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[   13.689373] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[   13.691464] uhci_hcd 0000:00:1a.2: irq 19, io base 0x00009800
[   13.693549] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[   13.695581] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   13.697604] usb usb5: Product: UHCI Host Controller
[   13.699599] usb usb5: Manufacturer: Linux 3.6.0-rc3-andres-00177-gc182ae4 uhci_hcd
[   13.701592] usb usb5: SerialNumber: 0000:00:1a.2
[   13.703663] hub 5-0:1.0: USB hub found
[   13.705609] hub 5-0:1.0: 2 ports detected
[   13.707623] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   13.707628] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   13.709616] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[   13.711550] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00009880
[   13.713477] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[   13.715342] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   13.717210] usb usb6: Product: UHCI Host Controller
[   13.719059] usb usb6: Manufacturer: Linux 3.6.0-rc3-andres-00177-gc182ae4 uhci_hcd
[   13.720914] usb usb6: SerialNumber: 0000:00:1d.0
[   13.722887] hub 6-0:1.0: USB hub found
[   13.724737] hub 6-0:1.0: 2 ports detected
[   13.726664] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   13.726671] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   13.728556] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[   13.730424] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00009c00
[   13.732280] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[   13.734110] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   13.735938] usb usb7: Product: UHCI Host Controller
[   13.737747] usb usb7: Manufacturer: Linux 3.6.0-rc3-andres-00177-gc182ae4 uhci_hcd
[   13.739591] usb usb7: SerialNumber: 0000:00:1d.1
[   13.741524] hub 7-0:1.0: USB hub found
[   13.743384] hub 7-0:1.0: 2 ports detected
[   13.745284] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   13.745291] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   13.745845] sd 6:0:0:0: [sdc] Write Protect is off
[   13.745847] sd 6:0:0:0: [sdc] Mode Sense: 73 00 00 08
[   13.748573] sd 6:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   13.750811] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[   13.752696] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000a000
[   13.754573] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[   13.756442] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   13.758298] usb usb8: Product: UHCI Host Controller
[   13.759610] sd 6:0:1:0: [sdd] Write Protect is off
[   13.759612] sd 6:0:1:0: [sdd] Mode Sense: 73 00 00 08
[   13.762001] usb usb8: Manufacturer: Linux 3.6.0-rc3-andres-00177-gc182ae4 uhci_hcd
[   13.762336] sd 6:0:1:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   13.765785] usb usb8: SerialNumber: 0000:00:1d.2
[   13.767792] hub 8-0:1.0: USB hub found
[   13.769699] hub 8-0:1.0: 2 ports detected
[   13.771648] Initializing USB Mass Storage driver...
[   13.773573] usbcore: registered new interface driver usb-storage
[   13.774775] sd 6:0:2:0: [sde] Write Protect is off
[   13.774777] sd 6:0:2:0: [sde] Mode Sense: 73 00 00 08
[   13.777365] USB Mass Storage support registered.
[   13.777513] sd 6:0:2:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   13.781221] usbcore: registered new interface driver libusual
[   13.783187] i8042: PNP: No PS/2 controller found. Probing ports directly.
[   13.786169] sd 6:0:3:0: [sdf] Write Protect is off
[   13.788106] sd 6:0:3:0: [sdf] Mode Sense: 73 00 00 08
[   13.789184] serio: i8042 KBD port at 0x60,0x64 irq 1
[   13.790840] sd 6:0:3:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   13.793080] serio: i8042 AUX port at 0x60,0x64 irq 12
[   13.795173] mousedev: PS/2 mouse device common for all mice
[   13.797324] rtc_cmos 00:03: RTC can wake from S4
[   13.799431] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[   13.801423] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[   13.801842] sd 6:0:4:0: [sdg] Write Protect is off
[   13.801844] sd 6:0:4:0: [sdg] Mode Sense: 73 00 00 08
[   13.804564] sd 6:0:4:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   13.807450] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[   13.809766] md: linear personality registered for level -1
[   13.811764] md: raid0 personality registered for level 0
[   13.811985] sd 6:0:5:0: [sdh] Write Protect is off
[   13.811987] sd 6:0:5:0: [sdh] Mode Sense: 73 00 00 08
[   13.814727] sd 6:0:5:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   13.817772] md: raid1 personality registered for level 1
[   13.819794] md: raid10 personality registered for level 10
[   13.821809] md: raid6 personality registered for level 6
[   13.823839] md: raid5 personality registered for level 5
[   13.825858] md: raid4 personality registered for level 4
[   13.827848] md: multipath personality registered for level -4
[   13.829850] md: faulty personality registered for level -5
[   13.831960] device-mapper: uevent: version 1.0.3
[   13.834138] device-mapper: ioctl: 4.23.0-ioctl (2012-07-25) initialised: dm-devel@redhat.com
[   13.836305] device-mapper: multipath: version 1.5.0 loaded
[   13.838301] device-mapper: multipath round-robin: version 1.0.0 loaded
[   13.840302] device-mapper: multipath queue-length: version 0.1.0 loaded
[   13.842326] device-mapper: multipath service-time: version 0.2.0 loaded
[   13.844441] device-mapper: dm-log-userspace: version 1.1.0 loaded
[   13.846436] EDAC MC: Ver: 3.0.0
[   13.849006] EDAC MC1: Giving out device to 'i7core_edac.c' 'i7 core #1': DEV 0000:fe:03.0
[   13.851024] EDAC PCI0: Giving out device to module 'i7core_edac' controller 'EDAC PCI controller': DEV '0000:fe:03.0' (POLLED)
[   13.853402] EDAC MC0: Giving out device to 'i7core_edac.c' 'i7 core #0': DEV 0000:ff:03.0
[   13.855604] EDAC PCI1: Giving out device to module 'i7core_edac' controller 'EDAC PCI controller': DEV '0000:ff:03.0' (POLLED)
[   13.857888] EDAC i7core: Driver loaded, 2 memory controller(s) found.
[   13.860221] cpuidle: using governor ladder
[   13.862563] cpuidle: using governor menu
[   13.864792] usbcore: registered new interface driver usbhid
[   13.866892] usbhid: USB HID core driver
[   13.869070] oprofile: using NMI interrupt.
[   13.871203] Netfilter messages via NETLINK v0.30.
[   13.873288] nfnl_acct: registering with nfnetlink.
[   13.875412] IPv4 over IPv4 tunneling driver
[   13.877569] TCP: cubic registered
[   13.879635] Initializing XFRM netlink socket
[   13.881817] NET: Registered protocol family 10
[   13.884108] NET: Registered protocol family 17
[   13.886191] NET: Registered protocol family 15
[   13.889020] Bridge firewalling registered
[   13.891037] Ebtables v2.0 registered
[   13.893130] Key type dns_resolver registered
[   13.895962] PM: Hibernation image not present or could not be loaded.
[   13.895974] registered taskstats version 1
[   13.900341]   Magic number: 8:722:726
[   13.902407] block loop6: hash matches
[   13.904457] netpoll: netconsole: local port 4444
[   13.906492] netpoll: netconsole: local IP 192.168.224.176
[   13.908446] netpoll: netconsole: interface 'eth0'
[   13.910466] netpoll: netconsole: remote port 4444
[   13.912451] netpoll: netconsole: remote IP 192.168.224.203
[   13.914350] netpoll: netconsole: remote ethernet address 00:21:86:60:5d:d6
[   13.916297] netpoll: netconsole: eth0 doesn't exist, aborting
[   13.918173] netconsole: cleaning up
[   13.920456] rtc_cmos 00:03: setting system clock to 2012-08-29 08:43:10 UTC (1346229790)
[   14.203422] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[   14.205281] EDD information not available.
[   14.217010]  sdg: unknown partition table
[   14.219121]  sdh: unknown partition table
[   14.219136]  sdf: unknown partition table
[   14.219147]  sdc: unknown partition table
[   14.223209]  sde: unknown partition table
[   14.224611]  sdd: unknown partition table
[   14.334856] usb 2-5: new high-speed USB device number 2 using ehci_hcd
[   14.482866] usb 2-5: New USB device found, idVendor=046b, idProduct=ff01
[   14.485223] usb 2-5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   14.487498] usb 2-5: Product: Generic Hub
[   14.489833] usb 2-5: Manufacturer: American Megatrends Inc.
[   14.492247] usb 2-5: SerialNumber: serial
[   14.495533] hub 2-5:1.0: USB hub found
[   14.498051] hub 2-5:1.0: 3 ports detected
[   14.503584] sd 6:0:4:0: [sdg] Attached SCSI disk
[   14.505878] sd 6:0:3:0: [sdf] Attached SCSI disk
[   14.507237] sd 6:0:0:0: [sdc] Attached SCSI disk
[   14.509887] sd 6:0:2:0: [sde] Attached SCSI disk
[   14.511455] sd 6:0:1:0: [sdd] Attached SCSI disk
[   14.513599] sd 6:0:5:0: [sdh] Attached SCSI disk
[   14.521011] Freeing unused kernel memory: 900k freed
[   14.523234] Write protecting the kernel read-only data: 18432k
[   14.536317] Freeing unused kernel memory: 1844k freed
[   14.545784] Freeing unused kernel memory: 1152k freed
[   14.643546] udevd[241]: starting version 175
[   14.687466] e1000e: Intel(R) PRO/1000 Network Driver - 2.0.0-k
[   14.690361] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[   14.692555] e1000e 0000:03:00.0: Disabling ASPM L0s L1
[   14.694821] e1000e 0000:03:00.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[   14.696719] e1000e 0000:03:00.0: irq 78 for MSI/MSI-X
[   14.696730] e1000e 0000:03:00.0: irq 79 for MSI/MSI-X
[   14.696739] e1000e 0000:03:00.0: irq 80 for MSI/MSI-X
[   14.734461] usb 3-1: new low-speed USB device number 2 using uhci_hcd
[   14.810423] e1000e 0000:03:00.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:e0:81:c2:23:45
[   14.812870] e1000e 0000:03:00.0: eth0: Intel(R) PRO/1000 Network Connection
[   14.815258] e1000e 0000:03:00.0: eth0: MAC: 3, PHY: 8, PBA No: FFFFFF-0FF
[   14.817489] e1000e 0000:02:00.0: Disabling ASPM L0s L1
[   14.820052] e1000e 0000:02:00.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[   14.822038] e1000e 0000:02:00.0: irq 81 for MSI/MSI-X
[   14.822046] e1000e 0000:02:00.0: irq 82 for MSI/MSI-X
[   14.822052] e1000e 0000:02:00.0: irq 83 for MSI/MSI-X
[   14.915368] usb 3-1: New USB device found, idVendor=17ef, idProduct=6009
[   14.917691] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   14.919737] usb 3-1: Product: ThinkPad USB Keyboard with TrackPoint
[   14.921941] usb 3-1: Manufacturer: Lite-On Technology Corp.
[   14.933831] e1000e 0000:02:00.0: eth1: (PCI Express:2.5GT/s:Width x1) 00:e0:81:c2:23:44
[   14.935881] e1000e 0000:02:00.0: eth1: Intel(R) PRO/1000 Network Connection
[   14.938097] e1000e 0000:02:00.0: eth1: MAC: 3, PHY: 8, PBA No: FFFFFF-0FF
[   15.037452] usb 2-5.1: new high-speed USB device number 3 using ehci_hcd
[   15.137995] usb 2-5.1: New USB device found, idVendor=046b, idProduct=ff10
[   15.140180] usb 2-5.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   15.142275] usb 2-5.1: Product: Virtual Keyboard and Mouse
[   15.144442] usb 2-5.1: Manufacturer: American Megatrends Inc.
[   15.146556] usb 2-5.1: SerialNumber: serial
[   15.150185] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1:1.0/input/input2
[   15.152263] hid-generic 0003:046B:FF10.0003: input,hidraw0: USB HID v1.10 Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1d.7-5.1/input0
[   15.155016] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1:1.1/input/input3
[   15.157685] hid-generic 0003:046B:FF10.0004: input,hidraw1: USB HID v1.10 Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1d.7-5.1/input1
[   15.284017] md: md0 stopped.
[   15.287950] md: bind<sda1>
[   15.290905] md: bind<sdb1>
[   15.295421] bio: create slab <bio-1> at 1
[   15.297877] md/raid1:md0: active with 2 out of 2 mirrors
[   15.300736] created bitmap (239 pages) for device md0
[   15.310854] md0: bitmap initialized from disk: read 15 pages, set 0 of 487920 bits
[   15.317699] md0: detected capacity change from 0 to 1998520320
[   15.322355]  md0: unknown partition table
[   15.371678] md: md1 stopped.
[   15.375425] md: bind<sda2>
[   15.378360] md: bind<sdb2>
[   15.383936] md/raid1:md1: active with 2 out of 2 mirrors
[   15.385904] created bitmap (140 pages) for device md1
[   15.392035] md1: bitmap initialized from disk: read 9 pages, set 0 of 286102 bits
[   15.419731] md1: detected capacity change from 0 to 149999779840
[   15.423890]  md1: unknown partition table
[   15.488561] md: md3 stopped.
[   15.517679] md: bind<sde>
[   15.523526] md: bind<sdd>
[   15.526767] md: bind<sdg>
[   15.532301] md: bind<sdf>
[   15.536258] md: bind<sdh>
[   15.539871] md: bind<sdc>
[   15.545535] md/raid10:md3: active with 6 out of 6 devices
[   15.550766] created bitmap (11 pages) for device md3
[   15.554264] md3: bitmap initialized from disk: read 1 pages, set 0 of 22357 bits
[   15.578278] md3: detected capacity change from 0 to 6001196335104
[   15.608673]  md3: unknown partition table
[   15.876424] EXT4-fs (md1): mounted filesystem with ordered data mode. Opts: (null)
[   20.570587] udevd[603]: starting version 175
[   23.151662] EXT4-fs (md1): re-mounted. Opts: errors=remount-ro
[   24.343791] snd_hda_intel 0000:08:00.1: irq 84 for MSI/MSI-X
[   24.397623] input: HD-Audio Generic HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:03.0/0000:08:00.1/sound/card0/input4
[   26.415706] EXT4-fs (dm-3): mounted filesystem with ordered data mode. Opts: acl
[   26.478503] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: acl
[   26.890052] EXT4-fs (dm-4): mounted filesystem with ordered data mode. Opts: acl
[   26.999530] EXT4-fs (md0): mounted filesystem without journal. Opts: (null)
[   29.733402] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   34.372976] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   34.376512] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   58.069257] device virbr1-nic entered promiscuous mode
[   58.747042] ip_tables: (C) 2000-2006 Netfilter Core Team
[   59.742032] IPv6: ADDRCONF(NETDEV_UP): virbr1: link is not ready
[   61.417141] device virbr0-nic entered promiscuous mode
[   61.543526] IPv6: ADDRCONF(NETDEV_UP): virbr0: link is not ready
[   71.574150] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   77.748054] postgres (3026): /proc/3026/oom_adj is deprecated, please use /proc/3026/oom_score_adj instead.
[  270.274790] usb 2-3: new high-speed USB device number 4 using ehci_hcd
[  270.398363] usb 2-3: New USB device found, idVendor=0424, idProduct=2514
[  270.398368] usb 2-3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[  270.398798] hub 2-3:1.0: USB hub found
[  270.399038] hub 2-3:1.0: 4 ports detected
[  270.680920] usb 2-3.1: new low-speed USB device number 5 using ehci_hcd
[  270.782625] usb 2-3.1: New USB device found, idVendor=046d, idProduct=c03d
[  270.782629] usb 2-3.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  270.782633] usb 2-3.1: Product: USB-PS/2 Optical Mouse
[  270.782635] usb 2-3.1: Manufacturer: Logitech
[  270.786768] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1d.7/usb2/2-3/2-3.1/2-3.1:1.0/input/input5
[  270.787414] hid-generic 0003:046D:C03D.0005: input,hidraw2: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.7-3.1/input0
[  270.990424] usb 2-3.2: new full-speed USB device number 6 using ehci_hcd
[  271.092517] usb 2-3.2: New USB device found, idVendor=04f9, idProduct=0182
[  271.092522] usb 2-3.2: New USB device strings: Mfr=0, Product=0, SerialNumber=3
[  271.092525] usb 2-3.2: SerialNumber: 000J6J815887

--Boundary-00=_S31PQ8LoqFLmOJE
Content-Type: text/plain;
  charset="UTF-8";
  name="lsusb-3.6-rc3"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lsusb-3.6-rc3"

Bus 002 Device 004: ID 0424:2514 Standard Microsystems Corp. USB 2.0 Hub
Bus 002 Device 002: ID 046b:ff01 American Megatrends, Inc. 
Bus 003 Device 002: ID 17ef:6009 Lenovo ThinkPad Keyboard with TrackPoint
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 008 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 005: ID 046d:c03d Logitech, Inc. M-BT96a Pilot Optical Mouse
Bus 002 Device 006: ID 04f9:0182 Brother Industries, Ltd Composite Device
Bus 002 Device 003: ID 046b:ff10 American Megatrends, Inc. Virtual Keyboard and Mouse

--Boundary-00=_S31PQ8LoqFLmOJE
Content-Type: text/plain;
  charset="UTF-8";
  name="lsusb-3.5-rc6-196"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lsusb-3.5-rc6-196"

Bus 002 Device 002: ID 0424:2514 Standard Microsystems Corp. USB 2.0 Hub
Bus 002 Device 003: ID 046b:ff01 American Megatrends, Inc. 
Bus 003 Device 002: ID 17ef:6009 Lenovo ThinkPad Keyboard with TrackPoint
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 008 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 004: ID 046d:c03d Logitech, Inc. M-BT96a Pilot Optical Mouse
Bus 002 Device 005: ID 04f9:0182 Brother Industries, Ltd Composite Device
Bus 002 Device 006: ID 046b:ff10 American Megatrends, Inc. Virtual Keyboard and Mouse

--Boundary-00=_S31PQ8LoqFLmOJE
Content-Type: text/x-mpsub;
  charset="UTF-8";
  name="config-3.5.0-rc6-andres-00196-gfdb1335"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="config-3.5.0-rc6-andres-00196-gfdb1335"

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
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
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
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION="-andres"
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_FHANDLE=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
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
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=18
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
CONFIG_CGROUP_MEM_RES_CTLR=y
# CONFIG_CGROUP_MEM_RES_CTLR_SWAP is not set
# CONFIG_CGROUP_MEM_RES_CTLR_KMEM is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
CONFIG_MM_OWNER=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
CONFIG_OPTPROBES=y
CONFIG_UPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_USER_RETURN_NOTIFIER=y
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
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_DEV_THROTTLING is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_CFQ_GROUP_IOSCHED is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
CONFIG_INLINE_READ_UNLOCK=y
# CONFIG_INLINE_READ_UNLOCK_BH is not set
CONFIG_INLINE_READ_UNLOCK_IRQ=y
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
CONFIG_INLINE_WRITE_UNLOCK=y
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
# CONFIG_X86_X2APIC is not set
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
# CONFIG_KVM_CLOCK is not set
# CONFIG_KVM_GUEST is not set
# CONFIG_PARAVIRT is not set
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=y
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=64
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_I8K is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
# CONFIG_AMD_NUMA is not set
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
# CONFIG_HWPOISON_INJECT is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
# CONFIG_FRONTSWAP is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_EFI=y
# CONFIG_EFI_STUB is not set
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_PM_TEST_SUSPEND=y
CONFIG_CAN_PM_TRACE=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_SBS=y
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
CONFIG_ACPI_BGRT=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
# CONFIG_ACPI_APEI_PCIEAER is not set
# CONFIG_ACPI_APEI_MEMORY_FAILURE is not set
# CONFIG_ACPI_APEI_EINJ is not set
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=y
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
CONFIG_INTEL_IDLE=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_FAKE is not set
CONFIG_HOTPLUG_PCI_ACPI=y
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
CONFIG_HOTPLUG_PCI_CPCI=y
# CONFIG_HOTPLUG_PCI_CPCI_ZT5550 is not set
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=y
CONFIG_HOTPLUG_PCI_SHPC=y
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=y
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_IP_MROUTE=y
# CONFIG_IP_MROUTE_MULTIPLE_TABLES is not set
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_INET_UDP_DIAG=y
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
CONFIG_TCP_CONG_CUBIC=y
# CONFIG_TCP_CONG_WESTWOOD is not set
# CONFIG_TCP_CONG_HTCP is not set
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_PRIVACY=y
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_BEET is not set
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
# CONFIG_IPV6_SIT is not set
# CONFIG_IPV6_TUNNEL is not set
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_ACCT=y
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_ZONES=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
# CONFIG_NF_CONNTRACK_TIMEOUT is not set
# CONFIG_NF_CONNTRACK_TIMESTAMP is not set
# CONFIG_NF_CT_PROTO_DCCP is not set
# CONFIG_NF_CT_PROTO_SCTP is not set
# CONFIG_NF_CT_PROTO_UDPLITE is not set
# CONFIG_NF_CONNTRACK_AMANDA is not set
# CONFIG_NF_CONNTRACK_FTP is not set
# CONFIG_NF_CONNTRACK_H323 is not set
# CONFIG_NF_CONNTRACK_IRC is not set
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
# CONFIG_NF_CONNTRACK_SNMP is not set
# CONFIG_NF_CONNTRACK_PPTP is not set
# CONFIG_NF_CONNTRACK_SANE is not set
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
# CONFIG_NF_CT_NETLINK_TIMEOUT is not set
# CONFIG_NETFILTER_TPROXY is not set
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m
# CONFIG_NETFILTER_XT_SET is not set

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_AUDIT=m
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_CT=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
# CONFIG_NETFILTER_XT_TARGET_HMARK is not set
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
# CONFIG_NETFILTER_XT_TARGET_LOG is not set
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_TEE=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_CPU=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ECN=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_NFACCT=m
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
CONFIG_IP_SET=m
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=m
CONFIG_IP_SET_BITMAP_IPMAC=m
CONFIG_IP_SET_BITMAP_PORT=m
CONFIG_IP_SET_HASH_IP=m
CONFIG_IP_SET_HASH_IPPORT=m
CONFIG_IP_SET_HASH_IPPORTIP=m
CONFIG_IP_SET_HASH_IPPORTNET=m
CONFIG_IP_SET_HASH_NET=m
CONFIG_IP_SET_HASH_NETPORT=m
CONFIG_IP_SET_HASH_NETIFACE=m
CONFIG_IP_SET_LIST_SET=m
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_RPFILTER=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
# CONFIG_NF_NAT_FTP is not set
# CONFIG_NF_NAT_IRC is not set
CONFIG_NF_NAT_TFTP=m
# CONFIG_NF_NAT_AMANDA is not set
# CONFIG_NF_NAT_PPTP is not set
# CONFIG_NF_NAT_H323 is not set
CONFIG_NF_NAT_SIP=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RPFILTER=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_BRIDGE_NF_EBTABLES=y
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_ULOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
# CONFIG_NET_SCH_HFSC is not set
# CONFIG_NET_SCH_PRIO is not set
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFB is not set
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_GRED is not set
# CONFIG_NET_SCH_DSMARK is not set
# CONFIG_NET_SCH_NETEM is not set
# CONFIG_NET_SCH_DRR is not set
# CONFIG_NET_SCH_MQPRIO is not set
# CONFIG_NET_SCH_CHOKE is not set
# CONFIG_NET_SCH_QFQ is not set
# CONFIG_NET_SCH_CODEL is not set
# CONFIG_NET_SCH_FQ_CODEL is not set
# CONFIG_NET_SCH_INGRESS is not set
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
# CONFIG_NET_EMATCH_NBYTE is not set
# CONFIG_NET_EMATCH_U32 is not set
# CONFIG_NET_EMATCH_META is not set
# CONFIG_NET_EMATCH_TEXT is not set
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
# CONFIG_NET_ACT_GACT is not set
# CONFIG_NET_ACT_MIRRED is not set
# CONFIG_NET_ACT_IPT is not set
# CONFIG_NET_ACT_NAT is not set
# CONFIG_NET_ACT_PEDIT is not set
# CONFIG_NET_ACT_SIMP is not set
# CONFIG_NET_ACT_SKBEDIT is not set
# CONFIG_NET_ACT_CSUM is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_NET_DROP_MONITOR is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE="radeon/R700_rlc.bin radeon/BARTS_pfp.bin radeon/BARTS_mc.bin radeon/BARTS_me.bin radeon/BTC_rlc.bin"
CONFIG_EXTRA_FIRMWARE_DIR="/lib/firmware"
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=65536
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=y
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
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
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_SCSI_BNX2X_FCOE is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
CONFIG_MEGARAID_MAILBOX=y
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=y
CONFIG_SCSI_MPT2SAS=y
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT2SAS_LOGGING=y
# CONFIG_SCSI_UFSHCD is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_ISCI is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
# CONFIG_SCSI_VIRTIO is not set
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
# CONFIG_SCSI_DH_HP_SW is not set
# CONFIG_SCSI_DH_EMC is not set
# CONFIG_SCSI_DH_ALUA is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARASAN_CF is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_ACPI=y
CONFIG_ATA_GENERIC=y
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=y
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
CONFIG_MULTICORE_RAID456=y
CONFIG_MD_MULTIPATH=y
CONFIG_MD_FAULTY=y
CONFIG_BLK_DEV_DM=y
CONFIG_DM_DEBUG=y
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=y
# CONFIG_DM_THIN_PROVISIONING is not set
CONFIG_DM_MIRROR=y
CONFIG_DM_RAID=y
CONFIG_DM_LOG_USERSPACE=y
CONFIG_DM_ZERO=y
CONFIG_DM_MULTIPATH=y
CONFIG_DM_MULTIPATH_QL=y
CONFIG_DM_MULTIPATH_ST=y
CONFIG_DM_DELAY=y
CONFIG_DM_UEVENT=y
# CONFIG_DM_FLAKEY is not set
# CONFIG_DM_VERITY is not set
# CONFIG_TARGET_CORE is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
CONFIG_FUSION_LAN=y
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
CONFIG_DUMMY=y
# CONFIG_EQUALIZER is not set
CONFIG_NET_FC=y
CONFIG_MII=m
# CONFIG_IFB is not set
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_TUN=y
CONFIG_VETH=y
CONFIG_VIRTIO_NET=y
# CONFIG_ARCNET is not set

#
# CAIF transport drivers
#
CONFIG_ETHERNET=y
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
# CONFIG_NET_VENDOR_ALTEON is not set
# CONFIG_NET_VENDOR_AMD is not set
# CONFIG_NET_VENDOR_ATHEROS is not set
# CONFIG_NET_VENDOR_BROADCOM is not set
# CONFIG_NET_VENDOR_BROCADE is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
# CONFIG_NET_VENDOR_CHELSIO is not set
# CONFIG_NET_VENDOR_CISCO is not set
# CONFIG_DNET is not set
# CONFIG_NET_VENDOR_DEC is not set
# CONFIG_NET_VENDOR_DLINK is not set
# CONFIG_NET_VENDOR_EMULEX is not set
# CONFIG_NET_VENDOR_EXAR is not set
# CONFIG_NET_VENDOR_HP is not set
CONFIG_NET_VENDOR_INTEL=y
CONFIG_E100=m
CONFIG_E1000=m
CONFIG_E1000E=m
CONFIG_IGB=m
CONFIG_IGB_DCA=y
# CONFIG_IGB_PTP is not set
CONFIG_IGBVF=m
# CONFIG_IXGB is not set
# CONFIG_IXGBE is not set
CONFIG_IXGBEVF=m
CONFIG_NET_VENDOR_I825XX=y
CONFIG_ZNET=y
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
# CONFIG_NET_VENDOR_MARVELL is not set
# CONFIG_NET_VENDOR_MELLANOX is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_NET_VENDOR_MYRI is not set
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
# CONFIG_NET_VENDOR_OKI is not set
# CONFIG_ETHOC is not set
# CONFIG_NET_PACKET_ENGINE is not set
# CONFIG_NET_VENDOR_QLOGIC is not set
# CONFIG_NET_VENDOR_REALTEK is not set
# CONFIG_NET_VENDOR_RDC is not set
# CONFIG_NET_VENDOR_SEEQ is not set
# CONFIG_NET_VENDOR_SILAN is not set
# CONFIG_NET_VENDOR_SIS is not set
# CONFIG_SFC is not set
# CONFIG_NET_VENDOR_SMSC is not set
# CONFIG_NET_VENDOR_STMICRO is not set
# CONFIG_NET_VENDOR_SUN is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
# CONFIG_NET_VENDOR_TI is not set
# CONFIG_NET_VENDOR_VIA is not set
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_PHYLIB is not set
CONFIG_PPP=y
# CONFIG_PPP_BSDCOMP is not set
# CONFIG_PPP_DEFLATE is not set
CONFIG_PPP_FILTER=y
# CONFIG_PPP_MPPE is not set
CONFIG_PPP_MULTILINK=y
# CONFIG_PPPOE is not set
# CONFIG_PPP_ASYNC is not set
# CONFIG_PPP_SYNC_TTY is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=y

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_IPHETH is not set
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_OMAP4 is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
# CONFIG_JOYSTICK_ZHENHUA is not set
# CONFIG_JOYSTICK_AS5011 is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_GTCO is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_EGALAX is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_ILI210X is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
# CONFIG_TOUCHSCREEN_MAX11801 is not set
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_PIXCIR is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_TPS6507X is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_MPU3050 is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_UINPUT is not set
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_CMA3000 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=0
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=48
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
CONFIG_I2C_SIS5595=y
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_INTEL_MID is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
# CONFIG_HSI is not set

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
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_SMB347 is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
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
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_S5M_CORE is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_CS5535 is not set
CONFIG_LPC_SCH=y
# CONFIG_LPC_ICH is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_AMD64 is not set
CONFIG_AGP_INTEL=y
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_USB=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_TTM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=y
CONFIG_DRM_RADEON_KMS=y
# CONFIG_DRM_NOUVEAU is not set

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_DRM_I2C_SIL164 is not set
# CONFIG_DRM_I810 is not set
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
CONFIG_DRM_UDL=y
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_STUB_POULSBO is not set
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_WMT_GE_ROPS is not set
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
CONFIG_FB_ASILIANT=y
CONFIG_FB_IMSTT=y
CONFIG_FB_VGA16=y
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LP855X is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=256
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=m
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=m
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_KCTL_JACK=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=m
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
CONFIG_SND_CTXFI=m
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_PREALLOC_SIZE=64
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=2
CONFIG_SND_HDA_INPUT_JACK=y
# CONFIG_SND_HDA_PATCH_LOADER is not set
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_HDMI=y
CONFIG_SND_HDA_CODEC_CIRRUS=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CA0110=y
CONFIG_SND_HDA_CODEC_CA0132=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
# CONFIG_SND_HDA_POWER_SAVE is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
# CONFIG_SND_USB_UA101 is not set
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set
# CONFIG_SND_USB_US122L is not set
# CONFIG_SND_USB_6FIRE is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_PRODIKEYS is not set
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_EZKEY=y
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LOGITECH=y
# CONFIG_HID_LOGITECH_DJ is not set
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB_CBAF=y
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_EHCI_HCD_PLATFORM=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_CHIPIDEA is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
# CONFIG_USB_UAS is not set
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set

#
# USB Physical Layer drivers
#
# CONFIG_USB_ISP1301 is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=y
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
CONFIG_EDAC_I5400=y
CONFIG_EDAC_I7CORE=y
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
# CONFIG_EDAC_SBRIDGE is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
CONFIG_INTEL_IOATDMA=y
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
CONFIG_DCA=y
CONFIG_AUXDISPLAY=y
# CONFIG_UIO is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
CONFIG_IRQ_REMAP=y

#
# Remoteproc drivers (EXPERIMENTAL)
#

#
# Rpmsg drivers (EXPERIMENTAL)
#
CONFIG_VIRT_DRIVERS=y
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_VME_BUS is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_EFI_VARS is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_ISCSI_IBFT is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT23=y
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
# CONFIG_XFS_DEBUG is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
CONFIG_ECRYPT_FS=y
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
# CONFIG_PSTORE_RAM is not set
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=y
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V2=y
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
CONFIG_NFS_V4_1=y
CONFIG_PNFS_FILE_LAYOUT=y
CONFIG_PNFS_BLOCK=m
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFSD=y
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
# CONFIG_NFSD_FAULT_INJECTION is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_SUNRPC_BACKCHANNEL=y
CONFIG_RPCSEC_GSS_KRB5=y
# CONFIG_SUNRPC_DEBUG is not set
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=y
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DFS_UPCALL is not set
# CONFIG_CIFS_ACL is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-15"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_LOCK_STAT is not set
CONFIG_TRACE_IRQFLAGS=y
# CONFIG_DEBUG_ATOMIC_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_INFO_REDUCED is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_LKDTM is not set
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
# CONFIG_DEBUG_PAGEALLOC is not set
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
# CONFIG_EVENT_POWER_TRACING_DEPRECATED is not set
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENT=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_MMIOTRACE=y
# CONFIG_MMIOTRACE_TEST is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_TEST_KSTRTOX is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_DEBUG_SET_MODULE_RONX=y
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
# CONFIG_INTEL_TXT is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_ASYNC_PQ=y
CONFIG_ASYNC_RAID6_RECOV=y
CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=y
CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=y
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
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

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
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA=y
# CONFIG_CRYPTO_CAMELLIA_X86_64 is not set
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_MMU_AUDIT is not set
CONFIG_VHOST_NET=y
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
# CONFIG_AVERAGE is not set
# CONFIG_CORDIC is not set
CONFIG_DDR=y

--Boundary-00=_S31PQ8LoqFLmOJE
Content-Type: text/x-mpsub;
  charset="UTF-8";
  name="config-3.6.0-rc3-andres-00177-gc182ae4"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="config-3.6.0-rc3-andres-00177-gc182ae4"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.6.0-rc1 Kernel Configuration
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
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
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
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION="-andres"
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_FHANDLE=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
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
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=18
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
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
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
CONFIG_OPTPROBES=y
CONFIG_UPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_USER_RETURN_NOTIFIER=y
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
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_DEV_THROTTLING is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_CFQ_GROUP_IOSCHED is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
CONFIG_INLINE_READ_UNLOCK=y
# CONFIG_INLINE_READ_UNLOCK_BH is not set
CONFIG_INLINE_READ_UNLOCK_IRQ=y
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
CONFIG_INLINE_WRITE_UNLOCK=y
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
# CONFIG_X86_X2APIC is not set
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
# CONFIG_KVM_CLOCK is not set
# CONFIG_KVM_GUEST is not set
# CONFIG_PARAVIRT is not set
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=y
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=64
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_I8K is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
# CONFIG_AMD_NUMA is not set
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
# CONFIG_HWPOISON_INJECT is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
# CONFIG_FRONTSWAP is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_EFI=y
# CONFIG_EFI_STUB is not set
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_PM_TEST_SUSPEND=y
CONFIG_PM_SLEEP_DEBUG=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_SBS=y
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
CONFIG_ACPI_BGRT=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
# CONFIG_ACPI_APEI_PCIEAER is not set
# CONFIG_ACPI_APEI_MEMORY_FAILURE is not set
# CONFIG_ACPI_APEI_EINJ is not set
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=y
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_FAKE is not set
CONFIG_HOTPLUG_PCI_ACPI=y
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
CONFIG_HOTPLUG_PCI_CPCI=y
# CONFIG_HOTPLUG_PCI_CPCI_ZT5550 is not set
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=y
CONFIG_HOTPLUG_PCI_SHPC=y
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=y
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_IP_MROUTE=y
# CONFIG_IP_MROUTE_MULTIPLE_TABLES is not set
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_INET_UDP_DIAG=y
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
CONFIG_TCP_CONG_CUBIC=y
# CONFIG_TCP_CONG_WESTWOOD is not set
# CONFIG_TCP_CONG_HTCP is not set
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_PRIVACY=y
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_BEET is not set
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
# CONFIG_IPV6_SIT is not set
# CONFIG_IPV6_TUNNEL is not set
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_ACCT=y
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_ZONES=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
# CONFIG_NF_CONNTRACK_TIMEOUT is not set
# CONFIG_NF_CONNTRACK_TIMESTAMP is not set
# CONFIG_NF_CT_PROTO_DCCP is not set
# CONFIG_NF_CT_PROTO_SCTP is not set
# CONFIG_NF_CT_PROTO_UDPLITE is not set
# CONFIG_NF_CONNTRACK_AMANDA is not set
# CONFIG_NF_CONNTRACK_FTP is not set
# CONFIG_NF_CONNTRACK_H323 is not set
# CONFIG_NF_CONNTRACK_IRC is not set
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
# CONFIG_NF_CONNTRACK_SNMP is not set
# CONFIG_NF_CONNTRACK_PPTP is not set
# CONFIG_NF_CONNTRACK_SANE is not set
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
# CONFIG_NF_CT_NETLINK_TIMEOUT is not set
# CONFIG_NETFILTER_NETLINK_QUEUE_CT is not set
# CONFIG_NETFILTER_TPROXY is not set
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m
# CONFIG_NETFILTER_XT_SET is not set

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_AUDIT=m
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_CT=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
# CONFIG_NETFILTER_XT_TARGET_HMARK is not set
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
# CONFIG_NETFILTER_XT_TARGET_LOG is not set
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_TEE=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_CPU=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ECN=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_NFACCT=m
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
CONFIG_IP_SET=m
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=m
CONFIG_IP_SET_BITMAP_IPMAC=m
CONFIG_IP_SET_BITMAP_PORT=m
CONFIG_IP_SET_HASH_IP=m
CONFIG_IP_SET_HASH_IPPORT=m
CONFIG_IP_SET_HASH_IPPORTIP=m
CONFIG_IP_SET_HASH_IPPORTNET=m
CONFIG_IP_SET_HASH_NET=m
CONFIG_IP_SET_HASH_NETPORT=m
CONFIG_IP_SET_HASH_NETIFACE=m
CONFIG_IP_SET_LIST_SET=m
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_RPFILTER=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
# CONFIG_NF_NAT_FTP is not set
# CONFIG_NF_NAT_IRC is not set
CONFIG_NF_NAT_TFTP=m
# CONFIG_NF_NAT_AMANDA is not set
# CONFIG_NF_NAT_PPTP is not set
# CONFIG_NF_NAT_H323 is not set
CONFIG_NF_NAT_SIP=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RPFILTER=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_BRIDGE_NF_EBTABLES=y
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_ULOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
# CONFIG_NET_SCH_HFSC is not set
# CONFIG_NET_SCH_PRIO is not set
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFB is not set
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_GRED is not set
# CONFIG_NET_SCH_DSMARK is not set
# CONFIG_NET_SCH_NETEM is not set
# CONFIG_NET_SCH_DRR is not set
# CONFIG_NET_SCH_MQPRIO is not set
# CONFIG_NET_SCH_CHOKE is not set
# CONFIG_NET_SCH_QFQ is not set
# CONFIG_NET_SCH_CODEL is not set
# CONFIG_NET_SCH_FQ_CODEL is not set
# CONFIG_NET_SCH_INGRESS is not set
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
# CONFIG_NET_EMATCH_NBYTE is not set
# CONFIG_NET_EMATCH_U32 is not set
# CONFIG_NET_EMATCH_META is not set
# CONFIG_NET_EMATCH_TEXT is not set
# CONFIG_NET_EMATCH_IPSET is not set
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
# CONFIG_NET_ACT_GACT is not set
# CONFIG_NET_ACT_MIRRED is not set
# CONFIG_NET_ACT_IPT is not set
# CONFIG_NET_ACT_NAT is not set
# CONFIG_NET_ACT_PEDIT is not set
# CONFIG_NET_ACT_SIMP is not set
# CONFIG_NET_ACT_SKBEDIT is not set
# CONFIG_NET_ACT_CSUM is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_NET_DROP_MONITOR is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE="radeon/R700_rlc.bin radeon/BARTS_pfp.bin radeon/BARTS_mc.bin radeon/BARTS_me.bin radeon/BTC_rlc.bin"
CONFIG_EXTRA_FIRMWARE_DIR="/lib/firmware"
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=65536
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=y
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
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
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_SCSI_BNX2X_FCOE is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
CONFIG_MEGARAID_MAILBOX=y
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=y
CONFIG_SCSI_MPT2SAS=y
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT2SAS_LOGGING=y
# CONFIG_SCSI_UFSHCD is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_ISCI is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
# CONFIG_SCSI_VIRTIO is not set
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
# CONFIG_SCSI_DH_HP_SW is not set
# CONFIG_SCSI_DH_EMC is not set
# CONFIG_SCSI_DH_ALUA is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARASAN_CF is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_ACPI=y
CONFIG_ATA_GENERIC=y
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=y
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
CONFIG_MULTICORE_RAID456=y
CONFIG_MD_MULTIPATH=y
CONFIG_MD_FAULTY=y
CONFIG_BLK_DEV_DM=y
CONFIG_DM_DEBUG=y
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=y
# CONFIG_DM_THIN_PROVISIONING is not set
CONFIG_DM_MIRROR=y
CONFIG_DM_RAID=y
CONFIG_DM_LOG_USERSPACE=y
CONFIG_DM_ZERO=y
CONFIG_DM_MULTIPATH=y
CONFIG_DM_MULTIPATH_QL=y
CONFIG_DM_MULTIPATH_ST=y
CONFIG_DM_DELAY=y
CONFIG_DM_UEVENT=y
# CONFIG_DM_FLAKEY is not set
# CONFIG_DM_VERITY is not set
# CONFIG_TARGET_CORE is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
CONFIG_FUSION_LAN=y
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
CONFIG_DUMMY=y
# CONFIG_EQUALIZER is not set
CONFIG_NET_FC=y
CONFIG_MII=m
# CONFIG_IFB is not set
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_TUN=y
CONFIG_VETH=y
CONFIG_VIRTIO_NET=y
# CONFIG_ARCNET is not set

#
# CAIF transport drivers
#
CONFIG_ETHERNET=y
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
# CONFIG_NET_VENDOR_ALTEON is not set
# CONFIG_NET_VENDOR_AMD is not set
# CONFIG_NET_VENDOR_ATHEROS is not set
# CONFIG_NET_VENDOR_BROADCOM is not set
# CONFIG_NET_VENDOR_BROCADE is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
# CONFIG_NET_VENDOR_CHELSIO is not set
# CONFIG_NET_VENDOR_CISCO is not set
# CONFIG_DNET is not set
# CONFIG_NET_VENDOR_DEC is not set
# CONFIG_NET_VENDOR_DLINK is not set
# CONFIG_NET_VENDOR_EMULEX is not set
# CONFIG_NET_VENDOR_EXAR is not set
# CONFIG_NET_VENDOR_HP is not set
CONFIG_NET_VENDOR_INTEL=y
CONFIG_E100=m
CONFIG_E1000=m
CONFIG_E1000E=m
CONFIG_IGB=m
CONFIG_IGB_DCA=y
# CONFIG_IGB_PTP is not set
CONFIG_IGBVF=m
# CONFIG_IXGB is not set
# CONFIG_IXGBE is not set
CONFIG_IXGBEVF=m
CONFIG_NET_VENDOR_I825XX=y
CONFIG_ZNET=y
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
# CONFIG_NET_VENDOR_MARVELL is not set
# CONFIG_NET_VENDOR_MELLANOX is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_NET_VENDOR_MYRI is not set
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
# CONFIG_NET_VENDOR_OKI is not set
# CONFIG_ETHOC is not set
# CONFIG_NET_PACKET_ENGINE is not set
# CONFIG_NET_VENDOR_QLOGIC is not set
# CONFIG_NET_VENDOR_REALTEK is not set
# CONFIG_NET_VENDOR_RDC is not set
# CONFIG_NET_VENDOR_SEEQ is not set
# CONFIG_NET_VENDOR_SILAN is not set
# CONFIG_NET_VENDOR_SIS is not set
# CONFIG_SFC is not set
# CONFIG_NET_VENDOR_SMSC is not set
# CONFIG_NET_VENDOR_STMICRO is not set
# CONFIG_NET_VENDOR_SUN is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
# CONFIG_NET_VENDOR_TI is not set
# CONFIG_NET_VENDOR_VIA is not set
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_PHYLIB is not set
CONFIG_PPP=y
# CONFIG_PPP_BSDCOMP is not set
# CONFIG_PPP_DEFLATE is not set
CONFIG_PPP_FILTER=y
# CONFIG_PPP_MPPE is not set
CONFIG_PPP_MULTILINK=y
# CONFIG_PPPOE is not set
# CONFIG_PPP_ASYNC is not set
# CONFIG_PPP_SYNC_TTY is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=y

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_IPHETH is not set
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_OMAP4 is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
# CONFIG_JOYSTICK_ZHENHUA is not set
# CONFIG_JOYSTICK_AS5011 is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_GTCO is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_EGALAX is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_ILI210X is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
# CONFIG_TOUCHSCREEN_MAX11801 is not set
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MMS114 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_PIXCIR is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_TPS6507X is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_MPU3050 is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_UINPUT is not set
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_CMA3000 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=0
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=48
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
CONFIG_I2C_SIS5595=y
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_INTEL_MID is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
# CONFIG_HSI is not set

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
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
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
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_CS5535 is not set
CONFIG_LPC_SCH=y
# CONFIG_LPC_ICH is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_AMD64 is not set
CONFIG_AGP_INTEL=y
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_USB=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_TTM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=y
CONFIG_DRM_RADEON_KMS=y
# CONFIG_DRM_NOUVEAU is not set

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_DRM_I2C_SIL164 is not set
# CONFIG_DRM_I810 is not set
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
CONFIG_DRM_UDL=y
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_STUB_POULSBO is not set
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_WMT_GE_ROPS is not set
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
CONFIG_FB_ASILIANT=y
CONFIG_FB_IMSTT=y
CONFIG_FB_VGA16=y
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LP855X is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=256
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=m
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=m
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_KCTL_JACK=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=m
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
CONFIG_SND_CTXFI=m
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_PREALLOC_SIZE=64
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=1
CONFIG_SND_HDA_INPUT_JACK=y
# CONFIG_SND_HDA_PATCH_LOADER is not set
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_HDMI=y
CONFIG_SND_HDA_CODEC_CIRRUS=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CA0110=y
CONFIG_SND_HDA_CODEC_CA0132=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
# CONFIG_SND_HDA_POWER_SAVE is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
# CONFIG_SND_USB_UA101 is not set
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set
# CONFIG_SND_USB_US122L is not set
# CONFIG_SND_USB_6FIRE is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_PRODIKEYS is not set
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_EZKEY=y
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=y
# CONFIG_HID_LOGITECH_DJ is not set
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB_CBAF=y
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_EHCI_HCD_PLATFORM=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_CHIPIDEA is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
# CONFIG_USB_UAS is not set
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set

#
# USB Physical Layer drivers
#
# CONFIG_USB_ISP1301 is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=y
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
CONFIG_EDAC_I5400=y
CONFIG_EDAC_I7CORE=y
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
# CONFIG_EDAC_SBRIDGE is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
CONFIG_INTEL_IOATDMA=y
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
CONFIG_DCA=y
CONFIG_AUXDISPLAY=y
# CONFIG_UIO is not set
# CONFIG_VFIO is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
CONFIG_IRQ_REMAP=y

#
# Remoteproc drivers (EXPERIMENTAL)
#

#
# Rpmsg drivers (EXPERIMENTAL)
#
CONFIG_VIRT_DRIVERS=y
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_EFI_VARS is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_ISCSI_IBFT is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT23=y
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
# CONFIG_XFS_DEBUG is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
CONFIG_ECRYPT_FS=y
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_FTRACE is not set
# CONFIG_PSTORE_RAM is not set
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=y
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V2=y
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
# CONFIG_NFS_SWAP is not set
CONFIG_NFS_V4_1=y
CONFIG_PNFS_FILE_LAYOUT=m
CONFIG_PNFS_BLOCK=m
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFSD=y
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
# CONFIG_NFSD_FAULT_INJECTION is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_SUNRPC_BACKCHANNEL=y
CONFIG_RPCSEC_GSS_KRB5=y
# CONFIG_SUNRPC_DEBUG is not set
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=y
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DFS_UPCALL is not set
# CONFIG_CIFS_ACL is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-15"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_LOCK_STAT is not set
CONFIG_TRACE_IRQFLAGS=y
# CONFIG_DEBUG_ATOMIC_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_INFO_REDUCED is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_LKDTM is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
# CONFIG_DEBUG_PAGEALLOC is not set
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
# CONFIG_EVENT_POWER_TRACING_DEPRECATED is not set
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENT=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_MMIOTRACE=y
# CONFIG_MMIOTRACE_TEST is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_TEST_KSTRTOX is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_DEBUG_SET_MODULE_RONX=y
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
# CONFIG_INTEL_TXT is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_ASYNC_PQ=y
CONFIG_ASYNC_RAID6_RECOV=y
CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=y
CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=y
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
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

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
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA=y
# CONFIG_CRYPTO_CAMELLIA_X86_64 is not set
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_MMU_AUDIT is not set
CONFIG_VHOST_NET=y
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
# CONFIG_CORDIC is not set
CONFIG_DDR=y

--Boundary-00=_S31PQ8LoqFLmOJE
Content-Type: text/plain;
  charset="UTF-8";
  name="dmesg-3.5-rc6-196"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg-3.5-rc6-196"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.5.0-rc6-andres-00196-gfdb1335 (andres@awork2) (gcc version 4.7.1 (Debian 4.7.1-5) ) #139 SMP Wed Jul 18 12:09:33 CEST 2012
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.5.0-rc6-andres-00196-gfdb1335 root=UUID=58ba7a04-b424-4a46-acbe-b6ca208f61e1 ro clocksource=hpet netconsole=4444@192.168.224.176/eth0,4444@192.168.224.203/00:21:86:60:5d:d6
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009c3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009c400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bf76ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bf770000-0x00000000bf77dfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bf77e000-0x00000000bf7cffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf7d0000-0x00000000bf7dffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf7ec000-0x00000000bfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffa00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000063fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: empty empty/S7020, BIOS 'V1.03  ' 03/09/2010
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.5.0-rc6-andres-00196-gfdb1335 (andres@awork2) (gcc version 4.7.1 (Debian 4.7.1-5) ) #139 SMP Wed Jul 18 12:09:33 CEST 2012
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.5.0-rc6-andres-00196-gfdb1335 root=UUID=58ba7a04-b424-4a46-acbe-b6ca208f61e1 ro clocksource=hpet netconsole=4444@192.168.224.176/eth0,4444@192.168.224.203/00:21:86:60:5d:d6
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009c3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009c400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bf76ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bf770000-0x00000000bf77dfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bf77e000-0x00000000bf7cffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf7d0000-0x00000000bf7dffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf7ec000-0x00000000bfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffa00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000063fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: empty empty/S7020, BIOS 'V1.03  ' 03/09/2010
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x640000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D7FFF write-protect
[    0.000000]   D8000-DFFFF uncachable
[    0.000000]   E0000-E7FFF write-protect
[    0.000000]   E8000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FC00000000 write-back
[    0.000000]   1 base 0400000000 mask FE00000000 write-back
[    0.000000]   2 base 0600000000 mask FFC0000000 write-back
[    0.000000]   3 base 00C0000000 mask FFC0000000 uncachable
[    0.000000]   4 base 00BF800000 mask FFFF800000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xbf800000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xbf770 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000ff780-0x000ff78f] mapped at [ffff8800000ff780]
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000095000] 95000 size 28672
[    0.000000] init_memory_mapping: [mem 0x00000000-0xbf76ffff]
[    0.000000]  [mem 0x00000000-0xbf5fffff] page 2M
[    0.000000]  [mem 0xbf600000-0xbf76ffff] page 4k
[    0.000000] kernel direct mapping tables up to 0xbf76ffff @ [mem 0x1fa00000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x63fffffff]
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x640000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D7FFF write-protect
[    0.000000]   D8000-DFFFF uncachable
[    0.000000]   E0000-E7FFF write-protect
[    0.000000]   E8000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FC00000000 write-back
[    0.000000]   1 base 0400000000 mask FE00000000 write-back
[    0.000000]   2 base 0600000000 mask FFC0000000 write-back
[    0.000000]   3 base 00C0000000 mask FFC0000000 uncachable
[    0.000000]   4 base 00BF800000 mask FFFF800000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xbf800000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xbf770 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000ff780-0x000ff78f] mapped at [ffff8800000ff780]
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000095000] 95000 size 28672
[    0.000000] init_memory_mapping: [mem 0x00000000-0xbf76ffff]
[    0.000000]  [mem 0x00000000-0xbf5fffff] page 2M
[    0.000000]  [mem 0xbf600000-0xbf76ffff] page 4k
[    0.000000] kernel direct mapping tables up to 0xbf76ffff @ [mem 0x1fa00000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x63fffffff]
[    0.000000]  [mem 0x100000000-0x63fffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x63fffffff @ [mem 0xbf756000-0xbf76ffff]
[    0.000000] RAMDISK: [mem 0x37176000-0x378b2fff]
[    0.000000] ACPI: RSDP 00000000000fa840 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000bf770100 0006C (v01 030910 XSDT1851 20100309 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000bf770290 000F4 (v04 030910 FACP1851 20100309 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000bf770540 06537 (v02  7020_ 7020_001 00000001 INTL 20051117)
[    0.000000] ACPI: FACS 00000000bf77e000 00040
[    0.000000] ACPI: APIC 00000000bf770390 0011E (v02 030910 APIC1851 20100309 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000bf7704b0 0003C (v01 030910 OEMMCFG  20100309 MSFT 00000097)
[    0.000000] ACPI: SPMI 00000000bf7704f0 00041 (v05 030910 OEMSPMI  20100309 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000bf77e040 00082 (v01 030910 OEMB1851 20100309 MSFT 00000097)
[    0.000000] ACPI: SRAT 00000000bf77a540 001D0 (v02 030910 OEMSRAT  00000001 INTL 00000001)
[    0.000000] ACPI: HPET 00000000bf77a710 00038 (v01 030910 OEMHPET  20100309 MSFT 00000097)
[    0.000000] ACPI: DMAR 00000000bf77e0d0 00128 (v01    AMI  OEMDMAR 00000001 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000bf781e00 00363 (v01 DpgPmm    CpuPm 00000012 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x06 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x07 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x10 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x12 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x14 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x16 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x11 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x13 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x15 -> Node 1
[    0.000000]  [mem 0x100000000-0x63fffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x63fffffff @ [mem 0xbf756000-0xbf76ffff]
[    0.000000] RAMDISK: [mem 0x37176000-0x378b2fff]
[    0.000000] ACPI: RSDP 00000000000fa840 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000bf770100 0006C (v01 030910 XSDT1851 20100309 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000bf770290 000F4 (v04 030910 FACP1851 20100309 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000bf770540 06537 (v02  7020_ 7020_001 00000001 INTL 20051117)
[    0.000000] ACPI: FACS 00000000bf77e000 00040
[    0.000000] ACPI: APIC 00000000bf770390 0011E (v02 030910 APIC1851 20100309 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000bf7704b0 0003C (v01 030910 OEMMCFG  20100309 MSFT 00000097)
[    0.000000] ACPI: SPMI 00000000bf7704f0 00041 (v05 030910 OEMSPMI  20100309 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000bf77e040 00082 (v01 030910 OEMB1851 20100309 MSFT 00000097)
[    0.000000] ACPI: SRAT 00000000bf77a540 001D0 (v02 030910 OEMSRAT  00000001 INTL 00000001)
[    0.000000] ACPI: HPET 00000000bf77a710 00038 (v01 030910 OEMHPET  20100309 MSFT 00000097)
[    0.000000] ACPI: DMAR 00000000bf77e0d0 00128 (v01    AMI  OEMDMAR 00000001 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000bf781e00 00363 (v01 DpgPmm    CpuPm 00000012 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x06 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x07 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x10 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x12 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x14 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x16 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x11 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x13 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x15 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x17 -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x0009ffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00100000-0xbfffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x33fffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x340000000-0x63fffffff]
[    0.000000] NUMA: Node 0 [mem 0x00000000-0x0009ffff] + [mem 0x00100000-0xbfffffff] -> [mem 0x00000000-0xbfffffff]
[    0.000000] NUMA: Node 0 [mem 0x00000000-0xbfffffff] + [mem 0x100000000-0x33fffffff] -> [mem 0x00000000-0x33fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x33fffffff]
[    0.000000]   NODE_DATA [mem 0x33fffc000-0x33fffffff]
[    0.000000] Initmem setup node 1 [mem 0x340000000-0x63fffffff]
[    0.000000]   NODE_DATA [mem 0x63fffc000-0x63fffffff]
[    0.000000]  [ffffea0000000000-ffffea000cffffff] PMD -> [ffff880333e00000-ffff88033fdfffff] on node 0
[    0.000000]  [ffffea000d000000-ffffea0018ffffff] PMD -> [ffff880633600000-ffff88063f5fffff] on node 1
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x63fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009bfff]
[    0.000000]   node   0: [mem 0x00100000-0xbf76ffff]
[    0.000000]   node   0: [mem 0x100000000-0x33fffffff]
[    0.000000]   node   1: [mem 0x340000000-0x63fffffff]
[    0.000000] On node 0 totalpages: 3143420
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 7 pages reserved
[    0.000000]   DMA zone: 3909 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 763824 pages, LIFO batch:31
[    0.000000]   Normal zone: 36864 pages used for memmap
[    0.000000]   Normal zone: 2322432 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 3145728
[    0.000000] SRAT: PXM 1 -> APIC 0x17 -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x0009ffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00100000-0xbfffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x33fffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x340000000-0x63fffffff]
[    0.000000] NUMA: Node 0 [mem 0x00000000-0x0009ffff] + [mem 0x00100000-0xbfffffff] -> [mem 0x00000000-0xbfffffff]
[    0.000000] NUMA: Node 0 [mem 0x00000000-0xbfffffff] + [mem 0x100000000-0x33fffffff] -> [mem 0x00000000-0x33fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x33fffffff]
[    0.000000]   NODE_DATA [mem 0x33fffc000-0x33fffffff]
[    0.000000] Initmem setup node 1 [mem 0x340000000-0x63fffffff]
[    0.000000]   NODE_DATA [mem 0x63fffc000-0x63fffffff]
[    0.000000]  [ffffea0000000000-ffffea000cffffff] PMD -> [ffff880333e00000-ffff88033fdfffff] on node 0
[    0.000000]  [ffffea000d000000-ffffea0018ffffff] PMD -> [ffff880633600000-ffff88063f5fffff] on node 1
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x63fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009bfff]
[    0.000000]   node   0: [mem 0x00100000-0xbf76ffff]
[    0.000000]   node   0: [mem 0x100000000-0x33fffffff]
[    0.000000]   node   1: [mem 0x340000000-0x63fffffff]
[    0.000000] On node 0 totalpages: 3143420
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 7 pages reserved
[    0.000000]   DMA zone: 3909 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 763824 pages, LIFO batch:31
[    0.000000]   Normal zone: 36864 pages used for memmap
[    0.000000]   Normal zone: 2322432 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 3145728
[    0.000000]   Normal zone: 49152 pages used for memmap
[    0.000000]   Normal zone: 3096576 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x16] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x17] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x90] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x91] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x92] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x93] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x94] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x95] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x96] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x97] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec8a000] gsi_base[24])
[    0.000000]   Normal zone: 49152 pages used for memmap
[    0.000000]   Normal zone: 3096576 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x16] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x17] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x90] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x91] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x92] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x93] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x94] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x95] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x96] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x97] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec8a000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec8a000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] SMP: Allowing 24 CPUs, 8 hotplug CPUs
[    0.000000] nr_irqs_gsi: 64
[    0.000000] PM: Registered nosave memory: 000000000009c000 - 000000000009d000
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bf770000 - 00000000bf77e000
[    0.000000] PM: Registered nosave memory: 00000000bf77e000 - 00000000bf7d0000
[    0.000000] PM: Registered nosave memory: 00000000bf7d0000 - 00000000bf7e0000
[    0.000000] PM: Registered nosave memory: 00000000bf7e0000 - 00000000bf7ec000
[    0.000000] PM: Registered nosave memory: 00000000bf7ec000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffa00000
[    0.000000] PM: Registered nosave memory: 00000000ffa00000 - 0000000100000000
[    0.000000] e820: [mem 0xc0000000-0xdfffffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:24 nr_node_ids:2
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880333c00000 s79360 r8192 d23040 u131072
[    0.000000] pcpu-alloc: s79360 r8192 d23040 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 08 09 10 11 16 18 20 22 -- -- -- -- 
[    0.000000] pcpu-alloc: [1] 04 05 06 07 12 13 14 15 17 19 21 23 -- -- -- -- 
[    0.000000] Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 6186741
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec8a000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] SMP: Allowing 24 CPUs, 8 hotplug CPUs
[    0.000000] nr_irqs_gsi: 64
[    0.000000] PM: Registered nosave memory: 000000000009c000 - 000000000009d000
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bf770000 - 00000000bf77e000
[    0.000000] PM: Registered nosave memory: 00000000bf77e000 - 00000000bf7d0000
[    0.000000] PM: Registered nosave memory: 00000000bf7d0000 - 00000000bf7e0000
[    0.000000] PM: Registered nosave memory: 00000000bf7e0000 - 00000000bf7ec000
[    0.000000] PM: Registered nosave memory: 00000000bf7ec000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffa00000
[    0.000000] PM: Registered nosave memory: 00000000ffa00000 - 0000000100000000
[    0.000000] e820: [mem 0xc0000000-0xdfffffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:24 nr_node_ids:2
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880333c00000 s79360 r8192 d23040 u131072
[    0.000000] pcpu-alloc: s79360 r8192 d23040 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 08 09 10 11 16 18 20 22 -- -- -- -- 
[    0.000000] pcpu-alloc: [1] 04 05 06 07 12 13 14 15 17 19 21 23 -- -- -- -- 
[    0.000000] Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 6186741
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.5.0-rc6-andres-00196-gfdb1335 root=UUID=58ba7a04-b424-4a46-acbe-b6ca208f61e1 ro clocksource=hpet netconsole=4444@192.168.224.176/eth0,4444@192.168.224.203/00:21:86:60:5d:d6
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 24665292k/26214400k available (10375k kernel code, 1057808k absent, 491300k reserved, 9106k data, 892k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=24, Nodes=2
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:1280 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 100663296 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.003333] Detected 2266.927 MHz processor.
[    0.000007] Calibrating delay loop (skipped), value calculated using timer frequency.. 4535.76 BogoMIPS (lpj=7556423)
[    0.000405] pid_max: default: 32768 minimum: 301
[    0.003297] Dentry cache hash table entries: 4194304 (order: 13, 33554432 bytes)
[    0.011660] Inode-cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.015323] Mount-cache hash table entries: 256
[    0.015821] Initializing cgroup subsys cpuacct
[    0.016017] Initializing cgroup subsys memory
[    0.016227] Initializing cgroup subsys devices
[    0.016424] Initializing cgroup subsys freezer
[    0.016621] Initializing cgroup subsys net_cls
[    0.016814] Initializing cgroup subsys blkio
[    0.017043] CPU: Physical Processor ID: 0
[    0.017237] CPU: Processor Core ID: 0
[    0.017426] mce: CPU supports 9 MCE banks
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.5.0-rc6-andres-00196-gfdb1335 root=UUID=58ba7a04-b424-4a46-acbe-b6ca208f61e1 ro clocksource=hpet netconsole=4444@192.168.224.176/eth0,4444@192.168.224.203/00:21:86:60:5d:d6
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 24665292k/26214400k available (10375k kernel code, 1057808k absent, 491300k reserved, 9106k data, 892k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=24, Nodes=2
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:1280 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 100663296 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.003333] Detected 2266.927 MHz processor.
[    0.000007] Calibrating delay loop (skipped), value calculated using timer frequency.. 4535.76 BogoMIPS (lpj=7556423)
[    0.000405] pid_max: default: 32768 minimum: 301
[    0.003297] Dentry cache hash table entries: 4194304 (order: 13, 33554432 bytes)
[    0.011660] Inode-cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.015323] Mount-cache hash table entries: 256
[    0.015821] Initializing cgroup subsys cpuacct
[    0.016017] Initializing cgroup subsys memory
[    0.016227] Initializing cgroup subsys devices
[    0.016424] Initializing cgroup subsys freezer
[    0.016621] Initializing cgroup subsys net_cls
[    0.016814] Initializing cgroup subsys blkio
[    0.017043] CPU: Physical Processor ID: 0
[    0.017237] CPU: Processor Core ID: 0
[    0.017426] mce: CPU supports 9 MCE banks
[    0.017635] CPU0: Thermal monitoring enabled (TM1)
[    0.017841] using mwait in idle threads.
[    0.018124] ACPI: Core revision 20120320
[    0.046186] ftrace: allocating 34658 entries in 136 pages
[    0.067012] DMAR: Host address width 40
[    0.067212] DMAR: DRHD base: 0x000000fbffe000 flags: 0x1
[    0.067418] IOMMU 0: reg_base_addr fbffe000 ver 1:0 cap c90780106f0462 ecap f0207e
[    0.067699] DMAR: RMRR base: 0x000000000ec000 end: 0x000000000effff
[    0.067916] DMAR: RMRR base: 0x000000bf7ec000 end: 0x000000bf7fffff
[    0.068119] DMAR: ATSR flags: 0x0
[    0.068424] IOAPIC id 8 under DRHD base  0xfbffe000 IOMMU 0
[    0.071443] IOAPIC id 9 under DRHD base  0xfbffe000 IOMMU 0
[    0.071833] Enabled IRQ remapping in xapic mode
[    0.072047] Switched APIC routing to physical flat.
[    0.072919] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.106070] CPU0: Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz stepping 05
[    0.247489] APIC calibration not consistent with PM-Timer: 136ms instead of 100ms
[    0.247771] APIC delta adjusted to PM-Timer: 833361 (1138926)
[    0.247975] Performance Events: PEBS fmt1+, 16-deep LBR, Nehalem events, Intel PMU driver.
[    0.248689] CPU erratum AAJ80 worked around
[    0.248886] CPUID marked event: 'bus cycles' unavailable
[    0.249079] ... version:                3
[    0.249276] ... bit width:              48
[    0.249475] ... generic registers:      4
[    0.249668] ... value mask:             0000ffffffffffff
[    0.249871] ... max period:             000000007fffffff
[    0.250067] ... fixed-purpose events:   3
[    0.250263] ... event mask:             000000070000000f
[    0.250980] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.251505] Booting Node   0, Processors  #1 #2 #3 Ok.
[    0.292083] Booting Node   1, Processors  #4 #5 #6 #7 Ok.
[    0.444908] Booting Node   0, Processors  #8 #9 #10 #11 Ok.
[    0.017635] CPU0: Thermal monitoring enabled (TM1)
[    0.017841] using mwait in idle threads.
[    0.018124] ACPI: Core revision 20120320
[    0.046186] ftrace: allocating 34658 entries in 136 pages
[    0.067012] DMAR: Host address width 40
[    0.067212] DMAR: DRHD base: 0x000000fbffe000 flags: 0x1
[    0.067418] IOMMU 0: reg_base_addr fbffe000 ver 1:0 cap c90780106f0462 ecap f0207e
[    0.067699] DMAR: RMRR base: 0x000000000ec000 end: 0x000000000effff
[    0.067916] DMAR: RMRR base: 0x000000bf7ec000 end: 0x000000bf7fffff
[    0.068119] DMAR: ATSR flags: 0x0
[    0.068424] IOAPIC id 8 under DRHD base  0xfbffe000 IOMMU 0
[    0.071443] IOAPIC id 9 under DRHD base  0xfbffe000 IOMMU 0
[    0.071833] Enabled IRQ remapping in xapic mode
[    0.072047] Switched APIC routing to physical flat.
[    0.072919] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.106070] CPU0: Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz stepping 05
[    0.247489] APIC calibration not consistent with PM-Timer: 136ms instead of 100ms
[    0.247771] APIC delta adjusted to PM-Timer: 833361 (1138926)
[    0.247975] Performance Events: PEBS fmt1+, 16-deep LBR, Nehalem events, Intel PMU driver.
[    0.248689] CPU erratum AAJ80 worked around
[    0.248886] CPUID marked event: 'bus cycles' unavailable
[    0.249079] ... version:                3
[    0.249276] ... bit width:              48
[    0.249475] ... generic registers:      4
[    0.249668] ... value mask:             0000ffffffffffff
[    0.249871] ... max period:             000000007fffffff
[    0.250067] ... fixed-purpose events:   3
[    0.250263] ... event mask:             000000070000000f
[    0.250980] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.251505] Booting Node   0, Processors  #1 #2 #3 Ok.
[    0.292083] Booting Node   1, Processors  #4 #5 #6 #7 Ok.
[    0.444908] Booting Node   0, Processors  #8 #9 #10 #11 Ok.
[    0.498842] Booting Node   1, Processors  #12 #13 #14 #15
[    0.552439] Brought up 16 CPUs
[    0.552814] Total of 16 processors activated (72566.41 BogoMIPS).
[    0.564841] devtmpfs: initialized
[    0.567614] PM: Registering ACPI NVS region [mem 0xbf77e000-0xbf7cffff] (335872 bytes)
[    0.568654] xor: automatically using best checksumming function:
[    0.600710]    generic_sse:  8426.400 MB/sec
[    0.600939] RTC time:  6:55:45, date: 08/30/12
[    0.601181] NET: Registered protocol family 16
[    0.601553] ACPI: bus type pci registered
[    0.601798] dca service started, version 1.12.1
[    0.602015] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.602309] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.619601] PCI: Using configuration type 1 for base access
[    0.621783] bio: create slab <bio-0> at 0
[    0.677255] raid6: sse2x1    5591 MB/s
[    0.733815] raid6: sse2x2    6428 MB/s
[    0.790391] raid6: sse2x4    7183 MB/s
[    0.790582] raid6: using algorithm sse2x4 (7183 MB/s)
[    0.790776] raid6: using ssse3x2 recovery algorithm
[    0.791002] ACPI: Added _OSI(Module Device)
[    0.791198] ACPI: Added _OSI(Processor Device)
[    0.791393] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.791585] ACPI: Added _OSI(Processor Aggregator Device)
[    0.792776] ACPI: EC: Look up EC in DSDT
[    0.793983] ACPI: Executed 1 blocks of module-level executable AML code
[    0.803835] ACPI: SSDT 00000000bf77e200 02B94 (v01 DpgPmm  P001Ist 00000011 INTL 20051117)
[    0.804777] ACPI: Dynamic OEM Table Load:
[    0.805173] ACPI: SSDT           (null) 02B94 (v01 DpgPmm  P001Ist 00000011 INTL 20051117)
[    0.805781] ACPI: SSDT 00000000bf780da0 00961 (v01  PmRef  P001Cst 00003001 INTL 20051117)
[    0.806564] ACPI: Dynamic OEM Table Load:
[    0.806955] ACPI: SSDT           (null) 00961 (v01  PmRef  P001Cst 00003001 INTL 20051117)
[    0.498842] Booting Node   1, Processors  #12 #13 #14 #15
[    0.552439] Brought up 16 CPUs
[    0.552814] Total of 16 processors activated (72566.41 BogoMIPS).
[    0.564841] devtmpfs: initialized
[    0.567614] PM: Registering ACPI NVS region [mem 0xbf77e000-0xbf7cffff] (335872 bytes)
[    0.568654] xor: automatically using best checksumming function:
[    0.600710]    generic_sse:  8426.400 MB/sec
[    0.600939] RTC time:  6:55:45, date: 08/30/12
[    0.601181] NET: Registered protocol family 16
[    0.601553] ACPI: bus type pci registered
[    0.601798] dca service started, version 1.12.1
[    0.602015] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.602309] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.619601] PCI: Using configuration type 1 for base access
[    0.621783] bio: create slab <bio-0> at 0
[    0.677255] raid6: sse2x1    5591 MB/s
[    0.733815] raid6: sse2x2    6428 MB/s
[    0.790391] raid6: sse2x4    7183 MB/s
[    0.790582] raid6: using algorithm sse2x4 (7183 MB/s)
[    0.790776] raid6: using ssse3x2 recovery algorithm
[    0.791002] ACPI: Added _OSI(Module Device)
[    0.791198] ACPI: Added _OSI(Processor Device)
[    0.791393] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.791585] ACPI: Added _OSI(Processor Aggregator Device)
[    0.792776] ACPI: EC: Look up EC in DSDT
[    0.793983] ACPI: Executed 1 blocks of module-level executable AML code
[    0.803835] ACPI: SSDT 00000000bf77e200 02B94 (v01 DpgPmm  P001Ist 00000011 INTL 20051117)
[    0.804777] ACPI: Dynamic OEM Table Load:
[    0.805173] ACPI: SSDT           (null) 02B94 (v01 DpgPmm  P001Ist 00000011 INTL 20051117)
[    0.805781] ACPI: SSDT 00000000bf780da0 00961 (v01  PmRef  P001Cst 00003001 INTL 20051117)
[    0.806564] ACPI: Dynamic OEM Table Load:
[    0.806955] ACPI: SSDT           (null) 00961 (v01  PmRef  P001Cst 00003001 INTL 20051117)
[    0.807540] ACPI: SSDT 00000000bf781710 006E2 (v01  PmRef  Cpu0Tst 00003000 INTL 20051117)
[    0.808376] ACPI: Dynamic OEM Table Load:
[    0.808769] ACPI: SSDT           (null) 006E2 (v01  PmRef  Cpu0Tst 00003000 INTL 20051117)
[    0.820713] ACPI: Interpreter enabled
[    0.820910] ACPI: (supports S0 S1 S3 S4 S5)
[    0.821619] ACPI: Using IOAPIC for interrupt routing
[    0.828904] ACPI: No dock devices found.
[    0.829102] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.829465] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.829785] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.829984] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.830181] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.830473] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff]
[    0.830763] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xdfffffff]
[    0.831049] pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xfed8ffff]
[    0.831364] PCI host bridge to bus 0000:00
[    0.831558] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.831760] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.831954] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.832151] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000dffff]
[    0.832346] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xdfffffff]
[    0.832542] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfed8ffff]
[    0.832748] pci 0000:00:00.0: [8086:3406] type 00 class 0x060000
[    0.832799] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    0.832822] pci 0000:00:01.0: [8086:3408] type 01 class 0x060400
[    0.832875] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.832902] pci 0000:00:03.0: [8086:340a] type 01 class 0x060400
[    0.832955] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.832982] pci 0000:00:07.0: [8086:340e] type 01 class 0x060400
[    0.833035] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.833061] pci 0000:00:09.0: [8086:3410] type 01 class 0x060400
[    0.833115] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.807540] ACPI: SSDT 00000000bf781710 006E2 (v01  PmRef  Cpu0Tst 00003000 INTL 20051117)
[    0.808376] ACPI: Dynamic OEM Table Load:
[    0.808769] ACPI: SSDT           (null) 006E2 (v01  PmRef  Cpu0Tst 00003000 INTL 20051117)
[    0.820713] ACPI: Interpreter enabled
[    0.820910] ACPI: (supports S0 S1 S3 S4 S5)
[    0.821619] ACPI: Using IOAPIC for interrupt routing
[    0.828904] ACPI: No dock devices found.
[    0.829102] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.829465] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.829785] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.829984] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.830181] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.830473] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff]
[    0.830763] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xdfffffff]
[    0.831049] pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xfed8ffff]
[    0.831364] PCI host bridge to bus 0000:00
[    0.831558] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.831760] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.831954] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.832151] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000dffff]
[    0.832346] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xdfffffff]
[    0.832542] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfed8ffff]
[    0.832748] pci 0000:00:00.0: [8086:3406] type 00 class 0x060000
[    0.832799] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    0.832822] pci 0000:00:01.0: [8086:3408] type 01 class 0x060400
[    0.832875] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.832902] pci 0000:00:03.0: [8086:340a] type 01 class 0x060400
[    0.832955] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.832982] pci 0000:00:07.0: [8086:340e] type 01 class 0x060400
[    0.833035] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.833061] pci 0000:00:09.0: [8086:3410] type 01 class 0x060400
[    0.833115] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.833142] pci 0000:00:13.0: [8086:342d] type 00 class 0x080020
[    0.833152] pci 0000:00:13.0: reg 10: [mem 0xfec8a000-0xfec8afff]
[    0.833198] pci 0000:00:13.0: PME# supported from D0 D3hot D3cold
[    0.833215] pci 0000:00:14.0: [8086:342e] type 00 class 0x080000
[    0.833280] pci 0000:00:14.1: [8086:3422] type 00 class 0x080000
[    0.833342] pci 0000:00:14.2: [8086:3423] type 00 class 0x080000
[    0.833401] pci 0000:00:14.3: [8086:3438] type 00 class 0x080000
[    0.833460] pci 0000:00:16.0: [8086:3430] type 00 class 0x088000
[    0.833472] pci 0000:00:16.0: reg 10: [mem 0xfb6d8000-0xfb6dbfff 64bit]
[    0.833537] pci 0000:00:16.1: [8086:3431] type 00 class 0x088000
[    0.833548] pci 0000:00:16.1: reg 10: [mem 0xfb6dc000-0xfb6dffff 64bit]
[    0.833613] pci 0000:00:16.2: [8086:3432] type 00 class 0x088000
[    0.833625] pci 0000:00:16.2: reg 10: [mem 0xfb6e0000-0xfb6e3fff 64bit]
[    0.833694] pci 0000:00:16.3: [8086:3433] type 00 class 0x088000
[    0.833706] pci 0000:00:16.3: reg 10: [mem 0xfb6e4000-0xfb6e7fff 64bit]
[    0.833771] pci 0000:00:16.4: [8086:3429] type 00 class 0x088000
[    0.833782] pci 0000:00:16.4: reg 10: [mem 0xfb6e8000-0xfb6ebfff 64bit]
[    0.833849] pci 0000:00:16.5: [8086:342a] type 00 class 0x088000
[    0.833860] pci 0000:00:16.5: reg 10: [mem 0xfb6ec000-0xfb6effff 64bit]
[    0.833925] pci 0000:00:16.6: [8086:342b] type 00 class 0x088000
[    0.833937] pci 0000:00:16.6: reg 10: [mem 0xfb6f0000-0xfb6f3fff 64bit]
[    0.834002] pci 0000:00:16.7: [8086:342c] type 00 class 0x088000
[    0.834013] pci 0000:00:16.7: reg 10: [mem 0xfb6f4000-0xfb6f7fff 64bit]
[    0.834089] pci 0000:00:1a.0: [8086:3a37] type 00 class 0x0c0300
[    0.834133] pci 0000:00:1a.0: reg 20: [io  0x9400-0x941f]
[    0.834194] pci 0000:00:1a.1: [8086:3a38] type 00 class 0x0c0300
[    0.834238] pci 0000:00:1a.1: reg 20: [io  0x9480-0x949f]
[    0.834299] pci 0000:00:1a.2: [8086:3a39] type 00 class 0x0c0300
[    0.834343] pci 0000:00:1a.2: reg 20: [io  0x9800-0x981f]
[    0.834414] pci 0000:00:1a.7: [8086:3a3c] type 00 class 0x0c0320
[    0.834438] pci 0000:00:1a.7: reg 10: [mem 0xfb6f8000-0xfb6f83ff]
[    0.834532] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.833142] pci 0000:00:13.0: [8086:342d] type 00 class 0x080020
[    0.833152] pci 0000:00:13.0: reg 10: [mem 0xfec8a000-0xfec8afff]
[    0.833198] pci 0000:00:13.0: PME# supported from D0 D3hot D3cold
[    0.833215] pci 0000:00:14.0: [8086:342e] type 00 class 0x080000
[    0.833280] pci 0000:00:14.1: [8086:3422] type 00 class 0x080000
[    0.833342] pci 0000:00:14.2: [8086:3423] type 00 class 0x080000
[    0.833401] pci 0000:00:14.3: [8086:3438] type 00 class 0x080000
[    0.833460] pci 0000:00:16.0: [8086:3430] type 00 class 0x088000
[    0.833472] pci 0000:00:16.0: reg 10: [mem 0xfb6d8000-0xfb6dbfff 64bit]
[    0.833537] pci 0000:00:16.1: [8086:3431] type 00 class 0x088000
[    0.833548] pci 0000:00:16.1: reg 10: [mem 0xfb6dc000-0xfb6dffff 64bit]
[    0.833613] pci 0000:00:16.2: [8086:3432] type 00 class 0x088000
[    0.833625] pci 0000:00:16.2: reg 10: [mem 0xfb6e0000-0xfb6e3fff 64bit]
[    0.833694] pci 0000:00:16.3: [8086:3433] type 00 class 0x088000
[    0.833706] pci 0000:00:16.3: reg 10: [mem 0xfb6e4000-0xfb6e7fff 64bit]
[    0.833771] pci 0000:00:16.4: [8086:3429] type 00 class 0x088000
[    0.833782] pci 0000:00:16.4: reg 10: [mem 0xfb6e8000-0xfb6ebfff 64bit]
[    0.833849] pci 0000:00:16.5: [8086:342a] type 00 class 0x088000
[    0.833860] pci 0000:00:16.5: reg 10: [mem 0xfb6ec000-0xfb6effff 64bit]
[    0.833925] pci 0000:00:16.6: [8086:342b] type 00 class 0x088000
[    0.833937] pci 0000:00:16.6: reg 10: [mem 0xfb6f0000-0xfb6f3fff 64bit]
[    0.834002] pci 0000:00:16.7: [8086:342c] type 00 class 0x088000
[    0.834013] pci 0000:00:16.7: reg 10: [mem 0xfb6f4000-0xfb6f7fff 64bit]
[    0.834089] pci 0000:00:1a.0: [8086:3a37] type 00 class 0x0c0300
[    0.834133] pci 0000:00:1a.0: reg 20: [io  0x9400-0x941f]
[    0.834194] pci 0000:00:1a.1: [8086:3a38] type 00 class 0x0c0300
[    0.834238] pci 0000:00:1a.1: reg 20: [io  0x9480-0x949f]
[    0.834299] pci 0000:00:1a.2: [8086:3a39] type 00 class 0x0c0300
[    0.834343] pci 0000:00:1a.2: reg 20: [io  0x9800-0x981f]
[    0.834414] pci 0000:00:1a.7: [8086:3a3c] type 00 class 0x0c0320
[    0.834438] pci 0000:00:1a.7: reg 10: [mem 0xfb6f8000-0xfb6f83ff]
[    0.834532] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.834562] pci 0000:00:1c.0: [8086:3a40] type 01 class 0x060400
[    0.834632] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.834667] pci 0000:00:1c.4: [8086:3a48] type 01 class 0x060400
[    0.834741] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.834772] pci 0000:00:1c.5: [8086:3a4a] type 01 class 0x060400
[    0.834842] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.834874] pci 0000:00:1d.0: [8086:3a34] type 00 class 0x0c0300
[    0.834918] pci 0000:00:1d.0: reg 20: [io  0x9880-0x989f]
[    0.834979] pci 0000:00:1d.1: [8086:3a35] type 00 class 0x0c0300
[    0.835023] pci 0000:00:1d.1: reg 20: [io  0x9c00-0x9c1f]
[    0.835084] pci 0000:00:1d.2: [8086:3a36] type 00 class 0x0c0300
[    0.835128] pci 0000:00:1d.2: reg 20: [io  0xa000-0xa01f]
[    0.835201] pci 0000:00:1d.7: [8086:3a3a] type 00 class 0x0c0320
[    0.835225] pci 0000:00:1d.7: reg 10: [mem 0xfb6fa000-0xfb6fa3ff]
[    0.835319] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.835355] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.835430] pci 0000:00:1f.0: [8086:3a16] type 00 class 0x060100
[    0.835515] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0a00 (mask 00ff)
[    0.835798] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0ca0 (mask 000f)
[    0.836085] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at f700 (mask 000f)
[    0.836428] pci 0000:00:1f.2: [8086:3a22] type 00 class 0x010601
[    0.836449] pci 0000:00:1f.2: reg 10: [io  0xa880-0xa887]
[    0.836461] pci 0000:00:1f.2: reg 14: [io  0xa800-0xa803]
[    0.836472] pci 0000:00:1f.2: reg 18: [io  0xa480-0xa487]
[    0.836484] pci 0000:00:1f.2: reg 1c: [io  0xa400-0xa403]
[    0.836494] pci 0000:00:1f.2: reg 20: [io  0xa080-0xa09f]
[    0.836506] pci 0000:00:1f.2: reg 24: [mem 0xfb6fc000-0xfb6fc7ff]
[    0.836558] pci 0000:00:1f.2: PME# supported from D3hot
[    0.836587] pci 0000:00:1f.3: [8086:3a30] type 00 class 0x0c0500
[    0.836606] pci 0000:00:1f.3: reg 10: [mem 0xfb6fe000-0xfb6fe0ff 64bit]
[    0.836629] pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
[    0.836706] pci 0000:09:00.0: [8086:032c] type 01 class 0x060400
[    0.834562] pci 0000:00:1c.0: [8086:3a40] type 01 class 0x060400
[    0.834632] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.834667] pci 0000:00:1c.4: [8086:3a48] type 01 class 0x060400
[    0.834741] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.834772] pci 0000:00:1c.5: [8086:3a4a] type 01 class 0x060400
[    0.834842] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.834874] pci 0000:00:1d.0: [8086:3a34] type 00 class 0x0c0300
[    0.834918] pci 0000:00:1d.0: reg 20: [io  0x9880-0x989f]
[    0.834979] pci 0000:00:1d.1: [8086:3a35] type 00 class 0x0c0300
[    0.835023] pci 0000:00:1d.1: reg 20: [io  0x9c00-0x9c1f]
[    0.835084] pci 0000:00:1d.2: [8086:3a36] type 00 class 0x0c0300
[    0.835128] pci 0000:00:1d.2: reg 20: [io  0xa000-0xa01f]
[    0.835201] pci 0000:00:1d.7: [8086:3a3a] type 00 class 0x0c0320
[    0.835225] pci 0000:00:1d.7: reg 10: [mem 0xfb6fa000-0xfb6fa3ff]
[    0.835319] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.835355] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.835430] pci 0000:00:1f.0: [8086:3a16] type 00 class 0x060100
[    0.835515] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0a00 (mask 00ff)
[    0.835798] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0ca0 (mask 000f)
[    0.836085] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at f700 (mask 000f)
[    0.836428] pci 0000:00:1f.2: [8086:3a22] type 00 class 0x010601
[    0.836449] pci 0000:00:1f.2: reg 10: [io  0xa880-0xa887]
[    0.836461] pci 0000:00:1f.2: reg 14: [io  0xa800-0xa803]
[    0.836472] pci 0000:00:1f.2: reg 18: [io  0xa480-0xa487]
[    0.836484] pci 0000:00:1f.2: reg 1c: [io  0xa400-0xa403]
[    0.836494] pci 0000:00:1f.2: reg 20: [io  0xa080-0xa09f]
[    0.836506] pci 0000:00:1f.2: reg 24: [mem 0xfb6fc000-0xfb6fc7ff]
[    0.836558] pci 0000:00:1f.2: PME# supported from D3hot
[    0.836587] pci 0000:00:1f.3: [8086:3a30] type 00 class 0x0c0500
[    0.836606] pci 0000:00:1f.3: reg 10: [mem 0xfb6fe000-0xfb6fe0ff 64bit]
[    0.836629] pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
[    0.836706] pci 0000:09:00.0: [8086:032c] type 01 class 0x060400
[    0.836726] pci 0000:09:00.0: PXH quirk detected; SHPC device MSI disabled
[    0.836974] pci 0000:09:00.0: PME# supported from D0 D3hot D3cold
[    0.837001] pci 0000:09:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.837300] pci 0000:00:01.0: PCI bridge to [bus 09-0a]
[    0.837561] pci 0000:09:00.0: PCI bridge to [bus 0a-0a]
[    0.837810] pci 0000:08:00.0: [1002:6738] type 00 class 0x030000
[    0.837826] pci 0000:08:00.0: reg 10: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.837838] pci 0000:08:00.0: reg 18: [mem 0xfbec0000-0xfbedffff 64bit]
[    0.837846] pci 0000:08:00.0: reg 20: [io  0xe000-0xe0ff]
[    0.837861] pci 0000:08:00.0: reg 30: [mem 0xfbea0000-0xfbebffff pref]
[    0.837896] pci 0000:08:00.0: supports D1 D2
[    0.837920] pci 0000:08:00.1: [1002:aa88] type 00 class 0x040300
[    0.837935] pci 0000:08:00.1: reg 10: [mem 0xfbefc000-0xfbefffff 64bit]
[    0.838002] pci 0000:08:00.1: supports D1 D2
[    0.843650] pci 0000:00:03.0: PCI bridge to [bus 08-08]
[    0.843858] pci 0000:00:03.0:   bridge window [io  0xe000-0xefff]
[    0.843861] pci 0000:00:03.0:   bridge window [mem 0xfbe00000-0xfbefffff]
[    0.843866] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.843899] pci 0000:00:07.0: PCI bridge to [bus 07-07]
[    0.844139] pci 0000:06:00.0: [1000:0058] type 00 class 0x010000
[    0.844152] pci 0000:06:00.0: reg 10: [io  0xd000-0xd0ff]
[    0.844166] pci 0000:06:00.0: reg 14: [mem 0xfbdfc000-0xfbdfffff 64bit]
[    0.844177] pci 0000:06:00.0: reg 1c: [mem 0xfbde0000-0xfbdeffff 64bit]
[    0.844191] pci 0000:06:00.0: reg 30: [mem 0xfba00000-0xfbbfffff pref]
[    0.844232] pci 0000:06:00.0: supports D1 D2
[    0.844247] pci 0000:06:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.844542] pci 0000:00:09.0: PCI bridge to [bus 06-06]
[    0.844741] pci 0000:00:09.0:   bridge window [io  0xd000-0xdfff]
[    0.844744] pci 0000:00:09.0:   bridge window [mem 0xfba00000-0xfbdfffff]
[    0.844892] pci 0000:04:00.0: [1102:7006] type 01 class 0x060400
[    0.845441] pci 0000:04:00.0: supports D1 D2
[    0.845532] pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.836726] pci 0000:09:00.0: PXH quirk detected; SHPC device MSI disabled
[    0.836974] pci 0000:09:00.0: PME# supported from D0 D3hot D3cold
[    0.837001] pci 0000:09:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.837300] pci 0000:00:01.0: PCI bridge to [bus 09-0a]
[    0.837561] pci 0000:09:00.0: PCI bridge to [bus 0a-0a]
[    0.837810] pci 0000:08:00.0: [1002:6738] type 00 class 0x030000
[    0.837826] pci 0000:08:00.0: reg 10: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.837838] pci 0000:08:00.0: reg 18: [mem 0xfbec0000-0xfbedffff 64bit]
[    0.837846] pci 0000:08:00.0: reg 20: [io  0xe000-0xe0ff]
[    0.837861] pci 0000:08:00.0: reg 30: [mem 0xfbea0000-0xfbebffff pref]
[    0.837896] pci 0000:08:00.0: supports D1 D2
[    0.837920] pci 0000:08:00.1: [1002:aa88] type 00 class 0x040300
[    0.837935] pci 0000:08:00.1: reg 10: [mem 0xfbefc000-0xfbefffff 64bit]
[    0.838002] pci 0000:08:00.1: supports D1 D2
[    0.843650] pci 0000:00:03.0: PCI bridge to [bus 08-08]
[    0.843858] pci 0000:00:03.0:   bridge window [io  0xe000-0xefff]
[    0.843861] pci 0000:00:03.0:   bridge window [mem 0xfbe00000-0xfbefffff]
[    0.843866] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.843899] pci 0000:00:07.0: PCI bridge to [bus 07-07]
[    0.844139] pci 0000:06:00.0: [1000:0058] type 00 class 0x010000
[    0.844152] pci 0000:06:00.0: reg 10: [io  0xd000-0xd0ff]
[    0.844166] pci 0000:06:00.0: reg 14: [mem 0xfbdfc000-0xfbdfffff 64bit]
[    0.844177] pci 0000:06:00.0: reg 1c: [mem 0xfbde0000-0xfbdeffff 64bit]
[    0.844191] pci 0000:06:00.0: reg 30: [mem 0xfba00000-0xfbbfffff pref]
[    0.844232] pci 0000:06:00.0: supports D1 D2
[    0.844247] pci 0000:06:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.844542] pci 0000:00:09.0: PCI bridge to [bus 06-06]
[    0.844741] pci 0000:00:09.0:   bridge window [io  0xd000-0xdfff]
[    0.844744] pci 0000:00:09.0:   bridge window [mem 0xfba00000-0xfbdfffff]
[    0.844892] pci 0000:04:00.0: [1102:7006] type 01 class 0x060400
[    0.845441] pci 0000:04:00.0: supports D1 D2
[    0.845532] pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.845838] pci 0000:00:1c.0: PCI bridge to [bus 04-05]
[    0.846039] pci 0000:00:1c.0:   bridge window [mem 0xfb900000-0xfb9fffff]
[    0.846156] pci 0000:05:00.0: [1102:0009] type 00 class 0x040300
[    0.846232] pci 0000:05:00.0: reg 10: [mem 0xfb9fc000-0xfb9fffff]
[    0.846579] pci 0000:05:00.0: supports D1 D2
[    0.846777] pci 0000:04:00.0: PCI bridge to [bus 05-05]
[    0.846990] pci 0000:04:00.0:   bridge window [mem 0xfb900000-0xfb9fffff]
[    0.847195] pci 0000:03:00.0: [8086:10d3] type 00 class 0x020000
[    0.847271] pci 0000:03:00.0: reg 10: [mem 0xfb8e0000-0xfb8fffff]
[    0.847367] pci 0000:03:00.0: reg 18: [io  0xcc00-0xcc1f]
[    0.847420] pci 0000:03:00.0: reg 1c: [mem 0xfb8dc000-0xfb8dffff]
[    0.847877] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.848050] pci 0000:00:1c.4: PCI bridge to [bus 03-03]
[    0.848251] pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
[    0.848258] pci 0000:00:1c.4:   bridge window [mem 0xfb800000-0xfb8fffff]
[    0.848457] pci 0000:02:00.0: [8086:10d3] type 00 class 0x020000
[    0.848529] pci 0000:02:00.0: reg 10: [mem 0xfb7e0000-0xfb7fffff]
[    0.848631] pci 0000:02:00.0: reg 18: [io  0xbc00-0xbc1f]
[    0.848684] pci 0000:02:00.0: reg 1c: [mem 0xfb7dc000-0xfb7dffff]
[    0.849143] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.849316] pci 0000:00:1c.5: PCI bridge to [bus 02-02]
[    0.849511] pci 0000:00:1c.5:   bridge window [io  0xb000-0xbfff]
[    0.849517] pci 0000:00:1c.5:   bridge window [mem 0xfb700000-0xfb7fffff]
[    0.849586] pci 0000:00:1e.0: PCI bridge to [bus 01-01] (subtractive decode)
[    0.849792] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.849794] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.849795] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.849797] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    0.849799] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xdfffffff] (subtractive decode)
[    0.849801] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfed8ffff] (subtractive decode)
[    0.849838] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.850016] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE1._PRT]
[    0.845838] pci 0000:00:1c.0: PCI bridge to [bus 04-05]
[    0.846039] pci 0000:00:1c.0:   bridge window [mem 0xfb900000-0xfb9fffff]
[    0.846156] pci 0000:05:00.0: [1102:0009] type 00 class 0x040300
[    0.846232] pci 0000:05:00.0: reg 10: [mem 0xfb9fc000-0xfb9fffff]
[    0.846579] pci 0000:05:00.0: supports D1 D2
[    0.846777] pci 0000:04:00.0: PCI bridge to [bus 05-05]
[    0.846990] pci 0000:04:00.0:   bridge window [mem 0xfb900000-0xfb9fffff]
[    0.847195] pci 0000:03:00.0: [8086:10d3] type 00 class 0x020000
[    0.847271] pci 0000:03:00.0: reg 10: [mem 0xfb8e0000-0xfb8fffff]
[    0.847367] pci 0000:03:00.0: reg 18: [io  0xcc00-0xcc1f]
[    0.847420] pci 0000:03:00.0: reg 1c: [mem 0xfb8dc000-0xfb8dffff]
[    0.847877] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.848050] pci 0000:00:1c.4: PCI bridge to [bus 03-03]
[    0.848251] pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
[    0.848258] pci 0000:00:1c.4:   bridge window [mem 0xfb800000-0xfb8fffff]
[    0.848457] pci 0000:02:00.0: [8086:10d3] type 00 class 0x020000
[    0.848529] pci 0000:02:00.0: reg 10: [mem 0xfb7e0000-0xfb7fffff]
[    0.848631] pci 0000:02:00.0: reg 18: [io  0xbc00-0xbc1f]
[    0.848684] pci 0000:02:00.0: reg 1c: [mem 0xfb7dc000-0xfb7dffff]
[    0.849143] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.849316] pci 0000:00:1c.5: PCI bridge to [bus 02-02]
[    0.849511] pci 0000:00:1c.5:   bridge window [io  0xb000-0xbfff]
[    0.849517] pci 0000:00:1c.5:   bridge window [mem 0xfb700000-0xfb7fffff]
[    0.849586] pci 0000:00:1e.0: PCI bridge to [bus 01-01] (subtractive decode)
[    0.849792] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.849794] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.849795] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.849797] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    0.849799] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xdfffffff] (subtractive decode)
[    0.849801] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfed8ffff] (subtractive decode)
[    0.849838] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.850016] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE1._PRT]
[    0.850041] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE1.PXH_._PRT]
[    0.850077] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE3._PRT]
[    0.850104] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE7._PRT]
[    0.850128] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE9._PRT]
[    0.850155] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.850200] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    0.850231] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
[    0.850260] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
[    0.850287]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.850487]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    0.850750] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.868959] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 *10 11 12 14 15)
[    0.870347] ACPI: PCI Interrupt Link [LNKB] (IRQs *5)
[    0.870896] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 11 12 14 *15)
[    0.872295] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 *11 12 14 15)
[    0.873702] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12 14 15) *0, disabled.
[    0.875372] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 7 *10 11 12 14 15)
[    0.876746] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 6 7 10 11 12 14 15) *0, disabled.
[    0.878454] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 6 7 10 11 12 *14 15)
[    0.879889] vgaarb: device added: PCI:0000:08:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.880179] vgaarb: loaded
[    0.880373] vgaarb: bridge control possible 0000:08:00.0
[    0.880629] SCSI subsystem initialized
[    0.880858] libata version 3.00 loaded.
[    0.880863] ACPI: bus type usb registered
[    0.881080] usbcore: registered new interface driver usbfs
[    0.881283] usbcore: registered new interface driver hub
[    0.881496] usbcore: registered new device driver usb
[    0.881750] PCI: Using ACPI for IRQ routing
[    0.887727] PCI: Discovered peer bus fe
[    0.887917] PCI: root bus fe: using default resources
[    0.887918] PCI: Probing PCI hardware (bus fe)
[    0.850041] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE1.PXH_._PRT]
[    0.850077] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE3._PRT]
[    0.850104] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE7._PRT]
[    0.850128] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE9._PRT]
[    0.850155] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.850200] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    0.850231] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
[    0.850260] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
[    0.850287]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.850487]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    0.850750] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.868959] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 *10 11 12 14 15)
[    0.870347] ACPI: PCI Interrupt Link [LNKB] (IRQs *5)
[    0.870896] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 11 12 14 *15)
[    0.872295] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 *11 12 14 15)
[    0.873702] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12 14 15) *0, disabled.
[    0.875372] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 7 *10 11 12 14 15)
[    0.876746] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 6 7 10 11 12 14 15) *0, disabled.
[    0.878454] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 6 7 10 11 12 *14 15)
[    0.879889] vgaarb: device added: PCI:0000:08:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.880179] vgaarb: loaded
[    0.880373] vgaarb: bridge control possible 0000:08:00.0
[    0.880629] SCSI subsystem initialized
[    0.880858] libata version 3.00 loaded.
[    0.880863] ACPI: bus type usb registered
[    0.881080] usbcore: registered new interface driver usbfs
[    0.881283] usbcore: registered new interface driver hub
[    0.881496] usbcore: registered new device driver usb
[    0.881750] PCI: Using ACPI for IRQ routing
[    0.887727] PCI: Discovered peer bus fe
[    0.887917] PCI: root bus fe: using default resources
[    0.887918] PCI: Probing PCI hardware (bus fe)
[    0.887940] PCI host bridge to bus 0000:fe
[    0.888142] pci_bus 0000:fe: root bus resource [io  0x0000-0xffff]
[    0.888342] pci_bus 0000:fe: root bus resource [mem 0x00000000-0xffffffffff]
[    0.888548] pci 0000:fe:00.0: [8086:2c40] type 00 class 0x060000
[    0.888570] pci 0000:fe:00.1: [8086:2c01] type 00 class 0x060000
[    0.888594] pci 0000:fe:02.0: [8086:2c10] type 00 class 0x060000
[    0.888614] pci 0000:fe:02.1: [8086:2c11] type 00 class 0x060000
[    0.888637] pci 0000:fe:02.4: [8086:2c14] type 00 class 0x060000
[    0.888658] pci 0000:fe:02.5: [8086:2c15] type 00 class 0x060000
[    0.888679] pci 0000:fe:03.0: [8086:2c18] type 00 class 0x060000
[    0.888700] pci 0000:fe:03.1: [8086:2c19] type 00 class 0x060000
[    0.888720] pci 0000:fe:03.2: [8086:2c1a] type 00 class 0x060000
[    0.888741] pci 0000:fe:03.4: [8086:2c1c] type 00 class 0x060000
[    0.888762] pci 0000:fe:04.0: [8086:2c20] type 00 class 0x060000
[    0.888783] pci 0000:fe:04.1: [8086:2c21] type 00 class 0x060000
[    0.888805] pci 0000:fe:04.2: [8086:2c22] type 00 class 0x060000
[    0.888825] pci 0000:fe:04.3: [8086:2c23] type 00 class 0x060000
[    0.888848] pci 0000:fe:05.0: [8086:2c28] type 00 class 0x060000
[    0.888868] pci 0000:fe:05.1: [8086:2c29] type 00 class 0x060000
[    0.888888] pci 0000:fe:05.2: [8086:2c2a] type 00 class 0x060000
[    0.888909] pci 0000:fe:05.3: [8086:2c2b] type 00 class 0x060000
[    0.888931] pci 0000:fe:06.0: [8086:2c30] type 00 class 0x060000
[    0.888952] pci 0000:fe:06.1: [8086:2c31] type 00 class 0x060000
[    0.888974] pci 0000:fe:06.2: [8086:2c32] type 00 class 0x060000
[    0.888995] pci 0000:fe:06.3: [8086:2c33] type 00 class 0x060000
[    0.889362] PCI: Discovered peer bus ff
[    0.889555] PCI: root bus ff: using default resources
[    0.889556] PCI: Probing PCI hardware (bus ff)
[    0.889577] PCI host bridge to bus 0000:ff
[    0.889775] pci_bus 0000:ff: root bus resource [io  0x0000-0xffff]
[    0.889978] pci_bus 0000:ff: root bus resource [mem 0x00000000-0xffffffffff]
[    0.890184] pci 0000:ff:00.0: [8086:2c40] type 00 class 0x060000
[    0.887940] PCI host bridge to bus 0000:fe
[    0.888142] pci_bus 0000:fe: root bus resource [io  0x0000-0xffff]
[    0.888342] pci_bus 0000:fe: root bus resource [mem 0x00000000-0xffffffffff]
[    0.888548] pci 0000:fe:00.0: [8086:2c40] type 00 class 0x060000
[    0.888570] pci 0000:fe:00.1: [8086:2c01] type 00 class 0x060000
[    0.888594] pci 0000:fe:02.0: [8086:2c10] type 00 class 0x060000
[    0.888614] pci 0000:fe:02.1: [8086:2c11] type 00 class 0x060000
[    0.888637] pci 0000:fe:02.4: [8086:2c14] type 00 class 0x060000
[    0.888658] pci 0000:fe:02.5: [8086:2c15] type 00 class 0x060000
[    0.888679] pci 0000:fe:03.0: [8086:2c18] type 00 class 0x060000
[    0.888700] pci 0000:fe:03.1: [8086:2c19] type 00 class 0x060000
[    0.888720] pci 0000:fe:03.2: [8086:2c1a] type 00 class 0x060000
[    0.888741] pci 0000:fe:03.4: [8086:2c1c] type 00 class 0x060000
[    0.888762] pci 0000:fe:04.0: [8086:2c20] type 00 class 0x060000
[    0.888783] pci 0000:fe:04.1: [8086:2c21] type 00 class 0x060000
[    0.888805] pci 0000:fe:04.2: [8086:2c22] type 00 class 0x060000
[    0.888825] pci 0000:fe:04.3: [8086:2c23] type 00 class 0x060000
[    0.888848] pci 0000:fe:05.0: [8086:2c28] type 00 class 0x060000
[    0.888868] pci 0000:fe:05.1: [8086:2c29] type 00 class 0x060000
[    0.888888] pci 0000:fe:05.2: [8086:2c2a] type 00 class 0x060000
[    0.888909] pci 0000:fe:05.3: [8086:2c2b] type 00 class 0x060000
[    0.888931] pci 0000:fe:06.0: [8086:2c30] type 00 class 0x060000
[    0.888952] pci 0000:fe:06.1: [8086:2c31] type 00 class 0x060000
[    0.888974] pci 0000:fe:06.2: [8086:2c32] type 00 class 0x060000
[    0.888995] pci 0000:fe:06.3: [8086:2c33] type 00 class 0x060000
[    0.889362] PCI: Discovered peer bus ff
[    0.889555] PCI: root bus ff: using default resources
[    0.889556] PCI: Probing PCI hardware (bus ff)
[    0.889577] PCI host bridge to bus 0000:ff
[    0.889775] pci_bus 0000:ff: root bus resource [io  0x0000-0xffff]
[    0.889978] pci_bus 0000:ff: root bus resource [mem 0x00000000-0xffffffffff]
[    0.890184] pci 0000:ff:00.0: [8086:2c40] type 00 class 0x060000
[    0.890203] pci 0000:ff:00.1: [8086:2c01] type 00 class 0x060000
[    0.890224] pci 0000:ff:02.0: [8086:2c10] type 00 class 0x060000
[    0.890246] pci 0000:ff:02.1: [8086:2c11] type 00 class 0x060000
[    0.890265] pci 0000:ff:02.4: [8086:2c14] type 00 class 0x060000
[    0.890283] pci 0000:ff:02.5: [8086:2c15] type 00 class 0x060000
[    0.890304] pci 0000:ff:03.0: [8086:2c18] type 00 class 0x060000
[    0.890322] pci 0000:ff:03.1: [8086:2c19] type 00 class 0x060000
[    0.890340] pci 0000:ff:03.2: [8086:2c1a] type 00 class 0x060000
[    0.890358] pci 0000:ff:03.4: [8086:2c1c] type 00 class 0x060000
[    0.890378] pci 0000:ff:04.0: [8086:2c20] type 00 class 0x060000
[    0.890395] pci 0000:ff:04.1: [8086:2c21] type 00 class 0x060000
[    0.890413] pci 0000:ff:04.2: [8086:2c22] type 00 class 0x060000
[    0.890431] pci 0000:ff:04.3: [8086:2c23] type 00 class 0x060000
[    0.890453] pci 0000:ff:05.0: [8086:2c28] type 00 class 0x060000
[    0.890471] pci 0000:ff:05.1: [8086:2c29] type 00 class 0x060000
[    0.890489] pci 0000:ff:05.2: [8086:2c2a] type 00 class 0x060000
[    0.890507] pci 0000:ff:05.3: [8086:2c2b] type 00 class 0x060000
[    0.890527] pci 0000:ff:06.0: [8086:2c30] type 00 class 0x060000
[    0.890545] pci 0000:ff:06.1: [8086:2c31] type 00 class 0x060000
[    0.890563] pci 0000:ff:06.2: [8086:2c32] type 00 class 0x060000
[    0.890581] pci 0000:ff:06.3: [8086:2c33] type 00 class 0x060000
[    0.890947] PCI: pci_cache_line_size set to 64 bytes
[    0.891307] e820: reserve RAM buffer [mem 0x0009c400-0x0009ffff]
[    0.891309] e820: reserve RAM buffer [mem 0xbf770000-0xbfffffff]
[    0.891428] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.891632] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.892347] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.901920] Switching to clocksource hpet
[    0.909808] pnp: PnP ACPI init
[    0.910008] ACPI: bus type pnp registered
[    0.910308] pnp 00:00: [bus 00-ff]
[    0.910310] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.890203] pci 0000:ff:00.1: [8086:2c01] type 00 class 0x060000
[    0.890224] pci 0000:ff:02.0: [8086:2c10] type 00 class 0x060000
[    0.890246] pci 0000:ff:02.1: [8086:2c11] type 00 class 0x060000
[    0.890265] pci 0000:ff:02.4: [8086:2c14] type 00 class 0x060000
[    0.890283] pci 0000:ff:02.5: [8086:2c15] type 00 class 0x060000
[    0.890304] pci 0000:ff:03.0: [8086:2c18] type 00 class 0x060000
[    0.890322] pci 0000:ff:03.1: [8086:2c19] type 00 class 0x060000
[    0.890340] pci 0000:ff:03.2: [8086:2c1a] type 00 class 0x060000
[    0.890358] pci 0000:ff:03.4: [8086:2c1c] type 00 class 0x060000
[    0.890378] pci 0000:ff:04.0: [8086:2c20] type 00 class 0x060000
[    0.890395] pci 0000:ff:04.1: [8086:2c21] type 00 class 0x060000
[    0.890413] pci 0000:ff:04.2: [8086:2c22] type 00 class 0x060000
[    0.890431] pci 0000:ff:04.3: [8086:2c23] type 00 class 0x060000
[    0.890453] pci 0000:ff:05.0: [8086:2c28] type 00 class 0x060000
[    0.890471] pci 0000:ff:05.1: [8086:2c29] type 00 class 0x060000
[    0.890489] pci 0000:ff:05.2: [8086:2c2a] type 00 class 0x060000
[    0.890507] pci 0000:ff:05.3: [8086:2c2b] type 00 class 0x060000
[    0.890527] pci 0000:ff:06.0: [8086:2c30] type 00 class 0x060000
[    0.890545] pci 0000:ff:06.1: [8086:2c31] type 00 class 0x060000
[    0.890563] pci 0000:ff:06.2: [8086:2c32] type 00 class 0x060000
[    0.890581] pci 0000:ff:06.3: [8086:2c33] type 00 class 0x060000
[    0.890947] PCI: pci_cache_line_size set to 64 bytes
[    0.891307] e820: reserve RAM buffer [mem 0x0009c400-0x0009ffff]
[    0.891309] e820: reserve RAM buffer [mem 0xbf770000-0xbfffffff]
[    0.891428] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.891632] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.892347] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.901920] Switching to clocksource hpet
[    0.909808] pnp: PnP ACPI init
[    0.910008] ACPI: bus type pnp registered
[    0.910308] pnp 00:00: [bus 00-ff]
[    0.910310] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.910312] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.910318] pnp 00:00: [io  0x0d00-0xffff window]
[    0.910320] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.910322] pnp 00:00: [mem 0x000d0000-0x000dffff window]
[    0.910324] pnp 00:00: [mem 0xc0000000-0xdfffffff window]
[    0.910325] pnp 00:00: [mem 0xf0000000-0xfed8ffff window]
[    0.910381] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.910391] pnp 00:01: [mem 0xfbf00000-0xfbffffff]
[    0.910392] pnp 00:01: [mem 0xfc000000-0xfcffffff]
[    0.910394] pnp 00:01: [mem 0xfd000000-0xfdffffff]
[    0.910396] pnp 00:01: [mem 0xfe000000-0xfebfffff]
[    0.910397] pnp 00:01: [mem 0xfec8a000-0xfec8afff]
[    0.910399] pnp 00:01: [mem 0xfed10000-0xfed10fff]
[    0.910467] system 00:01: [mem 0xfbf00000-0xfbffffff] has been reserved
[    0.910668] system 00:01: [mem 0xfc000000-0xfcffffff] has been reserved
[    0.910862] system 00:01: [mem 0xfd000000-0xfdffffff] has been reserved
[    0.911062] system 00:01: [mem 0xfe000000-0xfebfffff] has been reserved
[    0.911263] system 00:01: [mem 0xfec8a000-0xfec8afff] could not be reserved
[    0.911459] system 00:01: [mem 0xfed10000-0xfed10fff] has been reserved
[    0.911660] system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.911705] pnp 00:02: [dma 4]
[    0.911707] pnp 00:02: [io  0x0000-0x000f]
[    0.911708] pnp 00:02: [io  0x0081-0x0083]
[    0.911710] pnp 00:02: [io  0x0087]
[    0.911711] pnp 00:02: [io  0x0089-0x008b]
[    0.911713] pnp 00:02: [io  0x008f]
[    0.911714] pnp 00:02: [io  0x00c0-0x00df]
[    0.911738] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.911746] pnp 00:03: [io  0x0070-0x0071]
[    0.911762] pnp 00:03: [irq 8]
[    0.911783] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.911822] pnp 00:04: [io  0x0061]
[    0.910312] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.910318] pnp 00:00: [io  0x0d00-0xffff window]
[    0.910320] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.910322] pnp 00:00: [mem 0x000d0000-0x000dffff window]
[    0.910324] pnp 00:00: [mem 0xc0000000-0xdfffffff window]
[    0.910325] pnp 00:00: [mem 0xf0000000-0xfed8ffff window]
[    0.910381] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.910391] pnp 00:01: [mem 0xfbf00000-0xfbffffff]
[    0.910392] pnp 00:01: [mem 0xfc000000-0xfcffffff]
[    0.910394] pnp 00:01: [mem 0xfd000000-0xfdffffff]
[    0.910396] pnp 00:01: [mem 0xfe000000-0xfebfffff]
[    0.910397] pnp 00:01: [mem 0xfec8a000-0xfec8afff]
[    0.910399] pnp 00:01: [mem 0xfed10000-0xfed10fff]
[    0.910467] system 00:01: [mem 0xfbf00000-0xfbffffff] has been reserved
[    0.910668] system 00:01: [mem 0xfc000000-0xfcffffff] has been reserved
[    0.910862] system 00:01: [mem 0xfd000000-0xfdffffff] has been reserved
[    0.911062] system 00:01: [mem 0xfe000000-0xfebfffff] has been reserved
[    0.911263] system 00:01: [mem 0xfec8a000-0xfec8afff] could not be reserved
[    0.911459] system 00:01: [mem 0xfed10000-0xfed10fff] has been reserved
[    0.911660] system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.911705] pnp 00:02: [dma 4]
[    0.911707] pnp 00:02: [io  0x0000-0x000f]
[    0.911708] pnp 00:02: [io  0x0081-0x0083]
[    0.911710] pnp 00:02: [io  0x0087]
[    0.911711] pnp 00:02: [io  0x0089-0x008b]
[    0.911713] pnp 00:02: [io  0x008f]
[    0.911714] pnp 00:02: [io  0x00c0-0x00df]
[    0.911738] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.911746] pnp 00:03: [io  0x0070-0x0071]
[    0.911762] pnp 00:03: [irq 8]
[    0.911783] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.911822] pnp 00:04: [io  0x0061]
[    0.911851] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.911858] pnp 00:05: [io  0x00f0-0x00ff]
[    0.911869] pnp 00:05: [irq 13]
[    0.911892] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.912118] pnp 00:06: [io  0x03f8-0x03ff]
[    0.912130] pnp 00:06: [irq 4]
[    0.912132] pnp 00:06: [dma 0 disabled]
[    0.912211] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.912443] pnp 00:07: [io  0x02f8-0x02ff]
[    0.912456] pnp 00:07: [irq 3]
[    0.912457] pnp 00:07: [dma 0 disabled]
[    0.912535] pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.912616] pnp 00:08: [io  0x0000-0xffffffffffffffff disabled]
[    0.912618] pnp 00:08: [io  0x0a00-0x0a0f]
[    0.912619] pnp 00:08: [io  0x0a10-0x0a1f]
[    0.912681] system 00:08: [io  0x0a00-0x0a0f] has been reserved
[    0.912883] system 00:08: [io  0x0a10-0x0a1f] has been reserved
[    0.913079] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.913175] pnp 00:09: [io  0x0010-0x001f]
[    0.913177] pnp 00:09: [io  0x0022-0x003f]
[    0.913178] pnp 00:09: [io  0x0044-0x005f]
[    0.913180] pnp 00:09: [io  0x0062-0x0063]
[    0.913182] pnp 00:09: [io  0x0065-0x006f]
[    0.913183] pnp 00:09: [io  0x0072-0x007f]
[    0.913185] pnp 00:09: [io  0x0080]
[    0.913186] pnp 00:09: [io  0x0084-0x0086]
[    0.913188] pnp 00:09: [io  0x0088]
[    0.913189] pnp 00:09: [io  0x008c-0x008e]
[    0.913194] pnp 00:09: [io  0x0090-0x009f]
[    0.913195] pnp 00:09: [io  0x00a2-0x00bf]
[    0.913197] pnp 00:09: [io  0x00e0-0x00ef]
[    0.913198] pnp 00:09: [io  0x04d0-0x04d1]
[    0.911851] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.911858] pnp 00:05: [io  0x00f0-0x00ff]
[    0.911869] pnp 00:05: [irq 13]
[    0.911892] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.912118] pnp 00:06: [io  0x03f8-0x03ff]
[    0.912130] pnp 00:06: [irq 4]
[    0.912132] pnp 00:06: [dma 0 disabled]
[    0.912211] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.912443] pnp 00:07: [io  0x02f8-0x02ff]
[    0.912456] pnp 00:07: [irq 3]
[    0.912457] pnp 00:07: [dma 0 disabled]
[    0.912535] pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.912616] pnp 00:08: [io  0x0000-0xffffffffffffffff disabled]
[    0.912618] pnp 00:08: [io  0x0a00-0x0a0f]
[    0.912619] pnp 00:08: [io  0x0a10-0x0a1f]
[    0.912681] system 00:08: [io  0x0a00-0x0a0f] has been reserved
[    0.912883] system 00:08: [io  0x0a10-0x0a1f] has been reserved
[    0.913079] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.913175] pnp 00:09: [io  0x0010-0x001f]
[    0.913177] pnp 00:09: [io  0x0022-0x003f]
[    0.913178] pnp 00:09: [io  0x0044-0x005f]
[    0.913180] pnp 00:09: [io  0x0062-0x0063]
[    0.913182] pnp 00:09: [io  0x0065-0x006f]
[    0.913183] pnp 00:09: [io  0x0072-0x007f]
[    0.913185] pnp 00:09: [io  0x0080]
[    0.913186] pnp 00:09: [io  0x0084-0x0086]
[    0.913188] pnp 00:09: [io  0x0088]
[    0.913189] pnp 00:09: [io  0x008c-0x008e]
[    0.913194] pnp 00:09: [io  0x0090-0x009f]
[    0.913195] pnp 00:09: [io  0x00a2-0x00bf]
[    0.913197] pnp 00:09: [io  0x00e0-0x00ef]
[    0.913198] pnp 00:09: [io  0x04d0-0x04d1]
[    0.913200] pnp 00:09: [io  0x0800-0x087f]
[    0.913202] pnp 00:09: [io  0x0000-0xffffffffffffffff disabled]
[    0.913203] pnp 00:09: [io  0x0500-0x057f]
[    0.913205] pnp 00:09: [mem 0xfed1c000-0xfed1ffff]
[    0.913207] pnp 00:09: [mem 0xfed20000-0xfed3ffff]
[    0.913208] pnp 00:09: [mem 0xfed40000-0xfed8ffff]
[    0.913285] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    0.913486] system 00:09: [io  0x0800-0x087f] has been reserved
[    0.913689] system 00:09: [io  0x0500-0x057f] has been reserved
[    0.913893] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.914097] system 00:09: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.914301] system 00:09: [mem 0xfed40000-0xfed8ffff] has been reserved
[    0.914504] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.914558] pnp 00:0a: [mem 0xfed00000-0xfed003ff]
[    0.914588] pnp 00:0a: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.914652] pnp 00:0b: [io  0x0060]
[    0.914654] pnp 00:0b: [io  0x0064]
[    0.914656] pnp 00:0b: [mem 0xfec00000-0xfec00fff]
[    0.914658] pnp 00:0b: [mem 0xfee00000-0xfee00fff]
[    0.914717] system 00:0b: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.914921] system 00:0b: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.915121] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.915520] pnp 00:0c: [io  0x0378-0x037f]
[    0.915532] pnp 00:0c: [irq 7]
[    0.915534] pnp 00:0c: [dma 0 disabled]
[    0.915656] pnp 00:0c: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.915695] pnp 00:0d: [mem 0xe0000000-0xefffffff]
[    0.915761] system 00:0d: [mem 0xe0000000-0xefffffff] has been reserved
[    0.915958] system 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.916136] pnp 00:0e: [io  0x0ca8]
[    0.916138] pnp 00:0e: [io  0x0cac]
[    0.916171] pnp 00:0e: Plug and Play ACPI device, IDs IPI0001 (active)
[    0.913200] pnp 00:09: [io  0x0800-0x087f]
[    0.913202] pnp 00:09: [io  0x0000-0xffffffffffffffff disabled]
[    0.913203] pnp 00:09: [io  0x0500-0x057f]
[    0.913205] pnp 00:09: [mem 0xfed1c000-0xfed1ffff]
[    0.913207] pnp 00:09: [mem 0xfed20000-0xfed3ffff]
[    0.913208] pnp 00:09: [mem 0xfed40000-0xfed8ffff]
[    0.913285] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    0.913486] system 00:09: [io  0x0800-0x087f] has been reserved
[    0.913689] system 00:09: [io  0x0500-0x057f] has been reserved
[    0.913893] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.914097] system 00:09: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.914301] system 00:09: [mem 0xfed40000-0xfed8ffff] has been reserved
[    0.914504] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.914558] pnp 00:0a: [mem 0xfed00000-0xfed003ff]
[    0.914588] pnp 00:0a: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.914652] pnp 00:0b: [io  0x0060]
[    0.914654] pnp 00:0b: [io  0x0064]
[    0.914656] pnp 00:0b: [mem 0xfec00000-0xfec00fff]
[    0.914658] pnp 00:0b: [mem 0xfee00000-0xfee00fff]
[    0.914717] system 00:0b: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.914921] system 00:0b: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.915121] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.915520] pnp 00:0c: [io  0x0378-0x037f]
[    0.915532] pnp 00:0c: [irq 7]
[    0.915534] pnp 00:0c: [dma 0 disabled]
[    0.915656] pnp 00:0c: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.915695] pnp 00:0d: [mem 0xe0000000-0xefffffff]
[    0.915761] system 00:0d: [mem 0xe0000000-0xefffffff] has been reserved
[    0.915958] system 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.916136] pnp 00:0e: [io  0x0ca8]
[    0.916138] pnp 00:0e: [io  0x0cac]
[    0.916171] pnp 00:0e: Plug and Play ACPI device, IDs IPI0001 (active)
[    0.916272] pnp 00:0f: [mem 0x00000000-0x0009ffff]
[    0.916275] pnp 00:0f: [mem 0x000c0000-0x000cffff]
[    0.916276] pnp 00:0f: [mem 0x000e0000-0x000fffff]
[    0.916278] pnp 00:0f: [mem 0x00100000-0xbfffffff]
[    0.916279] pnp 00:0f: [mem 0xfed90000-0xffffffff]
[    0.916351] system 00:0f: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.916554] system 00:0f: [mem 0x000c0000-0x000cffff] could not be reserved
[    0.916753] system 00:0f: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.916955] system 00:0f: [mem 0x00100000-0xbfffffff] could not be reserved
[    0.917157] system 00:0f: [mem 0xfed90000-0xffffffff] could not be reserved
[    0.917363] system 00:0f: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.917498] pnp: PnP ACPI: found 16 devices
[    0.917693] ACPI: ACPI bus type pnp unregistered
[    0.925443] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 04-05] add_size 1000
[    0.925447] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 04-05] add_size 200000
[    0.925459] pci 0000:00:1c.4: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 03-03] add_size 200000
[    0.925471] pci 0000:00:1c.5: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02-02] add_size 200000
[    0.925507] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.925509] pci 0000:00:1c.4: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.925511] pci 0000:00:1c.5: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.925513] pci 0000:00:1c.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.925517] pci 0000:00:1c.0: BAR 15: assigned [mem 0xc0000000-0xc01fffff 64bit pref]
[    0.925800] pci 0000:00:1c.4: BAR 15: assigned [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.926090] pci 0000:00:1c.5: BAR 15: assigned [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.929181] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
[    0.929383] pci 0000:09:00.0: PCI bridge to [bus 0a-0a]
[    0.929583] pci 0000:00:01.0: PCI bridge to [bus 09-0a]
[    0.929792] pci 0000:00:03.0: PCI bridge to [bus 08-08]
[    0.929994] pci 0000:00:03.0:   bridge window [io  0xe000-0xefff]
[    0.930197] pci 0000:00:03.0:   bridge window [mem 0xfbe00000-0xfbefffff]
[    0.930388] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.930677] pci 0000:00:07.0: PCI bridge to [bus 07-07]
[    0.916272] pnp 00:0f: [mem 0x00000000-0x0009ffff]
[    0.916275] pnp 00:0f: [mem 0x000c0000-0x000cffff]
[    0.916276] pnp 00:0f: [mem 0x000e0000-0x000fffff]
[    0.916278] pnp 00:0f: [mem 0x00100000-0xbfffffff]
[    0.916279] pnp 00:0f: [mem 0xfed90000-0xffffffff]
[    0.916351] system 00:0f: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.916554] system 00:0f: [mem 0x000c0000-0x000cffff] could not be reserved
[    0.916753] system 00:0f: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.916955] system 00:0f: [mem 0x00100000-0xbfffffff] could not be reserved
[    0.917157] system 00:0f: [mem 0xfed90000-0xffffffff] could not be reserved
[    0.917363] system 00:0f: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.917498] pnp: PnP ACPI: found 16 devices
[    0.917693] ACPI: ACPI bus type pnp unregistered
[    0.925443] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 04-05] add_size 1000
[    0.925447] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 04-05] add_size 200000
[    0.925459] pci 0000:00:1c.4: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 03-03] add_size 200000
[    0.925471] pci 0000:00:1c.5: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02-02] add_size 200000
[    0.925507] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.925509] pci 0000:00:1c.4: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.925511] pci 0000:00:1c.5: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.925513] pci 0000:00:1c.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.925517] pci 0000:00:1c.0: BAR 15: assigned [mem 0xc0000000-0xc01fffff 64bit pref]
[    0.925800] pci 0000:00:1c.4: BAR 15: assigned [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.926090] pci 0000:00:1c.5: BAR 15: assigned [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.929181] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
[    0.929383] pci 0000:09:00.0: PCI bridge to [bus 0a-0a]
[    0.929583] pci 0000:00:01.0: PCI bridge to [bus 09-0a]
[    0.929792] pci 0000:00:03.0: PCI bridge to [bus 08-08]
[    0.929994] pci 0000:00:03.0:   bridge window [io  0xe000-0xefff]
[    0.930197] pci 0000:00:03.0:   bridge window [mem 0xfbe00000-0xfbefffff]
[    0.930388] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.930677] pci 0000:00:07.0: PCI bridge to [bus 07-07]
[    0.930885] pci 0000:00:09.0: PCI bridge to [bus 06-06]
[    0.931090] pci 0000:00:09.0:   bridge window [io  0xd000-0xdfff]
[    0.931292] pci 0000:00:09.0:   bridge window [mem 0xfba00000-0xfbdfffff]
[    0.931497] pci 0000:04:00.0: PCI bridge to [bus 05-05]
[    0.931698] pci 0000:04:00.0:   bridge window [mem 0xfb900000-0xfb9fffff]
[    0.931911] pci 0000:00:1c.0: PCI bridge to [bus 04-05]
[    0.932111] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    0.932318] pci 0000:00:1c.0:   bridge window [mem 0xfb900000-0xfb9fffff]
[    0.932521] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc01fffff 64bit pref]
[    0.932802] pci 0000:00:1c.4: PCI bridge to [bus 03-03]
[    0.933000] pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
[    0.933197] pci 0000:00:1c.4:   bridge window [mem 0xfb800000-0xfb8fffff]
[    0.933395] pci 0000:00:1c.4:   bridge window [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.933683] pci 0000:00:1c.5: PCI bridge to [bus 02-02]
[    0.933883] pci 0000:00:1c.5:   bridge window [io  0xb000-0xbfff]
[    0.934080] pci 0000:00:1c.5:   bridge window [mem 0xfb700000-0xfb7fffff]
[    0.934279] pci 0000:00:1c.5:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.934566] pci 0000:00:1e.0: PCI bridge to [bus 01-01]
[    0.934784] pci 0000:00:1c.0: enabling device (0106 -> 0107)
[    0.935045] pci 0000:00:1e.0: setting latency timer to 64
[    0.935054] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.935056] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.935058] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.935059] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.935061] pci_bus 0000:00: resource 8 [mem 0xc0000000-0xdfffffff]
[    0.935063] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfed8ffff]
[    0.935065] pci_bus 0000:08: resource 0 [io  0xe000-0xefff]
[    0.935067] pci_bus 0000:08: resource 1 [mem 0xfbe00000-0xfbefffff]
[    0.935069] pci_bus 0000:08: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.935071] pci_bus 0000:06: resource 0 [io  0xd000-0xdfff]
[    0.935073] pci_bus 0000:06: resource 1 [mem 0xfba00000-0xfbdfffff]
[    0.935075] pci_bus 0000:04: resource 0 [io  0x1000-0x1fff]
[    0.930885] pci 0000:00:09.0: PCI bridge to [bus 06-06]
[    0.931090] pci 0000:00:09.0:   bridge window [io  0xd000-0xdfff]
[    0.931292] pci 0000:00:09.0:   bridge window [mem 0xfba00000-0xfbdfffff]
[    0.931497] pci 0000:04:00.0: PCI bridge to [bus 05-05]
[    0.931698] pci 0000:04:00.0:   bridge window [mem 0xfb900000-0xfb9fffff]
[    0.931911] pci 0000:00:1c.0: PCI bridge to [bus 04-05]
[    0.932111] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    0.932318] pci 0000:00:1c.0:   bridge window [mem 0xfb900000-0xfb9fffff]
[    0.932521] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc01fffff 64bit pref]
[    0.932802] pci 0000:00:1c.4: PCI bridge to [bus 03-03]
[    0.933000] pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
[    0.933197] pci 0000:00:1c.4:   bridge window [mem 0xfb800000-0xfb8fffff]
[    0.933395] pci 0000:00:1c.4:   bridge window [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.933683] pci 0000:00:1c.5: PCI bridge to [bus 02-02]
[    0.933883] pci 0000:00:1c.5:   bridge window [io  0xb000-0xbfff]
[    0.934080] pci 0000:00:1c.5:   bridge window [mem 0xfb700000-0xfb7fffff]
[    0.934279] pci 0000:00:1c.5:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.934566] pci 0000:00:1e.0: PCI bridge to [bus 01-01]
[    0.934784] pci 0000:00:1c.0: enabling device (0106 -> 0107)
[    0.935045] pci 0000:00:1e.0: setting latency timer to 64
[    0.935054] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.935056] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.935058] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.935059] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.935061] pci_bus 0000:00: resource 8 [mem 0xc0000000-0xdfffffff]
[    0.935063] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfed8ffff]
[    0.935065] pci_bus 0000:08: resource 0 [io  0xe000-0xefff]
[    0.935067] pci_bus 0000:08: resource 1 [mem 0xfbe00000-0xfbefffff]
[    0.935069] pci_bus 0000:08: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.935071] pci_bus 0000:06: resource 0 [io  0xd000-0xdfff]
[    0.935073] pci_bus 0000:06: resource 1 [mem 0xfba00000-0xfbdfffff]
[    0.935075] pci_bus 0000:04: resource 0 [io  0x1000-0x1fff]
[    0.935077] pci_bus 0000:04: resource 1 [mem 0xfb900000-0xfb9fffff]
[    0.935079] pci_bus 0000:04: resource 2 [mem 0xc0000000-0xc01fffff 64bit pref]
[    0.935081] pci_bus 0000:05: resource 1 [mem 0xfb900000-0xfb9fffff]
[    0.935083] pci_bus 0000:03: resource 0 [io  0xc000-0xcfff]
[    0.935085] pci_bus 0000:03: resource 1 [mem 0xfb800000-0xfb8fffff]
[    0.935087] pci_bus 0000:03: resource 2 [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.935089] pci_bus 0000:02: resource 0 [io  0xb000-0xbfff]
[    0.935091] pci_bus 0000:02: resource 1 [mem 0xfb700000-0xfb7fffff]
[    0.935093] pci_bus 0000:02: resource 2 [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.935095] pci_bus 0000:01: resource 4 [io  0x0000-0x0cf7]
[    0.935097] pci_bus 0000:01: resource 5 [io  0x0d00-0xffff]
[    0.935098] pci_bus 0000:01: resource 6 [mem 0x000a0000-0x000bffff]
[    0.935100] pci_bus 0000:01: resource 7 [mem 0x000d0000-0x000dffff]
[    0.935102] pci_bus 0000:01: resource 8 [mem 0xc0000000-0xdfffffff]
[    0.935104] pci_bus 0000:01: resource 9 [mem 0xf0000000-0xfed8ffff]
[    0.935106] pci_bus 0000:fe: resource 4 [io  0x0000-0xffff]
[    0.935108] pci_bus 0000:fe: resource 5 [mem 0x00000000-0xffffffffff]
[    0.935111] pci_bus 0000:ff: resource 4 [io  0x0000-0xffff]
[    0.935112] pci_bus 0000:ff: resource 5 [mem 0x00000000-0xffffffffff]
[    0.935161] NET: Registered protocol family 2
[    0.935668] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.937068] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.938925] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.939314] TCP: Hash tables configured (established 524288 bind 65536)
[    0.939512] TCP: reno registered
[    0.939735] UDP hash table entries: 16384 (order: 7, 524288 bytes)
[    0.940056] UDP-Lite hash table entries: 16384 (order: 7, 524288 bytes)
[    0.940634] NET: Registered protocol family 1
[    0.940930] RPC: Registered named UNIX socket transport module.
[    0.941133] RPC: Registered udp transport module.
[    0.941331] RPC: Registered tcp transport module.
[    0.941519] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.935077] pci_bus 0000:04: resource 1 [mem 0xfb900000-0xfb9fffff]
[    0.935079] pci_bus 0000:04: resource 2 [mem 0xc0000000-0xc01fffff 64bit pref]
[    0.935081] pci_bus 0000:05: resource 1 [mem 0xfb900000-0xfb9fffff]
[    0.935083] pci_bus 0000:03: resource 0 [io  0xc000-0xcfff]
[    0.935085] pci_bus 0000:03: resource 1 [mem 0xfb800000-0xfb8fffff]
[    0.935087] pci_bus 0000:03: resource 2 [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.935089] pci_bus 0000:02: resource 0 [io  0xb000-0xbfff]
[    0.935091] pci_bus 0000:02: resource 1 [mem 0xfb700000-0xfb7fffff]
[    0.935093] pci_bus 0000:02: resource 2 [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.935095] pci_bus 0000:01: resource 4 [io  0x0000-0x0cf7]
[    0.935097] pci_bus 0000:01: resource 5 [io  0x0d00-0xffff]
[    0.935098] pci_bus 0000:01: resource 6 [mem 0x000a0000-0x000bffff]
[    0.935100] pci_bus 0000:01: resource 7 [mem 0x000d0000-0x000dffff]
[    0.935102] pci_bus 0000:01: resource 8 [mem 0xc0000000-0xdfffffff]
[    0.935104] pci_bus 0000:01: resource 9 [mem 0xf0000000-0xfed8ffff]
[    0.935106] pci_bus 0000:fe: resource 4 [io  0x0000-0xffff]
[    0.935108] pci_bus 0000:fe: resource 5 [mem 0x00000000-0xffffffffff]
[    0.935111] pci_bus 0000:ff: resource 4 [io  0x0000-0xffff]
[    0.935112] pci_bus 0000:ff: resource 5 [mem 0x00000000-0xffffffffff]
[    0.935161] NET: Registered protocol family 2
[    0.935668] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.937068] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.938925] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.939314] TCP: Hash tables configured (established 524288 bind 65536)
[    0.939512] TCP: reno registered
[    0.939735] UDP hash table entries: 16384 (order: 7, 524288 bytes)
[    0.940056] UDP-Lite hash table entries: 16384 (order: 7, 524288 bytes)
[    0.940634] NET: Registered protocol family 1
[    0.940930] RPC: Registered named UNIX socket transport module.
[    0.941133] RPC: Registered udp transport module.
[    0.941331] RPC: Registered tcp transport module.
[    0.941519] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.942114] pci 0000:09:00.0: rerouting interrupts for [8086:032c]
[    0.942332] pci 0000:08:00.0: Boot video device
[    0.942560] PCI: CLS 256 bytes, default 64
[    0.942596] Trying to unpack rootfs image as initramfs...
[    1.087218] Freeing initrd memory: 7412k freed
[    1.088820] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.089027] software IO TLB [mem 0xbb756000-0xbf755fff] (64MB) mapped at [ffff8800bb756000-ffff8800bf755fff]
[    1.089535] kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL does not work properly. Using workaround
[    1.092063] microcode: CPU0 sig=0x106a5, pf=0x1, revision=0x11
[    1.092274] microcode: CPU1 sig=0x106a5, pf=0x1, revision=0x11
[    1.092487] microcode: CPU2 sig=0x106a5, pf=0x1, revision=0x11
[    1.092697] microcode: CPU3 sig=0x106a5, pf=0x1, revision=0x11
[    1.092908] microcode: CPU4 sig=0x106a5, pf=0x1, revision=0x11
[    1.093125] microcode: CPU5 sig=0x106a5, pf=0x1, revision=0x11
[    1.093335] microcode: CPU6 sig=0x106a5, pf=0x1, revision=0x11
[    1.093544] microcode: CPU7 sig=0x106a5, pf=0x1, revision=0x11
[    1.093750] microcode: CPU8 sig=0x106a5, pf=0x1, revision=0x11
[    1.093958] microcode: CPU9 sig=0x106a5, pf=0x1, revision=0x11
[    1.094169] microcode: CPU10 sig=0x106a5, pf=0x1, revision=0x11
[    1.094380] microcode: CPU11 sig=0x106a5, pf=0x1, revision=0x11
[    1.094591] microcode: CPU12 sig=0x106a5, pf=0x1, revision=0x11
[    1.094803] microcode: CPU13 sig=0x106a5, pf=0x1, revision=0x11
[    1.095015] microcode: CPU14 sig=0x106a5, pf=0x1, revision=0x11
[    1.095229] microcode: CPU15 sig=0x106a5, pf=0x1, revision=0x11
[    1.095473] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.096510] sha1_ssse3: Using SSSE3 optimized SHA-1 implementation
[    1.096885] audit: initializing netlink socket (disabled)
[    1.097094] type=2000 audit(1346309745.906:1): initialized
[    1.138937] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.143174] VFS: Disk quotas dquot_6.5.2
[    1.143426] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.144299] NFS: Registering the id_resolver key type
[    0.942114] pci 0000:09:00.0: rerouting interrupts for [8086:032c]
[    0.942332] pci 0000:08:00.0: Boot video device
[    0.942560] PCI: CLS 256 bytes, default 64
[    0.942596] Trying to unpack rootfs image as initramfs...
[    1.087218] Freeing initrd memory: 7412k freed
[    1.088820] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.089027] software IO TLB [mem 0xbb756000-0xbf755fff] (64MB) mapped at [ffff8800bb756000-ffff8800bf755fff]
[    1.089535] kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL does not work properly. Using workaround
[    1.092063] microcode: CPU0 sig=0x106a5, pf=0x1, revision=0x11
[    1.092274] microcode: CPU1 sig=0x106a5, pf=0x1, revision=0x11
[    1.092487] microcode: CPU2 sig=0x106a5, pf=0x1, revision=0x11
[    1.092697] microcode: CPU3 sig=0x106a5, pf=0x1, revision=0x11
[    1.092908] microcode: CPU4 sig=0x106a5, pf=0x1, revision=0x11
[    1.093125] microcode: CPU5 sig=0x106a5, pf=0x1, revision=0x11
[    1.093335] microcode: CPU6 sig=0x106a5, pf=0x1, revision=0x11
[    1.093544] microcode: CPU7 sig=0x106a5, pf=0x1, revision=0x11
[    1.093750] microcode: CPU8 sig=0x106a5, pf=0x1, revision=0x11
[    1.093958] microcode: CPU9 sig=0x106a5, pf=0x1, revision=0x11
[    1.094169] microcode: CPU10 sig=0x106a5, pf=0x1, revision=0x11
[    1.094380] microcode: CPU11 sig=0x106a5, pf=0x1, revision=0x11
[    1.094591] microcode: CPU12 sig=0x106a5, pf=0x1, revision=0x11
[    1.094803] microcode: CPU13 sig=0x106a5, pf=0x1, revision=0x11
[    1.095015] microcode: CPU14 sig=0x106a5, pf=0x1, revision=0x11
[    1.095229] microcode: CPU15 sig=0x106a5, pf=0x1, revision=0x11
[    1.095473] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.096510] sha1_ssse3: Using SSSE3 optimized SHA-1 implementation
[    1.096885] audit: initializing netlink socket (disabled)
[    1.097094] type=2000 audit(1346309745.906:1): initialized
[    1.138937] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.143174] VFS: Disk quotas dquot_6.5.2
[    1.143426] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.144299] NFS: Registering the id_resolver key type
[    1.144513] Key type id_resolver registered
[    1.144855] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    1.145058] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    1.145527] Key type cifs.spnego registered
[    1.145726] NTFS driver 2.1.30 [Flags: R/W].
[    1.146039] fuse init (API version 7.19)
[    1.146343] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    1.147218] Btrfs loaded
[    1.147423] msgmni has been set to 32768
[    1.151094] async_tx: api initialized (async)
[    1.151324] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.151608] io scheduler noop registered
[    1.151815] io scheduler deadline registered
[    1.152044] io scheduler cfq registered (default)
[    1.152563] pcieport 0000:00:1c.0: irq 65 for MSI/MSI-X
[    1.152665] pcieport 0000:00:1c.4: irq 66 for MSI/MSI-X
[    1.152764] pcieport 0000:00:1c.5: irq 67 for MSI/MSI-X
[    1.152846] ioapic: probe of 0000:00:13.0 failed with error -22
[    1.153052] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.153271] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.153471] cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver version: 0.1
[    1.153754] cpcihp_generic: not configured, disabling.
[    1.154003] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    1.154199] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.154736] vga16fb: initializing
[    1.154738] vga16fb: mapped to 0xffff8800000a0000
[    1.364369] Console: switching to colour frame buffer device 80x30
[    1.374362] fb0: VGA16 VGA frame buffer device
[    1.374848] intel_idle: MWAIT substates: 0x1120
[    1.374872] intel_idle: v0.4 model 0x1A
[    1.374874] intel_idle: lapic_timer_reliable_states 0x2
[    1.375074] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    1.144513] Key type id_resolver registered
[    1.144855] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    1.145058] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    1.145527] Key type cifs.spnego registered
[    1.145726] NTFS driver 2.1.30 [Flags: R/W].
[    1.146039] fuse init (API version 7.19)
[    1.146343] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    1.147218] Btrfs loaded
[    1.147423] msgmni has been set to 32768
[    1.151094] async_tx: api initialized (async)
[    1.151324] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.151608] io scheduler noop registered
[    1.151815] io scheduler deadline registered
[    1.152044] io scheduler cfq registered (default)
[    1.152563] pcieport 0000:00:1c.0: irq 65 for MSI/MSI-X
[    1.152665] pcieport 0000:00:1c.4: irq 66 for MSI/MSI-X
[    1.152764] pcieport 0000:00:1c.5: irq 67 for MSI/MSI-X
[    1.152846] ioapic: probe of 0000:00:13.0 failed with error -22
[    1.153052] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.153271] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.153471] cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver version: 0.1
[    1.153754] cpcihp_generic: not configured, disabling.
[    1.154003] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    1.154199] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.154736] vga16fb: initializing
[    1.154738] vga16fb: mapped to 0xffff8800000a0000
[    1.364369] Console: switching to colour frame buffer device 80x30
[    1.374362] fb0: VGA16 VGA frame buffer device
[    1.374848] intel_idle: MWAIT substates: 0x1120
[    1.374872] intel_idle: v0.4 model 0x1A
[    1.374874] intel_idle: lapic_timer_reliable_states 0x2
[    1.375074] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    1.375764] ACPI: Power Button [PWRB]
[    1.376245] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.424445] ACPI: Power Button [PWRF]
[    1.448820] ACPI: Requesting acpi_cpufreq
[    1.480437] GHES: HEST is not enabled!
[    1.504171] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    1.504289] ioatdma 0000:00:16.0: irq 68 for MSI/MSI-X
[    1.504583] ioatdma 0000:00:16.1: irq 69 for MSI/MSI-X
[    1.504778] ioatdma 0000:00:16.2: irq 70 for MSI/MSI-X
[    1.504964] ioatdma 0000:00:16.3: irq 71 for MSI/MSI-X
[    1.505147] ioatdma 0000:00:16.4: irq 72 for MSI/MSI-X
[    1.505333] ioatdma 0000:00:16.5: irq 73 for MSI/MSI-X
[    1.505520] ioatdma 0000:00:16.6: irq 74 for MSI/MSI-X
[    1.505704] ioatdma 0000:00:16.7: irq 75 for MSI/MSI-X
[    1.505948] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.527086] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.548148] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.569516] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.590670] 00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.590961] Non-volatile memory driver v1.3
[    1.591101] Linux agpgart interface v0.103
[    1.591128] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    1.591129] Hangcheck: Using getrawmonotonic().
[    1.591141] [drm] Initialized drm 1.1.0 20060810
[    1.591153] [drm] radeon defaulting to kernel modesetting.
[    1.591153] [drm] radeon kernel modesetting enabled.
[    1.591191] checking generic (a0000 10000) vs hw (d0000000 10000000)
[    1.591192] fb: conflicting fb hw usage radeondrmfb vs VGA16 VGA - removing generic driver
[    1.889655] Console: switching to colour VGA+ 80x25
[    1.890639] [drm] initializing kernel modesetting (BARTS 0x1002:0x6738 0x174B:0x174B).
[    1.890962] [drm] register mmio base: 0xFBEC0000
[    1.891163] [drm] register mmio size: 131072
[    1.375764] ACPI: Power Button [PWRB]
[    1.376245] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.424445] ACPI: Power Button [PWRF]
[    1.448820] ACPI: Requesting acpi_cpufreq
[    1.480437] GHES: HEST is not enabled!
[    1.504171] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    1.504289] ioatdma 0000:00:16.0: irq 68 for MSI/MSI-X
[    1.504583] ioatdma 0000:00:16.1: irq 69 for MSI/MSI-X
[    1.504778] ioatdma 0000:00:16.2: irq 70 for MSI/MSI-X
[    1.504964] ioatdma 0000:00:16.3: irq 71 for MSI/MSI-X
[    1.505147] ioatdma 0000:00:16.4: irq 72 for MSI/MSI-X
[    1.505333] ioatdma 0000:00:16.5: irq 73 for MSI/MSI-X
[    1.505520] ioatdma 0000:00:16.6: irq 74 for MSI/MSI-X
[    1.505704] ioatdma 0000:00:16.7: irq 75 for MSI/MSI-X
[    1.505948] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.527086] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.548148] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.569516] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.590670] 00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.590961] Non-volatile memory driver v1.3
[    1.591101] Linux agpgart interface v0.103
[    1.591128] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    1.591129] Hangcheck: Using getrawmonotonic().
[    1.591141] [drm] Initialized drm 1.1.0 20060810
[    1.591153] [drm] radeon defaulting to kernel modesetting.
[    1.591153] [drm] radeon kernel modesetting enabled.
[    1.591191] checking generic (a0000 10000) vs hw (d0000000 10000000)
[    1.591192] fb: conflicting fb hw usage radeondrmfb vs VGA16 VGA - removing generic driver
[    1.889655] Console: switching to colour VGA+ 80x25
[    1.890639] [drm] initializing kernel modesetting (BARTS 0x1002:0x6738 0x174B:0x174B).
[    1.890962] [drm] register mmio base: 0xFBEC0000
[    1.891163] [drm] register mmio size: 131072
[    1.891420] ATOM BIOS: BARTS
[    1.891650] radeon 0000:08:00.0: VRAM: 1024M 0x0000000000000000 - 0x000000003FFFFFFF (1024M used)
[    1.891941] radeon 0000:08:00.0: GTT: 512M 0x0000000040000000 - 0x000000005FFFFFFF
[    1.892233] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[    1.892517] [drm] Detected VRAM RAM=1024M, BAR=256M
[    1.892714] [drm] RAM width 256bits DDR
[    1.892959] [TTM] Zone  kernel: Available graphics memory: 12336352 kiB
[    1.893163] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    1.893365] [TTM] Initializing pool allocator
[    1.893561] [TTM] Initializing DMA pool allocator
[    1.893776] [drm] radeon: 1024M of VRAM memory ready
[    1.893987] [drm] radeon: 512M of GTT memory ready.
[    1.894203] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    1.894404] [drm] Driver supports precise vblank timestamp query.
[    1.894640] radeon 0000:08:00.0: irq 76 for MSI/MSI-X
[    1.894649] radeon 0000:08:00.0: radeon: using MSI.
[    1.894885] [drm] radeon: irq initialized.
[    1.895083] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    1.895874] [drm] Loading BARTS Microcode
[    1.898783] [drm] PCIE GART of 512M enabled (table at 0x0000000000040000).
[    1.899139] radeon 0000:08:00.0: WB enabled
[    1.899337] radeon 0000:08:00.0: fence driver on ring 0 use gpu addr 0x0000000040000c00 and cpu addr 0xffff88032d6dec00
[    1.916512] [drm] ring test on 0 succeeded in 3 usecs
[    1.917032] [drm] ib test on ring 0 succeeded in 0 usecs
[    1.917738] [drm] Radeon Display Connectors
[    1.917936] [drm] Connector 0:
[    1.918133] [drm]   DP-1
[    1.918327] [drm]   HPD4
[    1.918523] [drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438 0x643c 0x643c
[    1.918807] [drm]   Encoders:
[    1.919001] [drm]     DFP1: INTERNAL_UNIPHY2
[    1.919196] [drm] Connector 1:
[    1.891420] ATOM BIOS: BARTS
[    1.891650] radeon 0000:08:00.0: VRAM: 1024M 0x0000000000000000 - 0x000000003FFFFFFF (1024M used)
[    1.891941] radeon 0000:08:00.0: GTT: 512M 0x0000000040000000 - 0x000000005FFFFFFF
[    1.892233] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[    1.892517] [drm] Detected VRAM RAM=1024M, BAR=256M
[    1.892714] [drm] RAM width 256bits DDR
[    1.892959] [TTM] Zone  kernel: Available graphics memory: 12336352 kiB
[    1.893163] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    1.893365] [TTM] Initializing pool allocator
[    1.893561] [TTM] Initializing DMA pool allocator
[    1.893776] [drm] radeon: 1024M of VRAM memory ready
[    1.893987] [drm] radeon: 512M of GTT memory ready.
[    1.894203] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    1.894404] [drm] Driver supports precise vblank timestamp query.
[    1.894640] radeon 0000:08:00.0: irq 76 for MSI/MSI-X
[    1.894649] radeon 0000:08:00.0: radeon: using MSI.
[    1.894885] [drm] radeon: irq initialized.
[    1.895083] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    1.895874] [drm] Loading BARTS Microcode
[    1.898783] [drm] PCIE GART of 512M enabled (table at 0x0000000000040000).
[    1.899139] radeon 0000:08:00.0: WB enabled
[    1.899337] radeon 0000:08:00.0: fence driver on ring 0 use gpu addr 0x0000000040000c00 and cpu addr 0xffff88032d6dec00
[    1.916512] [drm] ring test on 0 succeeded in 3 usecs
[    1.917032] [drm] ib test on ring 0 succeeded in 0 usecs
[    1.917738] [drm] Radeon Display Connectors
[    1.917936] [drm] Connector 0:
[    1.918133] [drm]   DP-1
[    1.918327] [drm]   HPD4
[    1.918523] [drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438 0x643c 0x643c
[    1.918807] [drm]   Encoders:
[    1.919001] [drm]     DFP1: INTERNAL_UNIPHY2
[    1.919196] [drm] Connector 1:
[    1.919391] [drm]   HDMI-A-1
[    1.919585] [drm]   HPD3
[    1.919779] [drm]   DDC: 0x6460 0x6460 0x6464 0x6464 0x6468 0x6468 0x646c 0x646c
[    1.920064] [drm]   Encoders:
[    1.920256] [drm]     DFP2: INTERNAL_UNIPHY2
[    1.920453] [drm] Connector 2:
[    1.920664] [drm]   DVI-D-1
[    1.920860] [drm]   HPD1
[    1.921052] [drm]   DDC: 0x6480 0x6480 0x6484 0x6484 0x6488 0x6488 0x648c 0x648c
[    1.921341] [drm]   Encoders:
[    1.921537] [drm]     DFP3: INTERNAL_UNIPHY1
[    1.921733] [drm] Connector 3:
[    1.921929] [drm]   DVI-I-1
[    1.922124] [drm]   HPD6
[    1.922317] [drm]   DDC: 0x6470 0x6470 0x6474 0x6474 0x6478 0x6478 0x647c 0x647c
[    1.922602] [drm]   Encoders:
[    1.922797] [drm]     DFP4: INTERNAL_UNIPHY
[    1.922995] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    1.923301] [drm] Internal thermal controller with fan control
[    1.924693] [drm] radeon: power management initialized
[    2.057653] [drm] fb mappable at 0xD0142000
[    2.057787] [drm] vram apper at 0xD0000000
[    2.057919] [drm] size 16384000
[    2.058051] [drm] fb depth is 24
[    2.058179] [drm]    pitch is 10240
[    2.058375] fbcon: radeondrmfb (fb0) is primary device
[    2.090270] Refined TSC clocksource calibration: 2266.746 MHz.
[    2.583113] Console: switching to colour frame buffer device 240x75
[    2.589910] fb0: radeondrmfb frame buffer device
[    2.589910] drm: registered panic notifier
[    2.589924] [drm] Initialized radeon 2.17.0 20080528 for 0000:08:00.0 on minor 0
[    2.589983] [drm:i915_init] *ERROR* drm/i915 can't work without intel_agp module!
[    1.919391] [drm]   HDMI-A-1
[    1.919585] [drm]   HPD3
[    1.919779] [drm]   DDC: 0x6460 0x6460 0x6464 0x6464 0x6468 0x6468 0x646c 0x646c
[    1.920064] [drm]   Encoders:
[    1.920256] [drm]     DFP2: INTERNAL_UNIPHY2
[    1.920453] [drm] Connector 2:
[    1.920664] [drm]   DVI-D-1
[    1.920860] [drm]   HPD1
[    1.921052] [drm]   DDC: 0x6480 0x6480 0x6484 0x6484 0x6488 0x6488 0x648c 0x648c
[    1.921341] [drm]   Encoders:
[    1.921537] [drm]     DFP3: INTERNAL_UNIPHY1
[    1.921733] [drm] Connector 3:
[    1.921929] [drm]   DVI-I-1
[    1.922124] [drm]   HPD6
[    1.922317] [drm]   DDC: 0x6470 0x6470 0x6474 0x6474 0x6478 0x6478 0x647c 0x647c
[    1.922602] [drm]   Encoders:
[    1.922797] [drm]     DFP4: INTERNAL_UNIPHY
[    1.922995] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    1.923301] [drm] Internal thermal controller with fan control
[    1.924693] [drm] radeon: power management initialized
[    2.057653] [drm] fb mappable at 0xD0142000
[    2.057787] [drm] vram apper at 0xD0000000
[    2.057919] [drm] size 16384000
[    2.058051] [drm] fb depth is 24
[    2.058179] [drm]    pitch is 10240
[    2.058375] fbcon: radeondrmfb (fb0) is primary device
[    2.090270] Refined TSC clocksource calibration: 2266.746 MHz.
[    2.583113] Console: switching to colour frame buffer device 240x75
[    2.589910] fb0: radeondrmfb frame buffer device
[    2.589910] drm: registered panic notifier
[    2.589924] [drm] Initialized radeon 2.17.0 20080528 for 0000:08:00.0 on minor 0
[    2.589983] [drm:i915_init] *ERROR* drm/i915 can't work without intel_agp module!
[    2.589991] usbcore: registered new interface driver udl
[    2.591546] brd: module loaded
[    2.592392] loop: module loaded
[    2.592630] Loading iSCSI transport class v2.0-870.
[    2.592798] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[    2.592885] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[    2.592942] megasas: 00.00.06.15-rc1 Mon. Mar. 19 17:00:00 PDT 2012
[    2.592990] mpt2sas version 13.100.00.00 loaded
[    2.593120] ahci 0000:00:1f.2: version 3.0
[    2.593188] ahci 0000:00:1f.2: irq 77 for MSI/MSI-X
[    2.593232] ahci: SSS flag set, parallel bus scan disabled
[    2.593305] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    2.593346] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc ems sxs 
[    2.593395] ahci 0000:00:1f.2: setting latency timer to 64
[    2.626378] scsi0 : ahci
[    2.626478] scsi1 : ahci
[    2.626588] scsi2 : ahci
[    2.626672] scsi3 : ahci
[    2.626760] scsi4 : ahci
[    2.626845] scsi5 : ahci
[    2.626972] ata1: SATA max UDMA/133 abar m2048@0xfb6fc000 port 0xfb6fc100 irq 77
[    2.627014] ata2: SATA max UDMA/133 abar m2048@0xfb6fc000 port 0xfb6fc180 irq 77
[    2.627056] ata3: SATA max UDMA/133 abar m2048@0xfb6fc000 port 0xfb6fc200 irq 77
[    2.627093] ata4: SATA max UDMA/133 abar m2048@0xfb6fc000 port 0xfb6fc280 irq 77
[    2.627134] ata5: SATA max UDMA/133 abar m2048@0xfb6fc000 port 0xfb6fc300 irq 77
[    2.627175] ata6: SATA max UDMA/133 abar m2048@0xfb6fc000 port 0xfb6fc380 irq 77
[    2.627397] tun: Universal TUN/TAP device driver, 1.6
[    2.627424] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    2.627561] PPP generic driver version 2.4.2
[    2.627631] Fusion MPT base driver 3.04.20
[    2.627653] Copyright (c) 1999-2008 LSI Corporation
[    2.627682] Fusion MPT SPI Host driver 3.04.20
[    2.589991] usbcore: registered new interface driver udl
[    2.591546] brd: module loaded
[    2.592392] loop: module loaded
[    2.592630] Loading iSCSI transport class v2.0-870.
[    2.592798] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[    2.592885] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[    2.592942] megasas: 00.00.06.15-rc1 Mon. Mar. 19 17:00:00 PDT 2012
[    2.592990] mpt2sas version 13.100.00.00 loaded
[    2.593120] ahci 0000:00:1f.2: version 3.0
[    2.593188] ahci 0000:00:1f.2: irq 77 for MSI/MSI-X
[    2.593232] ahci: SSS flag set, parallel bus scan disabled
[    2.593305] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    2.593346] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc ems sxs 
[    2.593395] ahci 0000:00:1f.2: setting latency timer to 64
[    2.626378] scsi0 : ahci
[    2.626478] scsi1 : ahci
[    2.626588] scsi2 : ahci
[    2.626672] scsi3 : ahci
[    2.626760] scsi4 : ahci
[    2.626845] scsi5 : ahci
[    2.626972] ata1: SATA max UDMA/133 abar m2048@0xfb6fc000 port 0xfb6fc100 irq 77
[    2.627014] ata2: SATA max UDMA/133 abar m2048@0xfb6fc000 port 0xfb6fc180 irq 77
[    2.627056] ata3: SATA max UDMA/133 abar m2048@0xfb6fc000 port 0xfb6fc200 irq 77
[    2.627093] ata4: SATA max UDMA/133 abar m2048@0xfb6fc000 port 0xfb6fc280 irq 77
[    2.627134] ata5: SATA max UDMA/133 abar m2048@0xfb6fc000 port 0xfb6fc300 irq 77
[    2.627175] ata6: SATA max UDMA/133 abar m2048@0xfb6fc000 port 0xfb6fc380 irq 77
[    2.627397] tun: Universal TUN/TAP device driver, 1.6
[    2.627424] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    2.627561] PPP generic driver version 2.4.2
[    2.627631] Fusion MPT base driver 3.04.20
[    2.627653] Copyright (c) 1999-2008 LSI Corporation
[    2.627682] Fusion MPT SPI Host driver 3.04.20
[    2.627720] Fusion MPT FC Host driver 3.04.20
[    2.627759] Fusion MPT SAS Host driver 3.04.20
[    2.627911] mptbase: ioc0: Initiating bringup
[    2.945500] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.947779] ata1.00: ATA-7: Maxtor 6V320F0, VA111900, max UDMA/133
[    2.947826] ata1.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.951300] ata1.00: configured for UDMA/133
[    2.951477] scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6V320F0   VA11 PQ: 0 ANSI: 5
[    2.951636] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.951727] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    2.951881] sd 0:0:0:0: [sda] Write Protect is off
[    2.951911] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.951947] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.977804]  sda: sda1 sda2
[    2.978108] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.231674] ioc0: LSISAS1068E B3: Capabilities={Initiator}
[    3.268299] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.272545] ata2.00: ATA-7: Maxtor 6V320F0, VA111900, max UDMA/133
[    3.274392] ata2.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    3.279387] ata2.00: configured for UDMA/133
[    3.281374] scsi 1:0:0:0: Direct-Access     ATA      Maxtor 6V320F0   VA11 PQ: 0 ANSI: 5
[    3.283367] sd 1:0:0:0: [sdb] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    3.283370] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    3.287236] sd 1:0:0:0: [sdb] Write Protect is off
[    3.289105] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.289141] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.313812]  sdb: sdb1 sdb2
[    3.315917] sd 1:0:0:0: [sdb] Attached SCSI disk
[    3.601079] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.603257] ata3.00: ATAPI: ATAPI   iHAS324   A, BL1P, max UDMA/100
[    3.605857] ata3.00: configured for UDMA/100
[    3.609359] scsi 2:0:0:0: CD-ROM            ATAPI    iHAS324   A      BL1P PQ: 0 ANSI: 5
[    2.627720] Fusion MPT FC Host driver 3.04.20
[    2.627759] Fusion MPT SAS Host driver 3.04.20
[    2.627911] mptbase: ioc0: Initiating bringup
[    2.945500] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.947779] ata1.00: ATA-7: Maxtor 6V320F0, VA111900, max UDMA/133
[    2.947826] ata1.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.951300] ata1.00: configured for UDMA/133
[    2.951477] scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6V320F0   VA11 PQ: 0 ANSI: 5
[    2.951636] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.951727] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    2.951881] sd 0:0:0:0: [sda] Write Protect is off
[    2.951911] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.951947] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.977804]  sda: sda1 sda2
[    2.978108] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.231674] ioc0: LSISAS1068E B3: Capabilities={Initiator}
[    3.268299] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.272545] ata2.00: ATA-7: Maxtor 6V320F0, VA111900, max UDMA/133
[    3.274392] ata2.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    3.279387] ata2.00: configured for UDMA/133
[    3.281374] scsi 1:0:0:0: Direct-Access     ATA      Maxtor 6V320F0   VA11 PQ: 0 ANSI: 5
[    3.283367] sd 1:0:0:0: [sdb] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    3.283370] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    3.287236] sd 1:0:0:0: [sdb] Write Protect is off
[    3.289105] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.289141] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.313812]  sdb: sdb1 sdb2
[    3.315917] sd 1:0:0:0: [sdb] Attached SCSI disk
[    3.601079] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.603257] ata3.00: ATAPI: ATAPI   iHAS324   A, BL1P, max UDMA/100
[    3.605857] ata3.00: configured for UDMA/100
[    3.609359] scsi 2:0:0:0: CD-ROM            ATAPI    iHAS324   A      BL1P PQ: 0 ANSI: 5
[    3.614736] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    3.616694] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.618798] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    3.618879] sr 2:0:0:0: Attached scsi generic sg2 type 5
[    3.937184] ata4: SATA link down (SStatus 0 SControl 300)
[    4.256651] ata5: SATA link down (SStatus 0 SControl 300)
[    4.576123] ata6: SATA link down (SStatus 0 SControl 300)
[   13.564331] scsi6 : ioc0: LSISAS1068E B3, FwRev=011b0000h, Ports=1, MaxQ=277, IRQ=32
[   13.604879] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 8, phy 1, sas_addr 0x816f9b3796d4dac1
[   13.609933] scsi 6:0:0:0: Direct-Access     ATA      Hitachi HDS72202 A20N PQ: 0 ANSI: 5
[   13.613384] sd 6:0:0:0: Attached scsi generic sg3 type 0
[   13.616019] sd 6:0:0:0: [sdc] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   13.618011] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 9, phy 2, sas_addr 0x816f9b4881d8f4c1
[   13.897926] sd 6:0:0:0: [sdc] Write Protect is off
[   13.899934] sd 6:0:0:0: [sdc] Mode Sense: 73 00 00 08
[   13.902669] sd 6:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   14.188201]  sdc: unknown partition table
[   14.474709] sd 6:0:0:0: [sdc] Attached SCSI disk
[   14.479761] scsi 6:0:1:0: Direct-Access     ATA      Hitachi HDS72202 A20N PQ: 0 ANSI: 5
[   14.483315] sd 6:0:1:0: Attached scsi generic sg4 type 0
[   14.486057] sd 6:0:1:0: [sdd] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   14.488190] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 10, phy 3, sas_addr 0x816f9b40abd2efc1
[   14.764558] sd 6:0:1:0: [sdd] Write Protect is off
[   14.766696] sd 6:0:1:0: [sdd] Mode Sense: 73 00 00 08
[   14.769431] sd 6:0:1:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.054835]  sdd: unknown partition table
[   15.341350] sd 6:0:1:0: [sdd] Attached SCSI disk
[   15.346537] scsi 6:0:2:0: Direct-Access     ATA      Hitachi HDS72202 A20N PQ: 0 ANSI: 5
[   15.350267] sd 6:0:2:0: Attached scsi generic sg5 type 0
[   15.353192] sd 6:0:2:0: [sde] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   15.355510] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 11, phy 5, sas_addr 0x816f9b4598b701c2
[   15.637389] sd 6:0:2:0: [sde] Write Protect is off
[    3.614736] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    3.616694] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.618798] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    3.618879] sr 2:0:0:0: Attached scsi generic sg2 type 5
[    3.937184] ata4: SATA link down (SStatus 0 SControl 300)
[    4.256651] ata5: SATA link down (SStatus 0 SControl 300)
[    4.576123] ata6: SATA link down (SStatus 0 SControl 300)
[   13.564331] scsi6 : ioc0: LSISAS1068E B3, FwRev=011b0000h, Ports=1, MaxQ=277, IRQ=32
[   13.604879] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 8, phy 1, sas_addr 0x816f9b3796d4dac1
[   13.609933] scsi 6:0:0:0: Direct-Access     ATA      Hitachi HDS72202 A20N PQ: 0 ANSI: 5
[   13.613384] sd 6:0:0:0: Attached scsi generic sg3 type 0
[   13.616019] sd 6:0:0:0: [sdc] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   13.618011] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 9, phy 2, sas_addr 0x816f9b4881d8f4c1
[   13.897926] sd 6:0:0:0: [sdc] Write Protect is off
[   13.899934] sd 6:0:0:0: [sdc] Mode Sense: 73 00 00 08
[   13.902669] sd 6:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   14.188201]  sdc: unknown partition table
[   14.474709] sd 6:0:0:0: [sdc] Attached SCSI disk
[   14.479761] scsi 6:0:1:0: Direct-Access     ATA      Hitachi HDS72202 A20N PQ: 0 ANSI: 5
[   14.483315] sd 6:0:1:0: Attached scsi generic sg4 type 0
[   14.486057] sd 6:0:1:0: [sdd] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   14.488190] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 10, phy 3, sas_addr 0x816f9b40abd2efc1
[   14.764558] sd 6:0:1:0: [sdd] Write Protect is off
[   14.766696] sd 6:0:1:0: [sdd] Mode Sense: 73 00 00 08
[   14.769431] sd 6:0:1:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.054835]  sdd: unknown partition table
[   15.341350] sd 6:0:1:0: [sdd] Attached SCSI disk
[   15.346537] scsi 6:0:2:0: Direct-Access     ATA      Hitachi HDS72202 A20N PQ: 0 ANSI: 5
[   15.350267] sd 6:0:2:0: Attached scsi generic sg5 type 0
[   15.353192] sd 6:0:2:0: [sde] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   15.355510] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 11, phy 5, sas_addr 0x816f9b4598b701c2
[   15.637389] sd 6:0:2:0: [sde] Write Protect is off
[   15.639724] sd 6:0:2:0: [sde] Mode Sense: 73 00 00 08
[   15.642468] sd 6:0:2:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.935979]  sde: unknown partition table
[   16.222507] sd 6:0:2:0: [sde] Attached SCSI disk
[   16.227921] scsi 6:0:3:0: Direct-Access     ATA      Hitachi HDS72202 A20N PQ: 0 ANSI: 5
[   16.231841] sd 6:0:3:0: Attached scsi generic sg6 type 0
[   16.234957] sd 6:0:3:0: [sdf] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   16.237458] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 12, phy 6, sas_addr 0x816f9b45a1b6e8c1
[   16.513649] sd 6:0:3:0: [sdf] Write Protect is off
[   16.516162] sd 6:0:3:0: [sdf] Mode Sense: 73 00 00 08
[   16.518904] sd 6:0:3:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   16.812232]  sdf: unknown partition table
[   17.098769] sd 6:0:3:0: [sdf] Attached SCSI disk
[   17.104368] scsi 6:0:4:0: Direct-Access     ATA      Hitachi HDS72202 A20N PQ: 0 ANSI: 5
[   17.108485] sd 6:0:4:0: Attached scsi generic sg7 type 0
[   17.111798] sd 6:0:4:0: [sdg] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   17.114489] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 13, phy 7, sas_addr 0x816f9b40a7c1dec1
[   17.398052] sd 6:0:4:0: [sdg] Write Protect is off
[   17.400766] sd 6:0:4:0: [sdg] Mode Sense: 73 00 00 08
[   17.403513] sd 6:0:4:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   17.696641]  sdg: unknown partition table
[   17.983168] sd 6:0:4:0: [sdg] Attached SCSI disk
[   17.988898] scsi 6:0:5:0: Direct-Access     ATA      Hitachi HDS72202 A20N PQ: 0 ANSI: 5
[   17.993133] sd 6:0:5:0: Attached scsi generic sg8 type 0
[   17.996558] sd 6:0:5:0: [sdh] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   17.999353] Fusion MPT misc device (ioctl) driver 3.04.20
[   18.002134] mptctl: Registered with Fusion MPT base driver
[   18.004878] mptctl: /dev/mptctl @ (major,minor=10,220)
[   18.007604] Fusion MPT LAN driver 3.04.20
[   18.010303] mptlan: ioc0: PortNum=0, ProtocolFlags=09h (ItlB)
[   18.013019] mptlan: ioc0: Hmmm... LAN protocol seems to be disabled on this adapter port!
[   18.015956] aoe: AoE v47 initialised.
[   15.639724] sd 6:0:2:0: [sde] Mode Sense: 73 00 00 08
[   15.642468] sd 6:0:2:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.935979]  sde: unknown partition table
[   16.222507] sd 6:0:2:0: [sde] Attached SCSI disk
[   16.227921] scsi 6:0:3:0: Direct-Access     ATA      Hitachi HDS72202 A20N PQ: 0 ANSI: 5
[   16.231841] sd 6:0:3:0: Attached scsi generic sg6 type 0
[   16.234957] sd 6:0:3:0: [sdf] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   16.237458] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 12, phy 6, sas_addr 0x816f9b45a1b6e8c1
[   16.513649] sd 6:0:3:0: [sdf] Write Protect is off
[   16.516162] sd 6:0:3:0: [sdf] Mode Sense: 73 00 00 08
[   16.518904] sd 6:0:3:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   16.812232]  sdf: unknown partition table
[   17.098769] sd 6:0:3:0: [sdf] Attached SCSI disk
[   17.104368] scsi 6:0:4:0: Direct-Access     ATA      Hitachi HDS72202 A20N PQ: 0 ANSI: 5
[   17.108485] sd 6:0:4:0: Attached scsi generic sg7 type 0
[   17.111798] sd 6:0:4:0: [sdg] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   17.114489] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 13, phy 7, sas_addr 0x816f9b40a7c1dec1
[   17.398052] sd 6:0:4:0: [sdg] Write Protect is off
[   17.400766] sd 6:0:4:0: [sdg] Mode Sense: 73 00 00 08
[   17.403513] sd 6:0:4:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   17.696641]  sdg: unknown partition table
[   17.983168] sd 6:0:4:0: [sdg] Attached SCSI disk
[   17.988898] scsi 6:0:5:0: Direct-Access     ATA      Hitachi HDS72202 A20N PQ: 0 ANSI: 5
[   17.993133] sd 6:0:5:0: Attached scsi generic sg8 type 0
[   17.996558] sd 6:0:5:0: [sdh] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[   17.999353] Fusion MPT misc device (ioctl) driver 3.04.20
[   18.002134] mptctl: Registered with Fusion MPT base driver
[   18.004878] mptctl: /dev/mptctl @ (major,minor=10,220)
[   18.007604] Fusion MPT LAN driver 3.04.20
[   18.010303] mptlan: ioc0: PortNum=0, ProtocolFlags=09h (ItlB)
[   18.013019] mptlan: ioc0: Hmmm... LAN protocol seems to be disabled on this adapter port!
[   18.015956] aoe: AoE v47 initialised.
[   18.018740] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   18.021504] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[   18.021511] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[   18.024265] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[   18.026999] ehci_hcd 0000:00:1a.7: debug port 1
[   18.033595] ehci_hcd 0000:00:1a.7: cache line size of 256 is not supported
[   18.033609] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfb6f8000
[   18.043759] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[   18.046440] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   18.049109] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   18.051766] usb usb1: Product: EHCI Host Controller
[   18.054412] usb usb1: Manufacturer: Linux 3.5.0-rc6-andres-00196-gfdb1335 ehci_hcd
[   18.057070] usb usb1: SerialNumber: 0000:00:1a.7
[   18.059804] hub 1-0:1.0: USB hub found
[   18.062422] hub 1-0:1.0: 6 ports detected
[   18.065123] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   18.065130] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   18.067782] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[   18.070422] ehci_hcd 0000:00:1d.7: debug port 1
[   18.076918] ehci_hcd 0000:00:1d.7: cache line size of 256 is not supported
[   18.076935] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfb6fa000
[   18.087023] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   18.089645] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   18.092246] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   18.094824] usb usb2: Product: EHCI Host Controller
[   18.097382] usb usb2: Manufacturer: Linux 3.5.0-rc6-andres-00196-gfdb1335 ehci_hcd
[   18.099936] usb usb2: SerialNumber: 0000:00:1d.7
[   18.102581] hub 2-0:1.0: USB hub found
[   18.105096] hub 2-0:1.0: 6 ports detected
[   18.107657] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   18.110124] uhci_hcd: USB Universal Host Controller Interface driver
[   18.018740] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   18.021504] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[   18.021511] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[   18.024265] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[   18.026999] ehci_hcd 0000:00:1a.7: debug port 1
[   18.033595] ehci_hcd 0000:00:1a.7: cache line size of 256 is not supported
[   18.033609] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfb6f8000
[   18.043759] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[   18.046440] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   18.049109] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   18.051766] usb usb1: Product: EHCI Host Controller
[   18.054412] usb usb1: Manufacturer: Linux 3.5.0-rc6-andres-00196-gfdb1335 ehci_hcd
[   18.057070] usb usb1: SerialNumber: 0000:00:1a.7
[   18.059804] hub 1-0:1.0: USB hub found
[   18.062422] hub 1-0:1.0: 6 ports detected
[   18.065123] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   18.065130] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   18.067782] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[   18.070422] ehci_hcd 0000:00:1d.7: debug port 1
[   18.076918] ehci_hcd 0000:00:1d.7: cache line size of 256 is not supported
[   18.076935] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfb6fa000
[   18.087023] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   18.089645] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   18.092246] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   18.094824] usb usb2: Product: EHCI Host Controller
[   18.097382] usb usb2: Manufacturer: Linux 3.5.0-rc6-andres-00196-gfdb1335 ehci_hcd
[   18.099936] usb usb2: SerialNumber: 0000:00:1d.7
[   18.102581] hub 2-0:1.0: USB hub found
[   18.105096] hub 2-0:1.0: 6 ports detected
[   18.107657] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   18.110124] uhci_hcd: USB Universal Host Controller Interface driver
[   18.112609] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[   18.112616] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   18.115093] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[   18.117563] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00009400
[   18.119993] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   18.122392] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   18.124764] usb usb3: Product: UHCI Host Controller
[   18.127112] usb usb3: Manufacturer: Linux 3.5.0-rc6-andres-00196-gfdb1335 uhci_hcd
[   18.129432] usb usb3: SerialNumber: 0000:00:1a.0
[   18.131856] hub 3-0:1.0: USB hub found
[   18.134148] hub 3-0:1.0: 2 ports detected
[   18.136476] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[   18.136483] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[   18.138784] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[   18.141075] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00009480
[   18.143310] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[   18.145528] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   18.147713] usb usb4: Product: UHCI Host Controller
[   18.149881] usb usb4: Manufacturer: Linux 3.5.0-rc6-andres-00196-gfdb1335 uhci_hcd
[   18.152048] usb usb4: SerialNumber: 0000:00:1a.1
[   18.154294] hub 4-0:1.0: USB hub found
[   18.156411] hub 4-0:1.0: 2 ports detected
[   18.158588] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[   18.158595] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[   18.160708] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[   18.162804] uhci_hcd 0000:00:1a.2: irq 19, io base 0x00009800
[   18.164903] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[   18.166951] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   18.168957] usb usb5: Product: UHCI Host Controller
[   18.170944] usb usb5: Manufacturer: Linux 3.5.0-rc6-andres-00196-gfdb1335 uhci_hcd
[   18.172933] usb usb5: SerialNumber: 0000:00:1a.2
[   18.174981] hub 5-0:1.0: USB hub found
[   18.112609] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[   18.112616] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   18.115093] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[   18.117563] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00009400
[   18.119993] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   18.122392] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   18.124764] usb usb3: Product: UHCI Host Controller
[   18.127112] usb usb3: Manufacturer: Linux 3.5.0-rc6-andres-00196-gfdb1335 uhci_hcd
[   18.129432] usb usb3: SerialNumber: 0000:00:1a.0
[   18.131856] hub 3-0:1.0: USB hub found
[   18.134148] hub 3-0:1.0: 2 ports detected
[   18.136476] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[   18.136483] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[   18.138784] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[   18.141075] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00009480
[   18.143310] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[   18.145528] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   18.147713] usb usb4: Product: UHCI Host Controller
[   18.149881] usb usb4: Manufacturer: Linux 3.5.0-rc6-andres-00196-gfdb1335 uhci_hcd
[   18.152048] usb usb4: SerialNumber: 0000:00:1a.1
[   18.154294] hub 4-0:1.0: USB hub found
[   18.156411] hub 4-0:1.0: 2 ports detected
[   18.158588] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[   18.158595] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[   18.160708] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[   18.162804] uhci_hcd 0000:00:1a.2: irq 19, io base 0x00009800
[   18.164903] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[   18.166951] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   18.168957] usb usb5: Product: UHCI Host Controller
[   18.170944] usb usb5: Manufacturer: Linux 3.5.0-rc6-andres-00196-gfdb1335 uhci_hcd
[   18.172933] usb usb5: SerialNumber: 0000:00:1a.2
[   18.174981] hub 5-0:1.0: USB hub found
[   18.176930] hub 5-0:1.0: 2 ports detected
[   18.178929] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   18.178936] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   18.180882] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[   18.182800] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00009880
[   18.184714] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[   18.186574] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   18.188437] usb usb6: Product: UHCI Host Controller
[   18.190278] usb usb6: Manufacturer: Linux 3.5.0-rc6-andres-00196-gfdb1335 uhci_hcd
[   18.192121] usb usb6: SerialNumber: 0000:00:1d.0
[   18.194077] hub 6-0:1.0: USB hub found
[   18.195917] hub 6-0:1.0: 2 ports detected
[   18.197829] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   18.197836] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   18.199693] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[   18.201547] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00009c00
[   18.203380] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[   18.205204] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   18.207026] usb usb7: Product: UHCI Host Controller
[   18.208820] usb usb7: Manufacturer: Linux 3.5.0-rc6-andres-00196-gfdb1335 uhci_hcd
[   18.210657] usb usb7: SerialNumber: 0000:00:1d.1
[   18.212606] hub 7-0:1.0: USB hub found
[   18.214438] hub 7-0:1.0: 2 ports detected
[   18.216328] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   18.216335] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   18.218210] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[   18.220056] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000a000
[   18.221905] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[   18.223738] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   18.225571] usb usb8: Product: UHCI Host Controller
[   18.227408] usb usb8: Manufacturer: Linux 3.5.0-rc6-andres-00196-gfdb1335 uhci_hcd
[   18.229248] usb usb8: SerialNumber: 0000:00:1d.2
[   18.176930] hub 5-0:1.0: 2 ports detected
[   18.178929] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   18.178936] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   18.180882] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[   18.182800] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00009880
[   18.184714] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[   18.186574] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   18.188437] usb usb6: Product: UHCI Host Controller
[   18.190278] usb usb6: Manufacturer: Linux 3.5.0-rc6-andres-00196-gfdb1335 uhci_hcd
[   18.192121] usb usb6: SerialNumber: 0000:00:1d.0
[   18.194077] hub 6-0:1.0: USB hub found
[   18.195917] hub 6-0:1.0: 2 ports detected
[   18.197829] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   18.197836] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   18.199693] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[   18.201547] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00009c00
[   18.203380] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[   18.205204] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   18.207026] usb usb7: Product: UHCI Host Controller
[   18.208820] usb usb7: Manufacturer: Linux 3.5.0-rc6-andres-00196-gfdb1335 uhci_hcd
[   18.210657] usb usb7: SerialNumber: 0000:00:1d.1
[   18.212606] hub 7-0:1.0: USB hub found
[   18.214438] hub 7-0:1.0: 2 ports detected
[   18.216328] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   18.216335] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   18.218210] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[   18.220056] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000a000
[   18.221905] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[   18.223738] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   18.225571] usb usb8: Product: UHCI Host Controller
[   18.227408] usb usb8: Manufacturer: Linux 3.5.0-rc6-andres-00196-gfdb1335 uhci_hcd
[   18.229248] usb usb8: SerialNumber: 0000:00:1d.2
[   18.231180] hub 8-0:1.0: USB hub found
[   18.233012] hub 8-0:1.0: 2 ports detected
[   18.234943] Initializing USB Mass Storage driver...
[   18.236809] usbcore: registered new interface driver usb-storage
[   18.238642] USB Mass Storage support registered.
[   18.240509] usbcore: registered new interface driver libusual
[   18.242362] i8042: PNP: No PS/2 controller found. Probing ports directly.
[   18.247237] serio: i8042 KBD port at 0x60,0x64 irq 1
[   18.249072] serio: i8042 AUX port at 0x60,0x64 irq 12
[   18.251037] mousedev: PS/2 mouse device common for all mice
[   18.253059] rtc_cmos 00:03: RTC can wake from S4
[   18.255026] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[   18.256901] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[   18.259051] md: linear personality registered for level -1
[   18.260892] md: raid0 personality registered for level 0
[   18.262712] md: raid1 personality registered for level 1
[   18.264551] md: raid10 personality registered for level 10
[   18.266351] md: raid6 personality registered for level 6
[   18.268155] md: raid5 personality registered for level 5
[   18.269932] md: raid4 personality registered for level 4
[   18.271713] md: multipath personality registered for level -4
[   18.273506] md: faulty personality registered for level -5
[   18.275360] device-mapper: uevent: version 1.0.3
[   18.277220] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
[   18.279197] device-mapper: multipath: version 1.4.0 loaded
[   18.281003] device-mapper: multipath round-robin: version 1.0.0 loaded
[   18.281011] sd 6:0:5:0: [sdh] Write Protect is off
[   18.281013] sd 6:0:5:0: [sdh] Mode Sense: 73 00 00 08
[   18.284582] device-mapper: multipath queue-length: version 0.1.0 loaded
[   18.286386] sd 6:0:5:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   18.286791] device-mapper: multipath service-time: version 0.2.0 loaded
[   18.286866] device-mapper: dm-log-userspace: version 1.1.0 loaded
[   18.231180] hub 8-0:1.0: USB hub found
[   18.233012] hub 8-0:1.0: 2 ports detected
[   18.234943] Initializing USB Mass Storage driver...
[   18.236809] usbcore: registered new interface driver usb-storage
[   18.238642] USB Mass Storage support registered.
[   18.240509] usbcore: registered new interface driver libusual
[   18.242362] i8042: PNP: No PS/2 controller found. Probing ports directly.
[   18.247237] serio: i8042 KBD port at 0x60,0x64 irq 1
[   18.249072] serio: i8042 AUX port at 0x60,0x64 irq 12
[   18.251037] mousedev: PS/2 mouse device common for all mice
[   18.253059] rtc_cmos 00:03: RTC can wake from S4
[   18.255026] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[   18.256901] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[   18.259051] md: linear personality registered for level -1
[   18.260892] md: raid0 personality registered for level 0
[   18.262712] md: raid1 personality registered for level 1
[   18.264551] md: raid10 personality registered for level 10
[   18.266351] md: raid6 personality registered for level 6
[   18.268155] md: raid5 personality registered for level 5
[   18.269932] md: raid4 personality registered for level 4
[   18.271713] md: multipath personality registered for level -4
[   18.273506] md: faulty personality registered for level -5
[   18.275360] device-mapper: uevent: version 1.0.3
[   18.277220] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
[   18.279197] device-mapper: multipath: version 1.4.0 loaded
[   18.281003] device-mapper: multipath round-robin: version 1.0.0 loaded
[   18.281011] sd 6:0:5:0: [sdh] Write Protect is off
[   18.281013] sd 6:0:5:0: [sdh] Mode Sense: 73 00 00 08
[   18.284582] device-mapper: multipath queue-length: version 0.1.0 loaded
[   18.286386] sd 6:0:5:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   18.286791] device-mapper: multipath service-time: version 0.2.0 loaded
[   18.286866] device-mapper: dm-log-userspace: version 1.1.0 loaded
[   18.286867] EDAC MC: Ver: 2.1.0
[   18.287411] EDAC MC1: Giving out device to 'i7core_edac.c' 'i7 core #1': DEV 0000:fe:03.0
[   18.287419] EDAC PCI0: Giving out device to module 'i7core_edac' controller 'EDAC PCI controller': DEV '0000:fe:03.0' (POLLED)
[   18.297723] EDAC MC0: Giving out device to 'i7core_edac.c' 'i7 core #0': DEV 0000:ff:03.0
[   18.299625] EDAC PCI1: Giving out device to module 'i7core_edac' controller 'EDAC PCI controller': DEV '0000:ff:03.0' (POLLED)
[   18.301769] EDAC i7core: Driver loaded, 2 memory controller(s) found.
[   18.303958] cpuidle: using governor ladder
[   18.306161] cpuidle: using governor menu
[   18.308709] usbcore: registered new interface driver usbhid
[   18.310642] usbhid: USB HID core driver
[   18.312640] oprofile: using NMI interrupt.
[   18.314610] Netfilter messages via NETLINK v0.30.
[   18.316514] nfnl_acct: registering with nfnetlink.
[   18.318464] IPv4 over IPv4 tunneling driver
[   18.320804] TCP: cubic registered
[   18.322685] Initializing XFRM netlink socket
[   18.324696] NET: Registered protocol family 10
[   18.326823] NET: Registered protocol family 17
[   18.328676] NET: Registered protocol family 15
[   18.331252] Bridge firewalling registered
[   18.333100] Ebtables v2.0 registered
[   18.334992] Key type dns_resolver registered
[   18.337084] PM: Hibernation image not present or could not be loaded.
[   18.337093] registered taskstats version 1
[   18.341256]   Magic number: 8:791:924
[   18.542954] usb 2-3: new high-speed USB device number 2 using ehci_hcd
[   18.594638]  sdh: unknown partition table
[   18.666386] usb 2-3: New USB device found, idVendor=0424, idProduct=2514
[   18.668263] usb 2-3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   18.670283] hub 2-3:1.0: USB hub found
[   18.672261] hub 2-3:1.0: 4 ports detected
[   18.779205] usb 2-5: new high-speed USB device number 3 using ehci_hcd
[   18.286867] EDAC MC: Ver: 2.1.0
[   18.287411] EDAC MC1: Giving out device to 'i7core_edac.c' 'i7 core #1': DEV 0000:fe:03.0
[   18.287419] EDAC PCI0: Giving out device to module 'i7core_edac' controller 'EDAC PCI controller': DEV '0000:fe:03.0' (POLLED)
[   18.297723] EDAC MC0: Giving out device to 'i7core_edac.c' 'i7 core #0': DEV 0000:ff:03.0
[   18.299625] EDAC PCI1: Giving out device to module 'i7core_edac' controller 'EDAC PCI controller': DEV '0000:ff:03.0' (POLLED)
[   18.301769] EDAC i7core: Driver loaded, 2 memory controller(s) found.
[   18.303958] cpuidle: using governor ladder
[   18.306161] cpuidle: using governor menu
[   18.308709] usbcore: registered new interface driver usbhid
[   18.310642] usbhid: USB HID core driver
[   18.312640] oprofile: using NMI interrupt.
[   18.314610] Netfilter messages via NETLINK v0.30.
[   18.316514] nfnl_acct: registering with nfnetlink.
[   18.318464] IPv4 over IPv4 tunneling driver
[   18.320804] TCP: cubic registered
[   18.322685] Initializing XFRM netlink socket
[   18.324696] NET: Registered protocol family 10
[   18.326823] NET: Registered protocol family 17
[   18.328676] NET: Registered protocol family 15
[   18.331252] Bridge firewalling registered
[   18.333100] Ebtables v2.0 registered
[   18.334992] Key type dns_resolver registered
[   18.337084] PM: Hibernation image not present or could not be loaded.
[   18.337093] registered taskstats version 1
[   18.341256]   Magic number: 8:791:924
[   18.542954] usb 2-3: new high-speed USB device number 2 using ehci_hcd
[   18.594638]  sdh: unknown partition table
[   18.666386] usb 2-3: New USB device found, idVendor=0424, idProduct=2514
[   18.668263] usb 2-3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   18.670283] hub 2-3:1.0: USB hub found
[   18.672261] hub 2-3:1.0: 4 ports detected
[   18.779205] usb 2-5: new high-speed USB device number 3 using ehci_hcd
[   18.881196] sd 6:0:5:0: [sdh] Attached SCSI disk
[   18.883102] netpoll: netconsole: local port 4444
[   18.884965] netpoll: netconsole: local IP 192.168.224.176
[   18.886826] netpoll: netconsole: interface 'eth0'
[   18.888665] netpoll: netconsole: remote port 4444
[   18.890500] netpoll: netconsole: remote IP 192.168.224.203
[   18.892308] netpoll: netconsole: remote ethernet address 00:21:86:60:5d:d6
[   18.894131] netpoll: netconsole: eth0 doesn't exist, aborting
[   18.895948] netconsole: cleaning up
[   18.897822] rtc_cmos 00:03: setting system clock to 2012-08-30 06:56:04 UTC (1346309764)
[   19.171016] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[   19.172929] EDD information not available.
[   19.178264] Freeing unused kernel memory: 892k freed
[   19.180222] Write protecting the kernel read-only data: 18432k
[   19.183209] usb 2-5: New USB device found, idVendor=046b, idProduct=ff01
[   19.185011] usb 2-5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   19.186810] usb 2-5: Product: Generic Hub
[   19.188564] usb 2-5: Manufacturer: American Megatrends Inc.
[   19.190313] usb 2-5: SerialNumber: serial
[   19.192073] Freeing unused kernel memory: 1900k freed
[   19.192943] hub 2-5:1.0: USB hub found
[   19.193169] hub 2-5:1.0: 3 ports detected
[   19.203054] Freeing unused kernel memory: 1200k freed
[   19.348446] e1000e: Intel(R) PRO/1000 Network Driver - 2.0.0-k
[   19.350782] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[   19.353387] e1000e 0000:03:00.0: Disabling ASPM L0s L1
[   19.356092] e1000e 0000:03:00.0: (unregistered net_device): Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[   19.358282] e1000e 0000:03:00.0: irq 78 for MSI/MSI-X
[   19.358296] e1000e 0000:03:00.0: irq 79 for MSI/MSI-X
[   19.358311] e1000e 0000:03:00.0: irq 80 for MSI/MSI-X
[   19.425330] usb 3-1: new low-speed USB device number 2 using uhci_hcd
[   19.474650] e1000e 0000:03:00.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:e0:81:c2:23:45
[   18.881196] sd 6:0:5:0: [sdh] Attached SCSI disk
[   18.883102] netpoll: netconsole: local port 4444
[   18.884965] netpoll: netconsole: local IP 192.168.224.176
[   18.886826] netpoll: netconsole: interface 'eth0'
[   18.888665] netpoll: netconsole: remote port 4444
[   18.890500] netpoll: netconsole: remote IP 192.168.224.203
[   18.892308] netpoll: netconsole: remote ethernet address 00:21:86:60:5d:d6
[   18.894131] netpoll: netconsole: eth0 doesn't exist, aborting
[   18.895948] netconsole: cleaning up
[   18.897822] rtc_cmos 00:03: setting system clock to 2012-08-30 06:56:04 UTC (1346309764)
[   19.171016] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[   19.172929] EDD information not available.
[   19.178264] Freeing unused kernel memory: 892k freed
[   19.180222] Write protecting the kernel read-only data: 18432k
[   19.183209] usb 2-5: New USB device found, idVendor=046b, idProduct=ff01
[   19.185011] usb 2-5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   19.186810] usb 2-5: Product: Generic Hub
[   19.188564] usb 2-5: Manufacturer: American Megatrends Inc.
[   19.190313] usb 2-5: SerialNumber: serial
[   19.192073] Freeing unused kernel memory: 1900k freed
[   19.192943] hub 2-5:1.0: USB hub found
[   19.193169] hub 2-5:1.0: 3 ports detected
[   19.203054] Freeing unused kernel memory: 1200k freed
[   19.348446] e1000e: Intel(R) PRO/1000 Network Driver - 2.0.0-k
[   19.350782] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[   19.353387] e1000e 0000:03:00.0: Disabling ASPM L0s L1
[   19.356092] e1000e 0000:03:00.0: (unregistered net_device): Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[   19.358282] e1000e 0000:03:00.0: irq 78 for MSI/MSI-X
[   19.358296] e1000e 0000:03:00.0: irq 79 for MSI/MSI-X
[   19.358311] e1000e 0000:03:00.0: irq 80 for MSI/MSI-X
[   19.425330] usb 3-1: new low-speed USB device number 2 using uhci_hcd
[   19.474650] e1000e 0000:03:00.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:e0:81:c2:23:45
[   19.477148] e1000e 0000:03:00.0: eth0: Intel(R) PRO/1000 Network Connection
[   19.479827] e1000e 0000:03:00.0: eth0: MAC: 3, PHY: 8, PBA No: FFFFFF-0FF
[   19.482370] e1000e 0000:02:00.0: Disabling ASPM L0s L1
[   19.486074] e1000e 0000:02:00.0: (unregistered net_device): Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[   19.488952] e1000e 0000:02:00.0: irq 81 for MSI/MSI-X
[   19.488961] e1000e 0000:02:00.0: irq 82 for MSI/MSI-X
[   19.488970] e1000e 0000:02:00.0: irq 83 for MSI/MSI-X
[   19.601373] e1000e 0000:02:00.0: eth1: (PCI Express:2.5GT/s:Width x1) 00:e0:81:c2:23:44
[   19.603858] e1000e 0000:02:00.0: eth1: Intel(R) PRO/1000 Network Connection
[   19.606542] e1000e 0000:02:00.0: eth1: MAC: 3, PHY: 8, PBA No: FFFFFF-0FF
[   19.609565] usb 3-1: New USB device found, idVendor=17ef, idProduct=6009
[   19.612308] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   19.615164] usb 3-1: Product: ThinkPad USB Keyboard with TrackPoint
[   19.617567] usb 3-1: Manufacturer: Lite-On Technology Corp.
[   19.637912] input: Lite-On Technology Corp. ThinkPad USB Keyboard with TrackPoint as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.0/input/input2
[   19.640726] hid-generic 0003:17EF:6009.0001: input,hidraw0: USB HID v1.10 Keyboard [Lite-On Technology Corp. ThinkPad USB Keyboard with TrackPoint] on usb-0000:00:1a.0-1/input0
[   19.686561] input: Lite-On Technology Corp. ThinkPad USB Keyboard with TrackPoint as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.1/input/input3
[   19.690392] hid-generic 0003:17EF:6009.0002: input,hiddev0,hidraw1: USB HID v1.10 Mouse [Lite-On Technology Corp. ThinkPad USB Keyboard with TrackPoint] on usb-0000:00:1a.0-1/input1
[   19.774749] usb 2-3.1: new low-speed USB device number 4 using ehci_hcd
[   19.879792] usb 2-3.1: New USB device found, idVendor=046d, idProduct=c03d
[   19.882677] usb 2-3.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   19.885499] usb 2-3.1: Product: USB-PS/2 Optical Mouse
[   19.888410] usb 2-3.1: Manufacturer: Logitech
[   19.894436] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1d.7/usb2/2-3/2-3.1/2-3.1:1.0/input/input4
[   19.897975] hid-generic 0003:046D:C03D.0003: input,hidraw2: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.7-3.1/input0
[   19.972170] usb 2-3.2: new full-speed USB device number 5 using ehci_hcd
[   20.070055] md: md0 stopped.
[   20.073789] md: bind<sda1>
[   20.076675] md: bind<sdb1>
[   20.082570] bio: create slab <bio-1> at 1
[   20.085686] md/raid1:md0: active with 2 out of 2 mirrors
[   20.088864] created bitmap (239 pages) for device md0
[   19.477148] e1000e 0000:03:00.0: eth0: Intel(R) PRO/1000 Network Connection
[   19.479827] e1000e 0000:03:00.0: eth0: MAC: 3, PHY: 8, PBA No: FFFFFF-0FF
[   19.482370] e1000e 0000:02:00.0: Disabling ASPM L0s L1
[   19.486074] e1000e 0000:02:00.0: (unregistered net_device): Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[   19.488952] e1000e 0000:02:00.0: irq 81 for MSI/MSI-X
[   19.488961] e1000e 0000:02:00.0: irq 82 for MSI/MSI-X
[   19.488970] e1000e 0000:02:00.0: irq 83 for MSI/MSI-X
[   19.601373] e1000e 0000:02:00.0: eth1: (PCI Express:2.5GT/s:Width x1) 00:e0:81:c2:23:44
[   19.603858] e1000e 0000:02:00.0: eth1: Intel(R) PRO/1000 Network Connection
[   19.606542] e1000e 0000:02:00.0: eth1: MAC: 3, PHY: 8, PBA No: FFFFFF-0FF
[   19.609565] usb 3-1: New USB device found, idVendor=17ef, idProduct=6009
[   19.612308] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   19.615164] usb 3-1: Product: ThinkPad USB Keyboard with TrackPoint
[   19.617567] usb 3-1: Manufacturer: Lite-On Technology Corp.
[   19.637912] input: Lite-On Technology Corp. ThinkPad USB Keyboard with TrackPoint as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.0/input/input2
[   19.640726] hid-generic 0003:17EF:6009.0001: input,hidraw0: USB HID v1.10 Keyboard [Lite-On Technology Corp. ThinkPad USB Keyboard with TrackPoint] on usb-0000:00:1a.0-1/input0
[   19.686561] input: Lite-On Technology Corp. ThinkPad USB Keyboard with TrackPoint as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.1/input/input3
[   19.690392] hid-generic 0003:17EF:6009.0002: input,hiddev0,hidraw1: USB HID v1.10 Mouse [Lite-On Technology Corp. ThinkPad USB Keyboard with TrackPoint] on usb-0000:00:1a.0-1/input1
[   19.774749] usb 2-3.1: new low-speed USB device number 4 using ehci_hcd
[   19.879792] usb 2-3.1: New USB device found, idVendor=046d, idProduct=c03d
[   19.882677] usb 2-3.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   19.885499] usb 2-3.1: Product: USB-PS/2 Optical Mouse
[   19.888410] usb 2-3.1: Manufacturer: Logitech
[   19.894436] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1d.7/usb2/2-3/2-3.1/2-3.1:1.0/input/input4
[   19.897975] hid-generic 0003:046D:C03D.0003: input,hidraw2: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.7-3.1/input0
[   19.972170] usb 2-3.2: new full-speed USB device number 5 using ehci_hcd
[   20.070055] md: md0 stopped.
[   20.073789] md: bind<sda1>
[   20.076675] md: bind<sdb1>
[   20.082570] bio: create slab <bio-1> at 1
[   20.085686] md/raid1:md0: active with 2 out of 2 mirrors
[   20.088864] created bitmap (239 pages) for device md0
[   20.091938] usb 2-3.2: New USB device found, idVendor=04f9, idProduct=0182
[   20.094840] usb 2-3.2: New USB device strings: Mfr=0, Product=0, SerialNumber=3
[   20.097737] usb 2-3.2: SerialNumber: 000J6J815887
[   20.099031] md0: bitmap initialized from disk: read 15 pages, set 0 of 487920 bits
[   20.129936] md0: detected capacity change from 0 to 1998520320
[   20.134663]  md0: unknown partition table
[   20.170696] usb 2-5.1: new high-speed USB device number 6 using ehci_hcd
[   20.196151] md: md1 stopped.
[   20.200730] md: bind<sda2>
[   20.204362] md: bind<sdb2>
[   20.210085] md/raid1:md1: active with 2 out of 2 mirrors
[   20.213316] created bitmap (140 pages) for device md1
[   20.233930] md1: bitmap initialized from disk: read 9 pages, set 0 of 286102 bits
[   20.264545] md1: detected capacity change from 0 to 149999779840
[   20.269253]  md1: unknown partition table
[   20.269558] usb 2-5.1: New USB device found, idVendor=046b, idProduct=ff10
[   20.269560] usb 2-5.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   20.269562] usb 2-5.1: Product: Virtual Keyboard and Mouse
[   20.269564] usb 2-5.1: Manufacturer: American Megatrends Inc.
[   20.269565] usb 2-5.1: SerialNumber: serial
[   20.271483] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1:1.0/input/input5
[   20.271702] hid-generic 0003:046B:FF10.0004: input,hidraw3: USB HID v1.10 Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1d.7-5.1/input0
[   20.281228] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1:1.1/input/input6
[   20.281425] hid-generic 0003:046B:FF10.0005: input,hidraw4: USB HID v1.10 Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1d.7-5.1/input1
[   20.350853] md: md3 stopped.
[   20.383703] md: bind<sde>
[   20.388472] md: bind<sdd>
[   20.392800] md: bind<sdg>
[   20.397057] md: bind<sdf>
[   20.401611] md: bind<sdh>
[   20.406076] md: bind<sdc>
[   20.413045] md/raid10:md3: active with 6 out of 6 devices
[   20.091938] usb 2-3.2: New USB device found, idVendor=04f9, idProduct=0182
[   20.094840] usb 2-3.2: New USB device strings: Mfr=0, Product=0, SerialNumber=3
[   20.097737] usb 2-3.2: SerialNumber: 000J6J815887
[   20.099031] md0: bitmap initialized from disk: read 15 pages, set 0 of 487920 bits
[   20.129936] md0: detected capacity change from 0 to 1998520320
[   20.134663]  md0: unknown partition table
[   20.170696] usb 2-5.1: new high-speed USB device number 6 using ehci_hcd
[   20.196151] md: md1 stopped.
[   20.200730] md: bind<sda2>
[   20.204362] md: bind<sdb2>
[   20.210085] md/raid1:md1: active with 2 out of 2 mirrors
[   20.213316] created bitmap (140 pages) for device md1
[   20.233930] md1: bitmap initialized from disk: read 9 pages, set 0 of 286102 bits
[   20.264545] md1: detected capacity change from 0 to 149999779840
[   20.269253]  md1: unknown partition table
[   20.269558] usb 2-5.1: New USB device found, idVendor=046b, idProduct=ff10
[   20.269560] usb 2-5.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   20.269562] usb 2-5.1: Product: Virtual Keyboard and Mouse
[   20.269564] usb 2-5.1: Manufacturer: American Megatrends Inc.
[   20.269565] usb 2-5.1: SerialNumber: serial
[   20.271483] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1:1.0/input/input5
[   20.271702] hid-generic 0003:046B:FF10.0004: input,hidraw3: USB HID v1.10 Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1d.7-5.1/input0
[   20.281228] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1:1.1/input/input6
[   20.281425] hid-generic 0003:046B:FF10.0005: input,hidraw4: USB HID v1.10 Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1d.7-5.1/input1
[   20.350853] md: md3 stopped.
[   20.383703] md: bind<sde>
[   20.388472] md: bind<sdd>
[   20.392800] md: bind<sdg>
[   20.397057] md: bind<sdf>
[   20.401611] md: bind<sdh>
[   20.406076] md: bind<sdc>
[   20.413045] md/raid10:md3: active with 6 out of 6 devices
[   20.420118] created bitmap (11 pages) for device md3
[   20.429623] md3: bitmap initialized from disk: read 1 pages, set 0 of 22357 bits
[   20.447809] md3: detected capacity change from 0 to 6001196335104
[   20.477923]  md3: unknown partition table
[   20.733159] EXT4-fs (md1): mounted filesystem with ordered data mode. Opts: (null)
[   27.922154] EXT4-fs (md1): re-mounted. Opts: errors=remount-ro
[   30.093031] snd_hda_intel 0000:08:00.1: irq 84 for MSI/MSI-X
[   30.254365] input: HD-Audio Generic HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:03.0/0000:08:00.1/sound/card0/input7
[   32.843721] EXT4-fs (dm-3): mounted filesystem with ordered data mode. Opts: acl
[   32.991129] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: acl
[   33.106657] EXT4-fs (dm-4): mounted filesystem with ordered data mode. Opts: acl
[   33.236563] EXT4-fs (md0): mounted filesystem without journal. Opts: (null)
[   35.775210] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   40.458055] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   40.463672] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   20.420118] created bitmap (11 pages) for device md3
[   20.429623] md3: bitmap initialized from disk: read 1 pages, set 0 of 22357 bits
[   20.447809] md3: detected capacity change from 0 to 6001196335104
[   20.477923]  md3: unknown partition table
[   20.733159] EXT4-fs (md1): mounted filesystem with ordered data mode. Opts: (null)
[   27.922154] EXT4-fs (md1): re-mounted. Opts: errors=remount-ro
[   30.093031] snd_hda_intel 0000:08:00.1: irq 84 for MSI/MSI-X
[   30.254365] input: HD-Audio Generic HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:03.0/0000:08:00.1/sound/card0/input7
[   32.843721] EXT4-fs (dm-3): mounted filesystem with ordered data mode. Opts: acl
[   32.991129] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: acl
[   33.106657] EXT4-fs (dm-4): mounted filesystem with ordered data mode. Opts: acl
[   33.236563] EXT4-fs (md0): mounted filesystem without journal. Opts: (null)
[   35.775210] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   40.458055] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   40.463672] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready

--Boundary-00=_S31PQ8LoqFLmOJE--
