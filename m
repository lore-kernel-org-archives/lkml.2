Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab0EBN6H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 09:58:07 -0400
Received: from legolas.restena.lu ([158.64.1.34]:49677 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756123Ab0EBN57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 09:57:59 -0400
Date: Sun, 2 May 2010 15:56:53 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: dri-devel@lists.freedesktop.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: s2ram slow (radeon) / failing (usb)
Message-ID: <20100502155653.68fc3643@neptune.home>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On a IEI Kino 690S1 I'm having a hard time to get s2ram running.
It freezes during device suspend (unless I rmmod everything USB
related) - usb fails even in pm_test case 'devices'.

When the system is able to suspend it takes an eternity (more than 3
minutes to wake-up, the radeon apparently being responsible for quite
a big share of that slowness.


During resume early it looks like every PCI access needs about a second,
and there are a few cases where during lots of seconds nothing seems to
happen and the first event following is related to radeon.

The kernel used is todays Linus's tree at commit be1066bbcd443a65df312fdecea7e4959adedb45
with Dave's drm-linus and drm-radeon-testing applied on top.

Note, I've not been able to suspend to RAM properly recently (last one
that worked correctly but resumed without graphics was some-when during
2.6.2x, before KMS)
Since then the system would either fail suspend or resume.

Manual changes I applied in order to find out some context information:
- add a few debugging printk's to ata/ahci as that was the last entry
  on serial console for freezing suspends (that one succeeded but
  following step never completed, from suspend_prepare that would have
  been USB => unload usb before suspend)
- strip "if EMBEDED" from CONFIG_SERIAL_8250_PNP and disabled it so serial
  console would continue working as long as possible and output suspend
  progress (resume output happens only very late)

Is there some additional information I could gather in order do help
improving s2ram on this system?
- get it to suspend with usb loaded (ohci + ehci)
- get it to resume a reasonable speed

Thanks,
Bruno



List of modules when suspend&resume works (slowly):
 Module                  Size  Used by
 snd_atiixp             14095  0 
 snd_ac97_codec        118013  1 snd_atiixp
 ac97_bus                1274  1 snd_ac97_codec
 snd_pcm                71003  2 snd_atiixp,snd_ac97_codec
 snd_timer              19369  1 snd_pcm
 snd                    51992  4 snd_atiixp,snd_ac97_codec,snd_pcm,snd_timer
 soundcore                974  1 snd
 snd_page_alloc          7797  2 snd_atiixp,snd_pcm
 sg                     18667  0 
 pata_atiixp             4189  0 
 tg3                   125844  0 

lspci:
 00:00.0 Host bridge [0600]: ATI Technologies Inc RS690 Host Bridge [1002:7910]
 00:01.0 PCI bridge [0604]: ATI Technologies Inc RS690 PCI to PCI Bridge (Internal gfx) [1002:7912]
 00:04.0 PCI bridge [0604]: ATI Technologies Inc Device [1002:7914]
 00:05.0 PCI bridge [0604]: ATI Technologies Inc RS690 PCI to PCI Bridge (PCI Express Port 1) [1002:7915]
 00:06.0 PCI bridge [0604]: ATI Technologies Inc RS690 PCI to PCI Bridge (PCI Express Port 2) [1002:7916]
 00:12.0 SATA controller [0106]: ATI Technologies Inc SB600 Non-Raid-5 SATA [1002:4380]
 00:13.0 USB Controller [0c03]: ATI Technologies Inc SB600 USB (OHCI0) [1002:4387]
 00:13.1 USB Controller [0c03]: ATI Technologies Inc SB600 USB (OHCI1) [1002:4388]
 00:13.2 USB Controller [0c03]: ATI Technologies Inc SB600 USB (OHCI2) [1002:4389]
 00:13.3 USB Controller [0c03]: ATI Technologies Inc SB600 USB (OHCI3) [1002:438a]
 00:13.4 USB Controller [0c03]: ATI Technologies Inc SB600 USB (OHCI4) [1002:438b]
 00:13.5 USB Controller [0c03]: ATI Technologies Inc SB600 USB Controller (EHCI) [1002:4386]
 00:14.0 SMBus [0c05]: ATI Technologies Inc SBx00 SMBus Controller [1002:4385] (rev 13)
 00:14.1 IDE interface [0101]: ATI Technologies Inc SB600 IDE [1002:438c]
 00:14.3 ISA bridge [0601]: ATI Technologies Inc SB600 PCI to LPC Bridge [1002:438d]
 00:14.4 PCI bridge [0604]: ATI Technologies Inc SBx00 PCI to PCI Bridge [1002:4384]
 00:14.5 Multimedia audio controller [0401]: ATI Technologies Inc SB600 AC97 Audio [1002:4382]
 00:18.0 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration [1022:1100]
 00:18.1 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map [1022:1101]
 00:18.2 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller [1022:1102]
 00:18.3 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control [1022:1103]
 01:05.0 VGA compatible controller [0300]: ATI Technologies Inc RS690 [Radeon X1200 Series] [1002:791e]
 02:00.0 Ethernet controller [0200]: Broadcom Corporation NetLink BCM5787M Gigabit Ethernet PCI Express [14e4:1693] (rev 02)
 03:00.0 Ethernet controller [0200]: Broadcom Corporation NetLink BCM5787M Gigabit Ethernet PCI Express [14e4:1693] (rev 02)

PM related config options:
 CONFIG_PM=y
 CONFIG_PM_DEBUG=y
 CONFIG_CAN_PM_TRACE=y
 CONFIG_PM_SLEEP_SMP=y
 CONFIG_PM_SLEEP=y
 CONFIG_PM_RUNTIME=y
 CONFIG_X86_PM_TIMER=y
USB related config options:
 CONFIG_V4L_USB_DRIVERS=y
 CONFIG_USB_VIDEO_CLASS=m
 CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
 CONFIG_USB_PWC=m
 CONFIG_USB_PWC_INPUT_EVDEV=y
 CONFIG_SND_USB=y
 CONFIG_USB_HID=y
 CONFIG_USB_SUPPORT=y
 CONFIG_USB_ARCH_HAS_HCD=y
 CONFIG_USB_ARCH_HAS_OHCI=y
 CONFIG_USB_ARCH_HAS_EHCI=y
 CONFIG_USB=y
 CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
 CONFIG_USB_DYNAMIC_MINORS=y
 CONFIG_USB_SUSPEND=y
 CONFIG_USB_EHCI_HCD=y
 CONFIG_USB_OHCI_HCD=y
 CONFIG_USB_OHCI_LITTLE_ENDIAN=y
 CONFIG_USB_STORAGE=m
 CONFIG_USB_STORAGE_CYPRESS_ATACB=m
DRM related config options:
 CONFIG_DRM=y
 CONFIG_DRM_KMS_HELPER=y
 CONFIG_DRM_TTM=y
 CONFIG_DRM_RADEON=y
 CONFIG_DRM_RADEON_KMS=y

Please ask if full kernel config is needed.



Boot log including 1 s2ram cycle (built with CONFIG_PM_DEBUG):

[    0.000000] Linux version 2.6.34-rc6 (bruno@aphrodite) (gcc version 4.3.4 (Gentoo 4.3.4 p1.0, pie-10.1.5) ) #3 SMP Sun May 2 13:38:13 CEST 2010
[    0.000000] Command line: BOOT_IMAGE=Mini-2.6.34rc6 ro root=900 acpi_enforce_resources=lax 3 no_console_suspend console=ttyS0,115200n8
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007dfa0000 (usable)
[    0.000000]  BIOS-e820: 000000007dfa0000 - 000000007dfae000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007dfae000 - 000000007dff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007dff0000 - 000000007e000000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x7dfa0 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF80000000 write-back
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-000000007dfa0000
[    0.000000]  0000000000 - 007de00000 page 2M
[    0.000000]  007de00000 - 007dfa0000 page 4k
[    0.000000] kernel direct mapping tables up to 7dfa0000 @ 16000-1a000
[    0.000000] ACPI: RSDP 00000000000f9640 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 000000007dfa0000 0003C (v01 060209 RSDT1538 20090602 MSFT 00000097)
[    0.000000] ACPI: FACP 000000007dfa0200 00084 (v02 060209 FACP1538 20090602 MSFT 00000097)
[    0.000000] ACPI: DSDT 000000007dfa0430 04B18 (v01  E093M E093MR22 00000001 INTL 20051117)
[    0.000000] ACPI: FACS 000000007dfae000 00040
[    0.000000] ACPI: APIC 000000007dfa0390 0005C (v01 060209 APIC1538 20090602 MSFT 00000097)
[    0.000000] ACPI: MCFG 000000007dfa03f0 0003C (v01 060209 OEMMCFG  20090602 MSFT 00000097)
[    0.000000] ACPI: OEMB 000000007dfae040 00074 (v01 060209 OEMB1538 20090602 MSFT 00000097)
[    0.000000] ACPI: HPET 000000007dfa4f50 00038 (v01 060209 OEMHPET  20090602 MSFT 00000097)
[    0.000000] ACPI: SSDT 000000007dfa4f90 001C4 (v01 A M I  POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff880006600000-ffff8800081fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007dfa0
[    0.000000] On node 0 totalpages: 515887
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3927 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6999 pages used for memmap
[    0.000000]   DMA32 zone: 504905 pages, LIFO batch:31
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] Allocating PCI resources starting at 7e000000 (gap: 7e000000:81700000)
[    0.000000] setup_percpu: NR_CPUS:4096 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] early_res array is doubled to 64 at [18000 - 187ff]
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880005e00000 s78760 r8192 d23640 u1048576
[    0.000000] pcpu-alloc: s78760 r8192 d23640 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 508832
[    0.000000] Kernel command line: BOOT_IMAGE=Mini-2.6.34rc6 ro root=900 acpi_enforce_resources=lax 3 no_console_suspend console=ttyS0,115200n8
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 14b4000000 size 32 MB
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] Subtract (44 early reservations)
[    0.000000]   #1 [0001000000 - 0005d0bc64]   TEXT DATA BSS
[    0.000000]   #2 [000009fc00 - 0000100000]   BIOS reserved
[    0.000000]   #3 [0005d0c000 - 0005d0c0e7]             BRK
[    0.000000]   #4 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #5 [0000012000 - 0000016000]     ACPI WAKEUP
[    0.000000]   #6 [0000016000 - 0000018000]         PGTABLE
[    0.000000]   #7 [0005d0c100 - 0005d0d100]         BOOTMEM
[    0.000000]   #8 [0005d0bc80 - 0005d0be00]         BOOTMEM
[    0.000000]   #9 [000650e000 - 000650f000]         BOOTMEM
[    0.000000]   #10 [000650f000 - 0006510000]         BOOTMEM
[    0.000000]   #11 [0006600000 - 0008200000]        MEMMAP 0
[    0.000000]   #12 [0005d0be00 - 0005d0bf80]         BOOTMEM
[    0.000000]   #13 [0005d0d100 - 0005d19100]         BOOTMEM
[    0.000000]   #14 [0005d1a000 - 0005d1b000]         BOOTMEM
[    0.000000]   #15 [0005d0bf80 - 0005d0bfc1]         BOOTMEM
[    0.000000]   #16 [0005d19100 - 0005d19143]         BOOTMEM
[    0.000000]   #17 [0005d19180 - 0005d19378]         BOOTMEM
[    0.000000]   #18 [0005d19380 - 0005d193e8]         BOOTMEM
[    0.000000]   #19 [0005d19400 - 0005d19468]         BOOTMEM
[    0.000000]   #20 [0005d19480 - 0005d194e8]         BOOTMEM
[    0.000000]   #21 [0005d19500 - 0005d19568]         BOOTMEM
[    0.000000]   #22 [0005d19580 - 0005d195e8]         BOOTMEM
[    0.000000]   #23 [0005d19600 - 0005d19668]         BOOTMEM
[    0.000000]   #24 [0005d19680 - 0005d196e8]         BOOTMEM
[    0.000000]   #25 [0005d19700 - 0005d19768]         BOOTMEM
[    0.000000]   #26 [0005d19780 - 0005d197ed]         BOOTMEM
[    0.000000]   #27 [0005d19800 - 0005d1986d]         BOOTMEM
[    0.000000]   #28 [0005e00000 - 0005e1b000]         BOOTMEM
[    0.000000]   #29 [0005f00000 - 0005f1b000]         BOOTMEM
[    0.000000]   #30 [0005d19880 - 0005d19888]         BOOTMEM
[    0.000000]   #31 [0005d198c0 - 0005d198c8]         BOOTMEM
[    0.000000]   #32 [0005d19900 - 0005d19908]         BOOTMEM
[    0.000000]   #33 [0005d19940 - 0005d19950]         BOOTMEM
[    0.000000]   #34 [0005d19980 - 0005d19ac0]         BOOTMEM
[    0.000000]   #35 [0005d19ac0 - 0005d19b20]         BOOTMEM
[    0.000000]   #36 [0005d19b40 - 0005d19ba0]         BOOTMEM
[    0.000000]   #37 [0005d19bc0 - 0005d19dc0]         BOOTMEM
[    0.000000]   #38 [0005d19dc0 - 0005d19fc0]         BOOTMEM
[    0.000000]   #39 [0005d1b000 - 0005d1b200]         BOOTMEM
[    0.000000]   #40 [0005d1b200 - 0005d1b400]         BOOTMEM
[    0.000000]   #41 [0005d1b400 - 0005d23400]         BOOTMEM
[    0.000000]   #42 [0005f1b000 - 000611b000]         BOOTMEM
[    0.000000]   #43 [000611b000 - 000621b000]         BOOTMEM
[    0.000000] Memory: 1952556k/2064000k available (4531k kernel code, 452k absent, 110992k reserved, 3216k data, 492k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1799.999 MHz processor.
[    0.020006] Calibrating delay loop (skipped), value calculated using timer frequency.. 3599.99 BogoMIPS (lpj=17999990)
[    0.040587] Mount-cache hash table entries: 256
[    0.045358] tseg: 0000000000
[    0.045371] CPU: Physical Processor ID: 0
[    0.050005] CPU: Processor Core ID: 0
[    0.053666] mce: CPU supports 5 MCE banks
[    0.057680] using C1E aware idle routine
[    0.060003] Performance Events: AMD PMU driver.
[    0.064556] ... version:                0
[    0.070002] ... bit width:              48
[    0.074087] ... generic registers:      4
[    0.078094] ... value mask:             0000ffffffffffff
[    0.080002] ... max period:             00007fffffffffff
[    0.085299] ... fixed-purpose events:   0
[    0.090002] ... event mask:             000000000000000f
[    0.095332] ACPI: Core revision 20100121
[    0.110704] Setting APIC routing to flat
[    0.115362] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.221745] CPU0: AMD Turion(tm) 64 X2 Mobile Technology TL-56 stepping 02
[    0.230000] Booting Node   0, Processors  #1 Ok.
[    0.380110] Brought up 2 CPUs
[    0.383074] Total of 2 processors activated (7200.14 BogoMIPS).
[    0.389203] PM: Adding info for No Bus:platform
[    0.389203] xor: automatically using best checksumming function: generic_sse
[    0.440002]    generic_sse:  5554.800 MB/sec
[    0.444268] xor: using function: generic_sse (5554.800 MB/sec)
[    0.450137] NET: Registered protocol family 16
[    0.454595] PM: Adding info for No Bus:vtcon0
[    0.454595] node 0 link 0: io port [1000, ffffff]
[    0.454595] TOM: 0000000080000000 aka 2048M
[    0.454595] node 0 link 0: mmio [f8000000, f9feffff]
[    0.454595] node 0 link 0: mmio [e0000000, efffffff]
[    0.454595] node 0 link 0: mmio [80000000, dfffffff]
[    0.454595] node 0 link 0: mmio [a0000, bffff]
[    0.454595] node 0 link 0: mmio [f9ff0000, ffffffff]
[    0.454595] bus: [00, ff] on node 0 link 0
[    0.454595] bus: 00 index 0 [io  0x0000-0xffff]
[    0.454595] bus: 00 index 1 [mem 0xf0000000-0xfcffffffff]
[    0.454595] bus: 00 index 2 [mem 0x80000000-0xefffffff]
[    0.454595] bus: 00 index 3 [mem 0x000a0000-0x000bffff]
[    0.454595] ACPI: bus type pci registered
[    0.460030] PM: Adding info for No Bus:id
[    0.460044] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.470003] PCI: not using MMCONFIG
[    0.473486] PCI: Using configuration type 1 for base access
[    0.480039] PM: Adding info for No Bus:default
[    0.480206] bio: create slab <bio-0> at 0
[    0.490809] ACPI: EC: Look up EC in DSDT
[    0.492865] ACPI: Executed 3 blocks of module-level executable AML code
[    0.506040] ACPI: Interpreter enabled
[    0.509700] ACPI: (supports S0 S3 S5)
[    0.510884] ACPI: Using IOAPIC for interrupt routing
[    0.515902] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.531660] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.562660] PM: Adding info for acpi:LNXSYSTM:00
[    0.562660] PM: Adding info for acpi:LNXCPU:00
[    0.562660] PM: Adding info for acpi:LNXCPU:01
[    0.562660] PM: Adding info for acpi:LNXSYBUS:00
[    0.562660] PM: Adding info for acpi:PNP0A03:00
[    0.562660] PM: Adding info for acpi:device:00
[    0.562660] PM: Adding info for acpi:PNP0C02:00
[    0.562660] PM: Adding info for acpi:device:01
[    0.562660] PM: Adding info for acpi:device:02
[    0.562660] PM: Adding info for acpi:device:03
[    0.562660] PM: Adding info for acpi:device:04
[    0.562660] PM: Adding info for acpi:device:05
[    0.562660] PM: Adding info for acpi:device:06
[    0.562660] PM: Adding info for acpi:device:07
[    0.562660] PM: Adding info for acpi:device:08
[    0.562660] PM: Adding info for acpi:device:09
[    0.562660] PM: Adding info for acpi:device:0a
[    0.562660] PM: Adding info for acpi:device:0b
[    0.562660] PM: Adding info for acpi:device:0c
[    0.562660] PM: Adding info for acpi:device:0d
[    0.562660] PM: Adding info for acpi:device:0e
[    0.562660] PM: Adding info for acpi:device:0f
[    0.562660] PM: Adding info for acpi:device:10
[    0.562660] PM: Adding info for acpi:device:11
[    0.562660] PM: Adding info for acpi:PNP0000:00
[    0.562660] PM: Adding info for acpi:PNP0200:00
[    0.562660] PM: Adding info for acpi:PNP0100:00
[    0.562660] PM: Adding info for acpi:PNP0B00:00
[    0.562660] PM: Adding info for acpi:PNP0303:00
[    0.562660] PM: Adding info for acpi:PNP0F03:00
[    0.562660] PM: Adding info for acpi:PNP0800:00
[    0.562660] PM: Adding info for acpi:PNP0C04:00
[    0.562660] PM: Adding info for acpi:PNP0501:00
[    0.562660] PM: Adding info for acpi:PNP0501:01
[    0.562660] PM: Adding info for acpi:PNP0C02:01
[    0.562660] PM: Adding info for acpi:PNP0501:02
[    0.570734] PM: Adding info for acpi:PNP0501:03
[    0.570749] PM: Adding info for acpi:PNP0C02:02
[    0.570749] PM: Adding info for acpi:PNP0C02:03
[    0.570749] PM: Adding info for acpi:PNP0C02:04
[    0.570749] PM: Adding info for acpi:PNP0C02:05
[    0.570749] PM: Adding info for acpi:device:12
[    0.570749] PM: Adding info for acpi:device:13
[    0.570749] PM: Adding info for acpi:device:14
[    0.570749] PM: Adding info for acpi:device:15
[    0.570749] PM: Adding info for acpi:device:16
[    0.570749] PM: Adding info for acpi:device:17
[    0.570749] PM: Adding info for acpi:device:18
[    0.570749] PM: Adding info for acpi:device:19
[    0.570749] PM: Adding info for acpi:device:1a
[    0.570749] PM: Adding info for acpi:device:1b
[    0.570749] PM: Adding info for acpi:device:1c
[    0.570749] PM: Adding info for acpi:device:1d
[    0.570749] PM: Adding info for acpi:device:1e
[    0.570749] PM: Adding info for acpi:device:1f
[    0.570749] PM: Adding info for acpi:device:20
[    0.570749] PM: Adding info for acpi:device:21
[    0.570749] PM: Adding info for acpi:device:22
[    0.570749] PM: Adding info for acpi:device:23
[    0.570749] PM: Adding info for acpi:device:24
[    0.570749] PM: Adding info for acpi:PNP0C01:00
[    0.570749] PM: Adding info for acpi:PNP0C0C:00
[    0.570749] PM: Adding info for acpi:PNP0C0F:00
[    0.570749] PM: Adding info for acpi:PNP0C0F:01
[    0.570749] PM: Adding info for acpi:PNP0C0F:02
[    0.570749] PM: Adding info for acpi:PNP0C0F:03
[    0.570749] PM: Adding info for acpi:PNP0C0F:04
[    0.570749] PM: Adding info for acpi:PNP0C0F:05
[    0.570749] PM: Adding info for acpi:PNP0C0F:06
[    0.570749] PM: Adding info for acpi:PNP0C0F:07
[    0.570749] PM: Adding info for acpi:LNXTHERM:00
[    0.570749] PM: Adding info for acpi:LNXPWRBN:00
[    0.570749] ACPI Warning: Incorrect checksum in table [OEMB] - 43, should be 40 (20100121/tbutils-314)
[    0.582404] ACPI: No dock devices found.
[    0.590040] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.599375] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.600043] PM: Adding info for No Bus:pci0000:00
[    0.600054] PM: Adding info for No Bus:0000:00
[    0.600524] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.610008] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.616611] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.620002] pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff]
[    0.630002] pci_root PNP0A03:00: host bridge window [mem 0x7e000000-0xdfffffff]
[    0.640013] pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfed44fff]
[    0.647337] pci 0000:00:00.0: __pm_runtime_resume()!
[    0.647339] pci 0000:00:00.0: __pm_runtime_resume() returns -11!
[    0.647373] pci 0000:00:01.0: __pm_runtime_resume()!
[    0.647375] pci 0000:00:01.0: __pm_runtime_resume() returns -11!
[    0.647418] pci 0000:00:04.0: __pm_runtime_resume()!
[    0.647420] pci 0000:00:04.0: __pm_runtime_resume() returns -11!
[    0.647425] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.647428] pci 0000:00:04.0: PME# disabled
[    0.647469] pci 0000:00:05.0: __pm_runtime_resume()!
[    0.647471] pci 0000:00:05.0: __pm_runtime_resume() returns -11!
[    0.647476] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.647479] pci 0000:00:05.0: PME# disabled
[    0.647519] pci 0000:00:06.0: __pm_runtime_resume()!
[    0.647521] pci 0000:00:06.0: __pm_runtime_resume() returns -11!
[    0.647526] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.647529] pci 0000:00:06.0: PME# disabled
[    0.647586] pci 0000:00:12.0: reg 10: [io  0xc000-0xc007]
[    0.647594] pci 0000:00:12.0: reg 14: [io  0xb000-0xb003]
[    0.647602] pci 0000:00:12.0: reg 18: [io  0xa000-0xa007]
[    0.647610] pci 0000:00:12.0: reg 1c: [io  0x9000-0x9003]
[    0.647618] pci 0000:00:12.0: reg 20: [io  0x8000-0x800f]
[    0.647626] pci 0000:00:12.0: reg 24: [mem 0xfdbff800-0xfdbffbff]
[    0.647656] pci 0000:00:12.0: __pm_runtime_resume()!
[    0.647658] pci 0000:00:12.0: __pm_runtime_resume() returns -11!
[    0.647693] pci 0000:00:13.0: reg 10: [mem 0xfdbfe000-0xfdbfefff]
[    0.647734] pci 0000:00:13.0: __pm_runtime_resume()!
[    0.647736] pci 0000:00:13.0: __pm_runtime_resume() returns -11!
[    0.647760] pci 0000:00:13.1: reg 10: [mem 0xfdbfd000-0xfdbfdfff]
[    0.647802] pci 0000:00:13.1: __pm_runtime_resume()!
[    0.647804] pci 0000:00:13.1: __pm_runtime_resume() returns -11!
[    0.647827] pci 0000:00:13.2: reg 10: [mem 0xfdbfc000-0xfdbfcfff]
[    0.647869] pci 0000:00:13.2: __pm_runtime_resume()!
[    0.647871] pci 0000:00:13.2: __pm_runtime_resume() returns -11!
[    0.647895] pci 0000:00:13.3: reg 10: [mem 0xfdbfb000-0xfdbfbfff]
[    0.647936] pci 0000:00:13.3: __pm_runtime_resume()!
[    0.647938] pci 0000:00:13.3: __pm_runtime_resume() returns -11!
[    0.647962] pci 0000:00:13.4: reg 10: [mem 0xfdbfa000-0xfdbfafff]
[    0.648003] pci 0000:00:13.4: __pm_runtime_resume()!
[    0.648005] pci 0000:00:13.4: __pm_runtime_resume() returns -11!
[    0.648049] pci 0000:00:13.5: reg 10: [mem 0xfdbff000-0xfdbff0ff]
[    0.648110] pci 0000:00:13.5: __pm_runtime_resume()!
[    0.648111] pci 0000:00:13.5: __pm_runtime_resume() returns -11!
[    0.648119] pci 0000:00:13.5: supports D1 D2
[    0.648121] pci 0000:00:13.5: PME# supported from D0 D1 D2 D3hot
[    0.648126] pci 0000:00:13.5: PME# disabled
[    0.648659] pci 0000:00:14.0: reg 10: [io  0x0b00-0x0b0f]
[    0.650251] pci 0000:00:14.0: __pm_runtime_resume()!
[    0.650253] pci 0000:00:14.0: __pm_runtime_resume() returns -11!
[    0.650775] pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
[    0.650783] pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
[    0.650791] pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
[    0.650799] pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
[    0.650807] pci 0000:00:14.1: reg 20: [io  0xff00-0xff0f]
[    0.650836] pci 0000:00:14.1: __pm_runtime_resume()!
[    0.650838] pci 0000:00:14.1: __pm_runtime_resume() returns -11!
[    0.650907] pci 0000:00:14.3: __pm_runtime_resume()!
[    0.650909] pci 0000:00:14.3: __pm_runtime_resume() returns -11!
[    0.650947] pci 0000:00:14.4: __pm_runtime_resume()!
[    0.650949] pci 0000:00:14.4: __pm_runtime_resume() returns -11!
[    0.650980] pci 0000:00:14.5: reg 10: [mem 0xfdbf9800-0xfdbf98ff]
[    0.651029] pci 0000:00:14.5: __pm_runtime_resume()!
[    0.651031] pci 0000:00:14.5: __pm_runtime_resume() returns -11!
[    0.651073] pci 0000:00:18.0: __pm_runtime_resume()!
[    0.651075] pci 0000:00:18.0: __pm_runtime_resume() returns -11!
[    0.651099] pci 0000:00:18.1: __pm_runtime_resume()!
[    0.651101] pci 0000:00:18.1: __pm_runtime_resume() returns -11!
[    0.651122] pci 0000:00:18.2: __pm_runtime_resume()!
[    0.651124] pci 0000:00:18.2: __pm_runtime_resume() returns -11!
[    0.651147] pci 0000:00:18.3: __pm_runtime_resume()!
[    0.651149] pci 0000:00:18.3: __pm_runtime_resume() returns -11!
[    0.651205] pci 0000:01:05.0: reg 10: [mem 0xf8000000-0xf9ffffff 64bit pref]
[    0.651212] pci 0000:01:05.0: reg 18: [mem 0xfddf0000-0xfddfffff 64bit]
[    0.651217] pci 0000:01:05.0: reg 20: [io  0xd000-0xd0ff]
[    0.651221] pci 0000:01:05.0: reg 24: [mem 0xfdc00000-0xfdcfffff]
[    0.651234] pci 0000:01:05.0: __pm_runtime_resume()!
[    0.651236] pci 0000:01:05.0: __pm_runtime_resume() returns -11!
[    0.651240] pci 0000:01:05.0: supports D1 D2
[    0.651261] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.656479] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    0.656483] pci 0000:00:01.0:   bridge window [mem 0xfdc00000-0xfddfffff]
[    0.656488] pci 0000:00:01.0:   bridge window [mem 0xf8000000-0xf9ffffff 64bit pref]
[    0.656554] pci 0000:02:00.0: reg 10: [mem 0xfdef0000-0xfdefffff 64bit]
[    0.656615] pci 0000:02:00.0: __pm_runtime_resume()!
[    0.656617] pci 0000:02:00.0: __pm_runtime_resume() returns -11!
[    0.656624] pci 0000:02:00.0: PME# supported from D3hot D3cold
[    0.656629] pci 0000:02:00.0: PME# disabled
[    0.656643] pci 0000:00:04.0: PCI bridge to [bus 02-02]
[    0.660004] pci 0000:00:04.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.660008] pci 0000:00:04.0:   bridge window [mem 0xfde00000-0xfdefffff]
[    0.660013] pci 0000:00:04.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.660080] pci 0000:03:00.0: reg 10: [mem 0xfdff0000-0xfdffffff 64bit]
[    0.660141] pci 0000:03:00.0: __pm_runtime_resume()!
[    0.660143] pci 0000:03:00.0: __pm_runtime_resume() returns -11!
[    0.660150] pci 0000:03:00.0: PME# supported from D3hot D3cold
[    0.660155] pci 0000:03:00.0: PME# disabled
[    0.660168] pci 0000:00:05.0: PCI bridge to [bus 03-03]
[    0.665384] pci 0000:00:05.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.665388] pci 0000:00:05.0:   bridge window [mem 0xfdf00000-0xfdffffff]
[    0.665393] pci 0000:00:05.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.665424] pci 0000:00:06.0: PCI bridge to [bus 04-05]
[    0.670004] pci 0000:00:06.0:   bridge window [io  0xe000-0xefff]
[    0.670007] pci 0000:00:06.0:   bridge window [mem 0xfe000000-0xfebfffff]
[    0.670012] pci 0000:00:06.0:   bridge window [mem 0xfa000000-0xfcffffff 64bit pref]
[    0.670084] pci 0000:00:14.4: PCI bridge to [bus 06-06] (subtractive decode)
[    0.677125] pci 0000:00:14.4:   bridge window [io  0xf000-0x0000] (disabled)
[    0.677130] pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.677135] pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.677139] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.677141] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.677144] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.677147] pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    0.677150] pci 0000:00:14.4:   bridge window [mem 0x7e000000-0xdfffffff] (subtractive decode)
[    0.677153] pci 0000:00:14.4:   bridge window [mem 0xf0000000-0xfed44fff] (subtractive decode)
[    0.677171] pci_bus 0000:00: on NUMA node 0
[    0.677177] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.677360] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.680017] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE4._PRT]
[    0.680083] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE5._PRT]
[    0.680147] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE6._PRT]
[    0.680241] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
[    0.680720] PM: Adding info for pci:0000:00:00.0
[    0.680738] PM: Adding info for pci:0000:00:01.0
[    0.680738] PM: Adding info for pci:0000:00:04.0
[    0.680738] PM: Adding info for pci:0000:00:05.0
[    0.680738] PM: Adding info for pci:0000:00:06.0
[    0.680738] PM: Adding info for pci:0000:00:12.0
[    0.680738] PM: Adding info for pci:0000:00:13.0
[    0.680738] PM: Adding info for pci:0000:00:13.1
[    0.680738] PM: Adding info for pci:0000:00:13.2
[    0.680738] PM: Adding info for pci:0000:00:13.3
[    0.680738] PM: Adding info for pci:0000:00:13.4
[    0.680738] PM: Adding info for pci:0000:00:13.5
[    0.680738] PM: Adding info for pci:0000:00:14.0
[    0.680738] PM: Adding info for pci:0000:00:14.1
[    0.680738] PM: Adding info for pci:0000:00:14.3
[    0.680738] PM: Adding info for pci:0000:00:14.4
[    0.680738] PM: Adding info for pci:0000:00:14.5
[    0.680738] PM: Adding info for pci:0000:00:18.0
[    0.680738] PM: Adding info for pci:0000:00:18.1
[    0.680738] PM: Adding info for pci:0000:00:18.2
[    0.680738] PM: Adding info for pci:0000:00:18.3
[    0.680738] PM: Adding info for pci:0000:01:05.0
[    0.680738] PM: Adding info for No Bus:0000:01
[    0.680738] PM: Adding info for pci:0000:02:00.0
[    0.680738] PM: Adding info for No Bus:0000:02
[    0.680738] PM: Adding info for pci:0000:03:00.0
[    0.680738] PM: Adding info for No Bus:0000:03
[    0.680738] PM: Adding info for No Bus:0000:04
[    0.680738] PM: Adding info for No Bus:0000:06
[    0.680738] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 10 11 12 14 *15)
[    0.692736] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 *7 10 11 12 14 15)
[    0.702738] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 *10 11 12 14 15)
[    0.710080] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 *10 11 12 14 15)
[    0.717339] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
[    0.723912] ACPI: PCI Interrupt Link [LNKF] (IRQs 9) *0, disabled.
[    0.731882] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 7 10 11 12 14 15)
[    0.739141] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
[    0.743843] PM: Adding info for No Bus:vga_arbiter
[    0.743843] vgaarb: device added: PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
[    0.750040] vgaarb: loaded
[    0.753111] SCSI subsystem initialized
[    0.760035] libata version 3.00 loaded.
[    0.930029] raid6: int64x1   1516 MB/s
[    1.100018] raid6: int64x2   2065 MB/s
[    1.270003] raid6: int64x4   1676 MB/s
[    1.440001] raid6: int64x8   1522 MB/s
[    1.610006] raid6: sse2x1    2635 MB/s
[    1.780007] raid6: sse2x2    3369 MB/s
[    1.950002] raid6: sse2x4    3509 MB/s
[    1.953749] raid6: using algorithm sse2x4 (3509 MB/s)
[    1.958802] PCI: Using ACPI for IRQ routing
[    1.960002] PCI: pci_cache_line_size set to 64 bytes
[    1.960590] reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
[    1.960594] reserve RAM buffer: 000000007dfa0000 - 000000007fffffff 
[    1.960614] PM: Adding info for No Bus:lo
[    1.960614] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    1.965315] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    1.972078] Switching to clocksource hpet
[    1.980155] pnp: PnP ACPI init
[    1.983215] PM: Adding info for No Bus:pnp0
[    1.983217] ACPI: bus type pnp registered
[    1.987535] PM: Adding info for pnp:00:00
[    1.987773] PM: Adding info for pnp:00:01
[    1.987896] PM: Adding info for pnp:00:02
[    1.987993] PM: Adding info for pnp:00:03
[    1.988134] PM: Adding info for pnp:00:04
[    1.988267] PM: Adding info for pnp:00:05
[    1.988347] PM: Adding info for pnp:00:06
[    1.988435] PM: Adding info for pnp:00:07
[    1.989599] PM: Adding info for pnp:00:08
[    1.990726] PM: Adding info for pnp:00:09
[    1.991186] PM: Adding info for pnp:00:0a
[    1.991763] pnp 00:0b: IRQ 11 override to edge, high
[    1.996807] PM: Adding info for pnp:00:0b
[    1.997395] pnp 00:0c: IRQ 11 override to edge, high
[    2.002485] PM: Adding info for pnp:00:0c
[    2.002733] PM: Adding info for pnp:00:0d
[    2.002936] PM: Adding info for pnp:00:0e
[    2.003324] PM: Adding info for pnp:00:0f
[    2.003559] PM: Adding info for pnp:00:10
[    2.004110] PM: Adding info for pnp:00:11
[    2.004467] pnp: PnP ACPI: found 18 devices
[    2.008648] ACPI: ACPI bus type pnp unregistered
[    2.013311] system 00:01: [mem 0x7e000000-0x7fffffff] has been reserved
[    2.019917] system 00:0a: [io  0x0e00-0x0e0f] has been reserved
[    2.025857] system 00:0a: [io  0x0e80-0x0e8f] has been reserved
[    2.031788] system 00:0a: [io  0x0280-0x028f] has been reserved
[    2.037699] system 00:0a: [io  0x0a30-0x0a3f] has been reserved
[    2.043636] system 00:0d: [io  0x0a60-0x0a6f] has been reserved
[    2.049547] system 00:0e: [mem 0xfec00000-0xfec00fff] could not be reserved
[    2.056526] system 00:0e: [mem 0xfee00000-0xfee00fff] has been reserved
[    2.063145] system 00:0f: [io  0x04d0-0x04d1] has been reserved
[    2.069055] system 00:0f: [io  0x040b] has been reserved
[    2.074384] system 00:0f: [io  0x04d6] has been reserved
[    2.079689] system 00:0f: [io  0x0c00-0x0c01] has been reserved
[    2.085624] system 00:0f: [io  0x0c14] has been reserved
[    2.090948] system 00:0f: [io  0x0c50-0x0c51] has been reserved
[    2.096857] system 00:0f: [io  0x0c52] has been reserved
[    2.102186] system 00:0f: [io  0x0c6c] has been reserved
[    2.107491] system 00:0f: [io  0x0c6f] has been reserved
[    2.112820] system 00:0f: [io  0x0cd0-0x0cd1] has been reserved
[    2.118731] system 00:0f: [io  0x0cd2-0x0cd3] has been reserved
[    2.124667] system 00:0f: [io  0x0cd4-0x0cd5] has been reserved
[    2.130598] system 00:0f: [io  0x0cd6-0x0cd7] has been reserved
[    2.136508] system 00:0f: [io  0x0cd8-0x0cdf] has been reserved
[    2.142443] system 00:0f: [io  0x0800-0x089f] has been reserved
[    2.148355] system 00:0f: [io  0x0b10-0x0b1f] has been reserved
[    2.154290] system 00:0f: [io  0x0900-0x090f] has been reserved
[    2.160219] system 00:0f: [io  0x0910-0x091f] has been reserved
[    2.166130] system 00:0f: [io  0xfe00-0xfefe] has been reserved
[    2.172069] system 00:0f: [mem 0xffb80000-0xffbfffff] has been reserved
[    2.178670] system 00:0f: [mem 0xfff00000-0xffffffff] has been reserved
[    2.185301] system 00:10: [mem 0xe0000000-0xefffffff] has been reserved
[    2.191924] system 00:11: [mem 0x00000000-0x0009ffff] could not be reserved
[    2.198871] system 00:11: [mem 0x000c0000-0x000cffff] has been reserved
[    2.205506] system 00:11: [mem 0x000e0000-0x000fffff] could not be reserved
[    2.212472] system 00:11: [mem 0x00100000-0x7dffffff] could not be reserved
[    2.219420] system 00:11: [mem 0xfed45000-0xffffffff] could not be reserved
[    2.226512] PM: Adding info for No Bus:mem
[    2.226570] PM: Adding info for No Bus:null
[    2.226623] PM: Adding info for No Bus:port
[    2.226678] PM: Adding info for No Bus:zero
[    2.226734] PM: Adding info for No Bus:full
[    2.226792] PM: Adding info for No Bus:random
[    2.226850] PM: Adding info for No Bus:urandom
[    2.226907] PM: Adding info for No Bus:kmsg
[    2.231618] PCI: max bus depth: 1 pci_try_num: 2
[    2.231647] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    2.236866] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    2.242976] pci 0000:00:01.0:   bridge window [mem 0xfdc00000-0xfddfffff]
[    2.249752] pci 0000:00:01.0:   bridge window [mem 0xf8000000-0xf9ffffff 64bit pref]
[    2.257511] pci 0000:00:04.0: PCI bridge to [bus 02-02]
[    2.262742] pci 0000:00:04.0:   bridge window [io  disabled]
[    2.268395] pci 0000:00:04.0:   bridge window [mem 0xfde00000-0xfdefffff]
[    2.275200] pci 0000:00:04.0:   bridge window [mem pref disabled]
[    2.281300] pci 0000:00:05.0: PCI bridge to [bus 03-03]
[    2.286516] pci 0000:00:05.0:   bridge window [io  disabled]
[    2.292193] pci 0000:00:05.0:   bridge window [mem 0xfdf00000-0xfdffffff]
[    2.298969] pci 0000:00:05.0:   bridge window [mem pref disabled]
[    2.305083] pci 0000:00:06.0: PCI bridge to [bus 04-05]
[    2.310316] pci 0000:00:06.0:   bridge window [io  0xe000-0xefff]
[    2.316400] pci 0000:00:06.0:   bridge window [mem 0xfe000000-0xfebfffff]
[    2.323204] pci 0000:00:06.0:   bridge window [mem 0xfa000000-0xfcffffff 64bit pref]
[    2.330950] pci 0000:00:14.4: PCI bridge to [bus 06-06]
[    2.336170] pci 0000:00:14.4:   bridge window [io  disabled]
[    2.341847] pci 0000:00:14.4:   bridge window [mem disabled]
[    2.347497] pci 0000:00:14.4:   bridge window [mem pref disabled]
[    2.353622] pci 0000:00:04.0: setting latency timer to 64
[    2.353629] pci 0000:00:05.0: setting latency timer to 64
[    2.353636] pci 0000:00:06.0: setting latency timer to 64
[    2.353644] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.353647] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.353649] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.353652] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    2.353654] pci_bus 0000:00: resource 8 [mem 0x7e000000-0xdfffffff]
[    2.353657] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfed44fff]
[    2.353659] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    2.353662] pci_bus 0000:01: resource 1 [mem 0xfdc00000-0xfddfffff]
[    2.353664] pci_bus 0000:01: resource 2 [mem 0xf8000000-0xf9ffffff 64bit pref]
[    2.353667] pci_bus 0000:02: resource 1 [mem 0xfde00000-0xfdefffff]
[    2.353670] pci_bus 0000:03: resource 1 [mem 0xfdf00000-0xfdffffff]
[    2.353672] pci_bus 0000:04: resource 0 [io  0xe000-0xefff]
[    2.353675] pci_bus 0000:04: resource 1 [mem 0xfe000000-0xfebfffff]
[    2.353677] pci_bus 0000:04: resource 2 [mem 0xfa000000-0xfcffffff 64bit pref]
[    2.353680] pci_bus 0000:06: resource 4 [io  0x0000-0x0cf7]
[    2.353683] pci_bus 0000:06: resource 5 [io  0x0d00-0xffff]
[    2.353685] pci_bus 0000:06: resource 6 [mem 0x000a0000-0x000bffff]
[    2.353688] pci_bus 0000:06: resource 7 [mem 0x000d0000-0x000dffff]
[    2.353690] pci_bus 0000:06: resource 8 [mem 0x7e000000-0xdfffffff]
[    2.353692] pci_bus 0000:06: resource 9 [mem 0xf0000000-0xfed44fff]
[    2.353908] NET: Registered protocol family 2
[    2.358366] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    2.366094] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    2.375568] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    2.382828] TCP: Hash tables configured (established 262144 bind 65536)
[    2.389432] TCP reno registered
[    2.392608] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    2.398621] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    2.405276] NET: Registered protocol family 1
[    2.409753] pci 0000:01:05.0: Boot video device
[    2.409762] PCI: CLS 64 bytes, default 64
[    2.411104] PM: Adding info for No Bus:mcelog
[    2.411230] PM: Adding info for No Bus:msr0
[    2.411291] PM: Adding info for No Bus:msr1
[    2.411402] PM: Adding info for No Bus:cpu0
[    2.411463] PM: Adding info for No Bus:cpu1
[    2.411618] PM: Adding info for platform:pcspkr
[    2.411679] PM: Adding info for platform:microcode
[    2.411732] microcode: microcode: CPU0: AMD CPU family 0xf not supported
[    2.418439] microcode: microcode: CPU1: AMD CPU family 0xf not supported
[    2.425140] PM: Adding info for No Bus:microcode
[    2.425203] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    2.434569] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.441506] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    2.451158] msgmni has been set to 3813
[    2.455056] io scheduler noop registered (default)
[    2.460050] pcieport 0000:00:04.0: setting latency timer to 64
[    2.460085] pcieport 0000:00:04.0: irq 24 for MSI/MSI-X
[    2.460103] PM: Adding info for pci_express:0000:00:04.0:pcie01
[    2.460163] PM: Adding info for pci_express:0000:00:04.0:pcie08
[    2.460240] pcieport 0000:00:05.0: setting latency timer to 64
[    2.460268] pcieport 0000:00:05.0: irq 25 for MSI/MSI-X
[    2.460279] PM: Adding info for pci_express:0000:00:05.0:pcie01
[    2.460335] PM: Adding info for pci_express:0000:00:05.0:pcie08
[    2.460412] pcieport 0000:00:06.0: setting latency timer to 64
[    2.460439] pcieport 0000:00:06.0: irq 26 for MSI/MSI-X
[    2.460450] PM: Adding info for pci_express:0000:00:06.0:pcie01
[    2.460508] PM: Adding info for pci_express:0000:00:06.0:pcie04
[    2.460565] PM: Adding info for pci_express:0000:00:06.0:pcie08
[    2.460740] pcieport 0000:00:04.0: Requesting control of PCIe PME from ACPI BIOS
[    2.468132] pcieport 0000:00:04.0: Failed to receive control of PCIe PME service: no _OSC support
[    2.477041] pcie_pme: probe of 0000:00:04.0:pcie01 failed with error -13
[    2.483754] pcieport 0000:00:05.0: Requesting control of PCIe PME from ACPI BIOS
[    2.491152] pcieport 0000:00:05.0: Failed to receive control of PCIe PME service: no _OSC support
[    2.500027] pcie_pme: probe of 0000:00:05.0:pcie01 failed with error -13
[    2.506719] pcieport 0000:00:06.0: Requesting control of PCIe PME from ACPI BIOS
[    2.514130] pcieport 0000:00:06.0: Failed to receive control of PCIe PME service: no _OSC support
[    2.523007] pcie_pme: probe of 0000:00:06.0:pcie01 failed with error -13
[    2.529819] PM: Adding info for No Bus:fbcon
[    2.530129] PM: Adding info for No Bus:input0
[    2.530192] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    2.538523] ACPI: Power Button [PWRB]
[    2.542239] PM: Adding info for No Bus:input1
[    2.542298] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    2.549676] ACPI: Power Button [PWRF]
[    2.553890] ACPI: duty_cycle spans bit 4
[    2.557831] PM: Adding info for No Bus:cooling_device0
[    2.557925] PM: Adding info for No Bus:cooling_device1
[    2.562045] PM: Adding info for No Bus:tty
[    2.562104] PM: Adding info for No Bus:console
[    2.562160] PM: Adding info for No Bus:tty0
[    2.562270] PM: Adding info for No Bus:vcs
[    2.562328] PM: Adding info for No Bus:vcsa
[    2.562388] PM: Adding info for No Bus:vcs1
[    2.562442] PM: Adding info for No Bus:vcsa1
[    2.562500] PM: Adding info for No Bus:tty1
[    2.562553] PM: Adding info for No Bus:tty2
[    2.562615] PM: Adding info for No Bus:tty3
[    2.562671] PM: Adding info for No Bus:tty4
[    2.562732] PM: Adding info for No Bus:tty5
[    2.562792] PM: Adding info for No Bus:tty6
[    2.562853] PM: Adding info for No Bus:tty7
[    2.562911] PM: Adding info for No Bus:tty8
[    2.562968] PM: Adding info for No Bus:tty9
[    2.563025] PM: Adding info for No Bus:tty10
[    2.563083] PM: Adding info for No Bus:tty11
[    2.563145] PM: Adding info for No Bus:tty12
[    2.563201] PM: Adding info for No Bus:tty13
[    2.563259] PM: Adding info for No Bus:tty14
[    2.563315] PM: Adding info for No Bus:tty15
[    2.563371] PM: Adding info for No Bus:tty16
[    2.563434] PM: Adding info for No Bus:tty17
[    2.563494] PM: Adding info for No Bus:tty18
[    2.563555] PM: Adding info for No Bus:tty19
[    2.563616] PM: Adding info for No Bus:tty20
[    2.563673] PM: Adding info for No Bus:tty21
[    2.563731] PM: Adding info for No Bus:tty22
[    2.563794] PM: Adding info for No Bus:tty23
[    2.563858] PM: Adding info for No Bus:tty24
[    2.563918] PM: Adding info for No Bus:tty25
[    2.563980] PM: Adding info for No Bus:tty26
[    2.564037] PM: Adding info for No Bus:tty27
[    2.564096] PM: Adding info for No Bus:tty28
[    2.564160] PM: Adding info for No Bus:tty29
[    2.564221] PM: Adding info for No Bus:tty30
[    2.564280] PM: Adding info for No Bus:tty31
[    2.564342] PM: Adding info for No Bus:tty32
[    2.564400] PM: Adding info for No Bus:tty33
[    2.564459] PM: Adding info for No Bus:tty34
[    2.564517] PM: Adding info for No Bus:tty35
[    2.564582] PM: Adding info for No Bus:tty36
[    2.564640] PM: Adding info for No Bus:tty37
[    2.564700] PM: Adding info for No Bus:tty38
[    2.564762] PM: Adding info for No Bus:tty39
[    2.564828] PM: Adding info for No Bus:tty40
[    2.564891] PM: Adding info for No Bus:tty41
[    2.564953] PM: Adding info for No Bus:tty42
[    2.565012] PM: Adding info for No Bus:tty43
[    2.565076] PM: Adding info for No Bus:tty44
[    2.565136] PM: Adding info for No Bus:tty45
[    2.565197] PM: Adding info for No Bus:tty46
[    2.565258] PM: Adding info for No Bus:tty47
[    2.565318] PM: Adding info for No Bus:tty48
[    2.565379] PM: Adding info for No Bus:tty49
[    2.565444] PM: Adding info for No Bus:tty50
[    2.565505] PM: Adding info for No Bus:tty51
[    2.565569] PM: Adding info for No Bus:tty52
[    2.565629] PM: Adding info for No Bus:tty53
[    2.565694] PM: Adding info for No Bus:tty54
[    2.565755] PM: Adding info for No Bus:tty55
[    2.565816] PM: Adding info for No Bus:tty56
[    2.565881] PM: Adding info for No Bus:tty57
[    2.565946] PM: Adding info for No Bus:tty58
[    2.566015] PM: Adding info for No Bus:tty59
[    2.566079] PM: Adding info for No Bus:tty60
[    2.566142] PM: Adding info for No Bus:tty61
[    2.566202] PM: Adding info for No Bus:tty62
[    2.566267] PM: Adding info for No Bus:tty63
[    2.566402] PM: Adding info for No Bus:ptmx
[    2.566479] PM: Adding info for No Bus:hpet
[    2.566612] Linux agpgart interface v0.103
[    2.570788] [drm] Initialized drm 1.1.0 20060810
[    2.575408] PM: Adding info for No Bus:ttm
[    2.575471] [drm] radeon defaulting to kernel modesetting.
[    2.580978] [drm] radeon kernel modesetting enabled.
[    2.586023] radeon 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.595783] PM: Adding info for No Bus:controlD64
[    2.596012] PM: Adding info for No Bus:card0
[    2.596103] [drm] initializing kernel modesetting (RS690 0x1002:0x791E).
[    2.602914] [drm] register mmio base: 0xFDDF0000
[    2.607521] [drm] register mmio size: 65536
[    2.612311] ATOM BIOS: ATI
[    2.615048] [drm] 1 Power State(s)
[    2.618448] [drm] State 0  (default)
[    2.622051] [drm] 	1 Clock Mode(s)
[    2.625447] [drm] 		0 engine: 400000
[    2.629026] [drm] radeon: power management initialized
[    2.634181] radeon 0000:01:05.0: VRAM: 32M 0x7E000000 - 0x7FFFFFFF (32M used)
[    2.641321] radeon 0000:01:05.0: GTT: 512M 0x80000000 - 0x9FFFFFFF
[    2.647523] [drm] radeon: irq initialized.
[    2.651862] [drm] Detected VRAM RAM=32M, BAR=32M
[    2.656483] [drm] RAM width 128bits DDR
[    2.660425] [TTM] Zone  kernel: Available graphics memory: 976278 kiB.
[    2.666939] [ttm] Initializing pool allocator.
[    2.671449] [drm] radeon: 32M of VRAM memory ready
[    2.676232] [drm] radeon: 512M of GTT memory ready.
[    2.681128] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    2.691142] [drm] radeon: 1 quad pipes, 1 z pipes initialized.
[    2.705569] PM: Adding info for platform:radeon_cp.0
[    2.705673] [drm] Loading RS690/RS740 Microcode
[    2.710223] platform radeon_cp.0: firmware: using built-in firmware radeon/RS690_cp.bin
[    2.718208] PM: Removing info for platform:radeon_cp.0
[    2.718464] [drm] radeon: ring at 0x0000000080000000
[    2.723465] [drm] ring test succeeded in 1 usecs
[    2.728201] [drm] radeon: ib pool ready.
[    2.732145] [drm] ib test succeeded in 0 usecs
[    2.736614] [drm] Default TV standard: NTSC
[    2.740837] PM: Adding info for i2c:i2c-0
[    2.740900] PM: Adding info for No Bus:card0-VGA-1
[    2.741010] [drm] Default TV standard: NTSC
[    2.745193] PM: Adding info for No Bus:card0-SVIDEO-1
[    2.745314] PM: Adding info for i2c:i2c-1
[    2.745372] PM: Adding info for No Bus:card0-DVI-D-1
[    2.745482] PM: Adding info for i2c:i2c-2
[    2.745537] PM: Adding info for No Bus:card0-HDMI Type A-1
[    2.745640] [drm] Radeon Display Connectors
[    2.749821] [drm] Connector 0:
[    2.752900] [drm]   VGA
[    2.755345] [drm]   DDC: 0x7e50 0x7e40 0x7e54 0x7e44 0x7e58 0x7e48 0x7e5c 0x7e4c
[    2.762749] [drm]   Encoders:
[    2.765718] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    2.770347] [drm] Connector 1:
[    2.773396] [drm]   S-video
[    2.776190] [drm]   Encoders:
[    2.779159] [drm]     TV1: INTERNAL_KLDSCP_DAC1
[    2.783713] [drm] Connector 2:
[    2.786768] [drm]   DVI-D
[    2.789391] [drm]   HPD2
[    2.791950] [drm]   DDC: 0x7e40 0x7e60 0x7e44 0x7e64 0x7e48 0x7e68 0x7e4c 0x7e6c
[    2.799329] [drm]   Encoders:
[    2.802319] [drm]     DFP2: INTERNAL_DDI
[    2.806240] [drm] Connector 3:
[    2.809297] [drm]   HDMI-A
[    2.812028] [drm]   DDC: 0x7e40 0x7e50 0x7e44 0x7e54 0x7e48 0x7e58 0x7e4c 0x7e5c
[    2.819410] [drm]   Encoders:
[    2.822399] [drm]     DFP3: INTERNAL_LVTM1
[    2.882042] Slow work thread pool: Starting up
[    2.886536] Slow work thread pool: Ready
[    3.128148] [drm] fb mappable at 0xF8040000
[    3.132355] [drm] vram apper at 0xF8000000
[    3.136448] [drm] size 1310720
[    3.139503] [drm] fb depth is 8
[    3.142670] [drm]    pitch is 1280
[    3.146097] PM: Adding info for No Bus:fb0
[    3.146191] PM: Adding info for No Bus:vtcon1
[    3.166522] Console: switching to colour frame buffer device 160x64
[    3.175905] fb0: radeondrmfb frame buffer device
[    3.180535] registered panic notifier
[    3.184199] [drm] Initialized radeon 2.3.0 20080528 for 0000:01:05.0 on minor 0
[    3.191587] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    3.197950] PM: Adding info for platform:serial8250
[    3.198100] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.204155] PM: Adding info for No Bus:ttyS0
[    3.204293] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    3.210321] PM: Adding info for No Bus:ttyS1
[    3.210460] serial8250: ttyS2 at I/O 0x3e8 (irq = 4) is a 16550A
[    3.216475] PM: Adding info for No Bus:ttyS2
[    3.216625] serial8250: ttyS3 at I/O 0x2e8 (irq = 3) is a 16550A
[    3.222664] PM: Adding info for No Bus:ttyS3
[    3.222938] PM: Adding info for No Bus:loop0
[    3.223020] PM: Adding info for No Bus:7:0
[    3.223086] PM: Adding info for No Bus:loop1
[    3.223158] PM: Adding info for No Bus:7:1
[    3.223219] PM: Adding info for No Bus:loop2
[    3.223297] PM: Adding info for No Bus:7:2
[    3.223361] PM: Adding info for No Bus:loop3
[    3.223439] PM: Adding info for No Bus:7:3
[    3.223504] PM: Adding info for No Bus:loop4
[    3.223578] PM: Adding info for No Bus:7:4
[    3.223640] PM: Adding info for No Bus:loop5
[    3.223718] PM: Adding info for No Bus:7:5
[    3.223791] PM: Adding info for No Bus:loop6
[    3.223870] PM: Adding info for No Bus:7:6
[    3.223934] PM: Adding info for No Bus:loop7
[    3.224007] PM: Adding info for No Bus:7:7
[    3.224055] loop: module loaded
[    3.227381] ahci 0000:00:12.0: version 3.0
[    3.227406] ahci 0000:00:12.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    3.234237] ahci 0000:00:12.0: controller can't do 64bit DMA, forcing 32bit
[    3.241293] ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[    3.249371] ahci 0000:00:12.0: flags: ncq sntf ilck led clo pmp pio ccc 
[    3.256669] scsi0 : ahci
[    3.259348] PM: Adding info for scsi:host0
[    3.259453] PM: Adding info for No Bus:host0
[    3.259541] scsi1 : ahci
[    3.262100] PM: Adding info for scsi:host1
[    3.262167] PM: Adding info for No Bus:host1
[    3.262249] scsi2 : ahci
[    3.264795] PM: Adding info for scsi:host2
[    3.264867] PM: Adding info for No Bus:host2
[    3.264944] scsi3 : ahci
[    3.267489] PM: Adding info for scsi:host3
[    3.267559] PM: Adding info for No Bus:host3
[    3.267727] ata1: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 22
[    3.275966] ata2: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 22
[    3.284156] ata3: SATA max UDMA/133 irq_stat 0x00400040, connection status changed
[    3.291726] ata4: SATA max UDMA/133 abar m1024@0xfdbff800 port 0xfdbffa80 irq 22
[    3.299785] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    3.307390] PM: Adding info for platform:i8042
[    3.307783] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.312763] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.317840] PM: Adding info for serio:serio0
[    3.317929] PM: Adding info for No Bus:mice
[    3.317969] PM: Adding info for serio:serio1
[    3.318009] PM: Adding info for No Bus:psaux
[    3.318049] mice: PS/2 mouse device common for all mice
[    3.323334] PM: Adding info for No Bus:event0
[    3.323389] PM: Adding info for No Bus:event1
[    3.323585] rtc_cmos 00:03: RTC can wake from S4
[    3.328232] PM: Adding info for No Bus:rtc0
[    3.328290] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    3.334429] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    3.341399] it87: Found IT8712F chip at 0xe80, revision 8
[    3.346811] it87: VID is disabled (pins used for GPIO)
[    3.351963] it87: in3 is VCC (+5V)
[    3.355384] it87: in7 is VCCH (+5V Stand-By)
[    3.359718] PM: Adding info for No Bus:input2
[    3.359728] PM: Adding info for platform:it87.3712
[    3.360022] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    3.360073] PM: Adding info for No Bus:hwmon0
[    3.368645] PM: Adding info for No Bus:event2
[    3.368723] k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
[    3.376924] PM: Adding info for No Bus:hwmon1
[    3.377051] it8712f_wdt: Found IT8712F chip revision 8 - using DogFood address 0x201
[    3.384800] it8712f_wdt: disabling watchdog timer
[    3.384845] PM: Adding info for No Bus:watchdog
[    3.384894] md: raid0 personality registered for level 0
[    3.390203] md: raid1 personality registered for level 1
[    3.395528] md: raid6 personality registered for level 6
[    3.400834] md: raid5 personality registered for level 5
[    3.406159] md: raid4 personality registered for level 4
[    3.411798] PM: Adding info for No Bus:device-mapper
[    3.411858] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
[    3.420314] cpuidle: using governor ladder
[    3.424420] cpuidle: using governor menu
[    3.428349] Netfilter messages via NETLINK v0.30.
[    3.433104] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    3.439407] xt_time: kernel timezone is -0000
[    3.443853] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.449174] TCP cubic registered
[    3.452685] NET: Registered protocol family 10
[    3.457441] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    3.462879] NET: Registered protocol family 17
[    3.467323] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[    3.474124] All bugs added by David S. Miller <davem@redhat.com>
[    3.480149] powernow-k8: Found 1 AMD Turion(tm) 64 X2 Mobile Technology TL-56 processors (2 cpu cores) (version 2.20.00)
[    3.491087] powernow-k8:    0 : fid 0xa (1800 MHz), vid 0x12
[    3.496753] powernow-k8:    1 : fid 0x8 (1600 MHz), vid 0x14
[    3.502408] powernow-k8:    2 : fid 0x0 (800 MHz), vid 0x1e
[    3.508179] PM: Adding info for No Bus:cpu_dma_latency
[    3.508243] PM: Adding info for No Bus:network_latency
[    3.508304] PM: Adding info for No Bus:network_throughput
[    3.508758] rtc_cmos 00:03: setting system clock to 2010-05-02 12:08:56 UTC (1272802136)
[    3.640042] ata4: SATA link down (SStatus 0 SControl 300)
[    4.022517] Clocksource tsc unstable (delta = -206907842 ns)
[    4.040053] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.040146] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.040205] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.060243] ata2.00: ATA-8: FUJITSU MHW2160BH, 0000001C, max UDMA/100
[    4.060267] ata3.00: ATA-8: FUJITSU MHW2160BH, 0000001C, max UDMA/100
[    4.060273] ata3.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    4.060320] ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
[    4.060787] ata1.00: ATA-8: FUJITSU MHW2160BH, 0000001C, max UDMA/100
[    4.060793] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    4.060835] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[    4.061386] ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
[    4.061391] ata3.00: configured for UDMA/100
[    4.061844] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[    4.061848] ata1.00: configured for UDMA/100
[    4.062036] scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHW2160B 0000 PQ: 0 ANSI: 5
[    4.062071] PM: Adding info for scsi:target0:0:0
[    4.139618] ata2.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    4.147305] ata2.00: SB600 AHCI: limiting to 255 sectors per cmd
[    4.153907] PM: Adding info for scsi:0:0:0:0
[    4.154053] PM: Adding info for No Bus:0:0:0:0
[    4.154168] PM: Adding info for No Bus:0:0:0:0
[    4.154239] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    4.154849] ata2.00: SB600 AHCI: limiting to 255 sectors per cmd
[    4.154855] ata2.00: configured for UDMA/100
[    4.155032] scsi 1:0:0:0: Direct-Access     ATA      FUJITSU MHW2160B 0000 PQ: 0 ANSI: 5
[    4.155059] PM: Adding info for scsi:target1:0:0
[    4.155163] PM: Adding info for scsi:1:0:0:0
[    4.155263] PM: Adding info for No Bus:1:0:0:0
[    4.155359] PM: Adding info for No Bus:1:0:0:0
[    4.155452] sd 1:0:0:0: [sdb] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    4.155558] sd 1:0:0:0: [sdb] Write Protect is off
[    4.155563] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    4.155608] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.155659] PM: Adding info for No Bus:sdb
[    4.155866]  sdb:
[    4.170157] scsi 2:0:0:0: Direct-Access     ATA      FUJITSU MHW2160B 0000 PQ: 0 ANSI: 5
[    4.170181] PM: Adding info for scsi:target2:0:0
[    4.170289] PM: Adding info for scsi:2:0:0:0
[    4.170403] PM: Adding info for No Bus:2:0:0:0
[    4.170493] PM: Adding info for No Bus:2:0:0:0
[    4.170586] sd 2:0:0:0: [sdc] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    4.170688] sd 2:0:0:0: [sdc] Write Protect is off
[    4.170692] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    4.170737] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.170785] PM: Adding info for No Bus:sdc
[    4.170983]  sdc:
[    4.240149] sd 0:0:0:0: [sda] Write Protect is off
[    4.245525] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.245571] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.255344] PM: Adding info for No Bus:sda
[    4.255559]  sda: sda1 sda2 sda3 sda4 sda5 sda6 sda7
[    4.373091] PM: Adding info for No Bus:sda1
[    4.373133] PM: Adding info for No Bus:sda2
[    4.373179] PM: Adding info for No Bus:sda3
[    4.373217] PM: Adding info for No Bus:sda4
[    4.373257] PM: Adding info for No Bus:sda5
[    4.373306] PM: Adding info for No Bus:sda6
[    4.373349] PM: Adding info for No Bus:sda7
[    4.374157] PM: Adding info for No Bus:8:0
[    4.374430] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.569073]  sdb1 sdb2 sdb3 sdb4 sdb5 sdb6 sdb7
[    4.574152] PM: Adding info for No Bus:sdb1
[    4.574197] PM: Adding info for No Bus:sdb2
[    4.574241] PM: Adding info for No Bus:sdb3
[    4.574282] PM: Adding info for No Bus:sdb4
[    4.574324] PM: Adding info for No Bus:sdb5
[    4.574370] PM: Adding info for No Bus:sdb6
[    4.574410] PM: Adding info for No Bus:sdb7
[    4.575214] PM: Adding info for No Bus:8:16
[    4.575346]  sdc1
[    4.575496] sd 1:0:0:0: [sdb] Attached SCSI disk
[    4.582349]  sdc2 sdc3 sdc4 sdc5 sdc6 sdc7
[    4.586957] PM: Adding info for No Bus:sdc1
[    4.587001] PM: Adding info for No Bus:sdc2
[    4.587049] PM: Adding info for No Bus:sdc3
[    4.587090] PM: Adding info for No Bus:sdc4
[    4.587134] PM: Adding info for No Bus:sdc5
[    4.587176] PM: Adding info for No Bus:sdc6
[    4.587218] PM: Adding info for No Bus:sdc7
[    4.588023] PM: Adding info for No Bus:8:32
[    4.588312] sd 2:0:0:0: [sdc] Attached SCSI disk
[    4.593352] md: Waiting for all devices to be available before autodetect
[    4.600698] md: If you don't use raid, use raid=noautodetect
[    4.606903] PM: Adding info for No Bus:md0
[    4.607054] PM: Adding info for No Bus:9:0
[    4.607174] md: Autodetecting RAID arrays.
[    4.855724] md: Scanned 16 and added 16 devices.
[    4.860724] md: autorun ...
... (skipping md scan)
[    5.485347] md: ... autorun DONE.
[    5.488893]  md0: unknown partition table
[    5.572773] XFS mounting filesystem md0
[    5.661654] Starting XFS recovery on filesystem: md0 (logdev: internal)
[    5.829276] Ending XFS recovery on filesystem: md0 (logdev: internal)
[    5.836311] VFS: Mounted root (xfs filesystem) readonly on device 9:0.
[    5.843409] Freeing unused kernel memory: 492k freed
[    8.948822] udev: starting version 149
[    9.076708] tg3.c:v3.108 (February 17, 2010)
[    9.081335] tg3 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    9.088572] tg3 0000:02:00.0: setting latency timer to 64
[    9.223109] pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    9.229719] PM: Adding info for No Bus:eth0
[    9.229826] tg3 0000:02:00.0: eth0: Tigon3 [partno(none) rev b002] (PCI Express) MAC address 00:08:9b:b4:42:e6
[    9.229829] tg3 0000:02:00.0: eth0: attached PHY is 5787 (10/100/1000Base-T Ethernet) (WireSpeed[1])
[    9.229832] tg3 0000:02:00.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    9.229835] tg3 0000:02:00.0: eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    9.229871] tg3 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    9.229884] tg3 0000:03:00.0: setting latency timer to 64
[    9.236778] PM: Adding info for No Bus:sg0
[    9.236792] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    9.236814] PM: Adding info for No Bus:sg1
[    9.236825] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    9.236847] PM: Adding info for No Bus:sg2
[    9.236858] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    9.290448] pata_atiixp 0000:00:14.1: setting latency timer to 64
[    9.291847] scsi4 : pata_atiixp
[    9.295211] PM: Adding info for scsi:host4
[    9.295257] PM: Adding info for No Bus:host4
[    9.295304] scsi5 : pata_atiixp
[    9.298607] PM: Adding info for scsi:host5
[    9.298639] PM: Adding info for No Bus:host5
[    9.306893] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
[    9.314361] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
[    9.329595] usbcore: registered new interface driver usbfs
[    9.335454] usbcore: registered new interface driver hub
[    9.341819] usbcore: registered new device driver usb
[    9.349553] PM: Adding info for No Bus:eth1
[    9.349659] tg3 0000:03:00.0: eth1: Tigon3 [partno(none) rev b002] (PCI Express) MAC address 00:08:9b:b4:42:e7
[    9.350033] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    9.350083] ehci_hcd 0000:00:13.5: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    9.350109] ehci_hcd 0000:00:13.5: EHCI Host Controller
[    9.350119] ehci_hcd 0000:00:13.5: new USB bus registered, assigned bus number 1
[    9.350153] ehci_hcd 0000:00:13.5: applying AMD SB600/SB700 USB freeze workaround
[    9.350184] ehci_hcd 0000:00:13.5: debug port 1
[    9.350217] ehci_hcd 0000:00:13.5: irq 19, io mem 0xfdbff000
[    9.360066] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    9.362550] ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00
[    9.362571] usb usb1: __pm_runtime_resume()!
[    9.362573] usb usb1: __pm_runtime_resume() returns 1!
[    9.362590] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    9.362592] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    9.362595] usb usb1: Product: EHCI Host Controller
[    9.362597] usb usb1: Manufacturer: Linux 2.6.34-rc6 ehci_hcd
[    9.362598] usb usb1: SerialNumber: 0000:00:13.5
[    9.362653] PM: Adding info for usb:usb1
[    9.362686] usb usb1: __pm_runtime_resume()!
[    9.362688] usb usb1: __pm_runtime_resume() returns 1!
[    9.362707] PM: Adding info for usb:1-0:1.0
[    9.362722] usb usb1: __pm_runtime_resume()!
[    9.362724] usb usb1: __pm_runtime_resume() returns 1!
[    9.362727] hub 1-0:1.0: USB hub found
[    9.362732] hub 1-0:1.0: 10 ports detected
[    9.362801] PM: Adding info for No Bus:ep_81
[    9.362815] PM: Adding info for No Bus:ep_00
[    9.363059] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    9.363086] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    9.363093] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
[    9.363134] ohci_hcd 0000:00:13.0: irq 16, io mem 0xfdbfe000
[    9.426562] usb usb2: __pm_runtime_resume()!
[    9.426567] usb usb2: __pm_runtime_resume() returns 1!
[    9.426585] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    9.426587] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    9.426590] usb usb2: Product: OHCI Host Controller
[    9.426591] usb usb2: Manufacturer: Linux 2.6.34-rc6 ohci_hcd
[    9.426593] usb usb2: SerialNumber: 0000:00:13.0
[    9.426648] PM: Adding info for usb:usb2
[    9.426684] usb usb2: __pm_runtime_resume()!
[    9.426686] usb usb2: __pm_runtime_resume() returns 1!
[    9.426713] PM: Adding info for usb:2-0:1.0
[    9.426728] usb usb2: __pm_runtime_resume()!
[    9.426730] usb usb2: __pm_runtime_resume() returns 1!
[    9.426733] hub 2-0:1.0: USB hub found
[    9.426742] hub 2-0:1.0: 2 ports detected
[    9.426763] PM: Adding info for No Bus:ep_81
[    9.426777] PM: Adding info for No Bus:ep_00
[    9.426837] ohci_hcd 0000:00:13.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    9.426863] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    9.426872] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
[    9.426912] ohci_hcd 0000:00:13.1: irq 17, io mem 0xfdbfd000
[    9.462570] hub 1-0:1.0: __pm_runtime_resume()!
[    9.462573] hub 1-0:1.0: __pm_runtime_resume() returns 1!
[    9.462577] hub 1-0:1.0: __pm_runtime_suspend()!
[    9.462582] hub 1-0:1.0: __pm_runtime_suspend() returns 0!
[    9.486621] usb usb3: __pm_runtime_resume()!
[    9.486624] usb usb3: __pm_runtime_resume() returns 1!
[    9.486641] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    9.486643] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    9.486645] usb usb3: Product: OHCI Host Controller
[    9.486647] usb usb3: Manufacturer: Linux 2.6.34-rc6 ohci_hcd
[    9.486649] usb usb3: SerialNumber: 0000:00:13.1
[    9.486702] PM: Adding info for usb:usb3
[    9.486738] usb usb3: __pm_runtime_resume()!
[    9.486739] usb usb3: __pm_runtime_resume() returns 1!
[    9.486757] PM: Adding info for usb:3-0:1.0
[    9.486771] usb usb3: __pm_runtime_resume()!
[    9.486773] usb usb3: __pm_runtime_resume() returns 1!
[    9.486776] hub 3-0:1.0: USB hub found
[    9.486785] hub 3-0:1.0: 2 ports detected
[    9.486809] PM: Adding info for No Bus:ep_81
[    9.486821] PM: Adding info for No Bus:ep_00
[    9.486881] ohci_hcd 0000:00:13.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    9.486910] ohci_hcd 0000:00:13.2: OHCI Host Controller
[    9.486917] ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 4
[    9.486941] ohci_hcd 0000:00:13.2: irq 18, io mem 0xfdbfc000
[    9.522568] hub 2-0:1.0: __pm_runtime_resume()!
[    9.522571] hub 2-0:1.0: __pm_runtime_resume() returns 1!
[    9.522575] hub 2-0:1.0: __pm_runtime_suspend()!
[    9.522580] hub 2-0:1.0: __pm_runtime_suspend() returns 0!
[    9.546615] usb usb4: __pm_runtime_resume()!
[    9.546619] usb usb4: __pm_runtime_resume() returns 1!
[    9.546637] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    9.546640] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    9.546642] usb usb4: Product: OHCI Host Controller
[    9.546644] usb usb4: Manufacturer: Linux 2.6.34-rc6 ohci_hcd
[    9.546646] usb usb4: SerialNumber: 0000:00:13.2
[    9.546702] PM: Adding info for usb:usb4
[    9.546737] usb usb4: __pm_runtime_resume()!
[    9.546739] usb usb4: __pm_runtime_resume() returns 1!
[    9.546759] PM: Adding info for usb:4-0:1.0
[    9.546774] usb usb4: __pm_runtime_resume()!
[    9.546776] usb usb4: __pm_runtime_resume() returns 1!
[    9.546778] hub 4-0:1.0: USB hub found
[    9.546788] hub 4-0:1.0: 2 ports detected
[    9.546809] PM: Adding info for No Bus:ep_81
[    9.546823] PM: Adding info for No Bus:ep_00
[    9.546883] ohci_hcd 0000:00:13.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    9.546912] ohci_hcd 0000:00:13.3: OHCI Host Controller
[    9.546919] ohci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 5
[    9.546945] ohci_hcd 0000:00:13.3: irq 17, io mem 0xfdbfb000
[    9.709746] tg3 0000:03:00.0: eth1: attached PHY is 5787 (10/100/1000Base-T Ethernet) (WireSpeed[1])
[    9.713941] PM: Adding info for No Bus:timer
[    9.719396] tg3 0000:03:00.0: eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    9.735307] tg3 0000:03:00.0: eth1: dma_rwctrl[76180000] dma_mask[64-bit]
[    9.742979] hub 3-0:1.0: __pm_runtime_resume()!
[    9.742981] hub 3-0:1.0: __pm_runtime_resume() returns 1!
[    9.742986] hub 3-0:1.0: __pm_runtime_suspend()!
[    9.742992] hub 3-0:1.0: __pm_runtime_suspend() returns 0!
[    9.742995] hub 4-0:1.0: __pm_runtime_resume()!
[    9.742997] hub 4-0:1.0: __pm_runtime_resume() returns 1!
[    9.743000] hub 4-0:1.0: __pm_runtime_suspend()!
[    9.743002] hub 4-0:1.0: __pm_runtime_suspend() returns 0!
[    9.749511] usb usb5: __pm_runtime_resume()!
[    9.749517] usb usb5: __pm_runtime_resume() returns 1!
[    9.749535] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    9.756886] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    9.764528] usb usb5: Product: OHCI Host Controller
[    9.769777] usb usb5: Manufacturer: Linux 2.6.34-rc6 ohci_hcd
[    9.775842] usb usb5: SerialNumber: 0000:00:13.3
[    9.780789] PM: Adding info for usb:usb5
[    9.780827] usb usb5: __pm_runtime_resume()!
[    9.780829] usb usb5: __pm_runtime_resume() returns 1!
[    9.780850] PM: Adding info for usb:5-0:1.0
[    9.780866] usb usb5: __pm_runtime_resume()!
[    9.780868] usb usb5: __pm_runtime_resume() returns 1!
[    9.780871] hub 5-0:1.0: USB hub found
[    9.784880] hub 5-0:1.0: 2 ports detected
[    9.789185] PM: Adding info for No Bus:ep_81
[    9.789201] PM: Adding info for No Bus:ep_00
[    9.789253] ohci_hcd 0000:00:13.4: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    9.797361] ohci_hcd 0000:00:13.4: OHCI Host Controller
[    9.802866] ohci_hcd 0000:00:13.4: new USB bus registered, assigned bus number 6
[    9.811155] ohci_hcd 0000:00:13.4: irq 18, io mem 0xfdbfa000
[    9.876561] usb usb6: __pm_runtime_resume()!
[    9.876566] usb usb6: __pm_runtime_resume() returns 1!
[    9.876584] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    9.883850] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    9.891446] usb usb6: Product: OHCI Host Controller
[    9.896604] usb usb6: Manufacturer: Linux 2.6.34-rc6 ohci_hcd
[    9.902900] usb usb6: SerialNumber: 0000:00:13.4
[    9.907841] PM: Adding info for usb:usb6
[    9.907883] usb usb6: __pm_runtime_resume()!
[    9.907885] usb usb6: __pm_runtime_resume() returns 1!
[    9.907909] PM: Adding info for usb:6-0:1.0
[    9.907928] usb usb6: __pm_runtime_resume()!
[    9.907930] usb usb6: __pm_runtime_resume() returns 1!
[    9.907933] hub 6-0:1.0: USB hub found
[    9.911927] hub 6-0:1.0: 2 ports detected
[    9.911952] PM: Adding info for No Bus:ep_81
[    9.911972] PM: Adding info for No Bus:ep_00
[    9.912071] hub 5-0:1.0: __pm_runtime_resume()!
[    9.912073] hub 5-0:1.0: __pm_runtime_resume() returns 1!
[    9.912076] hub 5-0:1.0: __pm_runtime_suspend()!
[    9.912082] hub 5-0:1.0: __pm_runtime_suspend() returns 0!
[    9.972811] ATI IXP AC97 controller 0000:00:14.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    9.994517] PM: Adding info for No Bus:card0
[    9.994562] PM: Adding info for No Bus:pcmC0D1p
[    9.994595] PM: Adding info for No Bus:pcmC0D0p
[    9.994625] PM: Adding info for No Bus:pcmC0D0c
[    9.994650] PM: Adding info for ac97:0-0:ALC655
[    9.994675] PM: Adding info for No Bus:controlC0
[   10.002559] hub 6-0:1.0: __pm_runtime_resume()!
[   10.002565] hub 6-0:1.0: __pm_runtime_resume() returns 1!
[   10.002569] hub 6-0:1.0: __pm_runtime_suspend()!
[   10.002574] hub 6-0:1.0: __pm_runtime_suspend() returns 0!
[   12.012587] usb usb1: __pm_runtime_suspend() from workqueue!
[   12.013594] usb usb1: __pm_runtime_suspend() returns 0!
[   12.013600] usb usb2: __pm_runtime_suspend() from workqueue!
[   12.013617] usb usb2: __pm_runtime_suspend() returns 0!
[   12.013622] usb usb5: __pm_runtime_suspend() from workqueue!
[   12.013638] usb usb5: __pm_runtime_suspend() returns 0!
[   12.013643] usb usb6: __pm_runtime_suspend() from workqueue!
[   12.013658] usb usb6: __pm_runtime_suspend() returns 0!
[   12.025545] PM: Adding info for No Bus:dm-0
[   12.025683] PM: Adding info for No Bus:253:0
[   12.050047] usb usb3: __pm_runtime_suspend() from workqueue!
[   12.050087] usb usb3: __pm_runtime_suspend() returns 0!
[   12.050093] usb usb4: __pm_runtime_suspend() from workqueue!
[   12.050109] usb usb4: __pm_runtime_suspend() returns 0!
[   12.064287] PM: Adding info for No Bus:dm-1
[   12.064434] PM: Adding info for No Bus:253:1
[   12.100192] PM: Adding info for No Bus:dm-2
[   12.100255] PM: Adding info for No Bus:253:2
[   12.118868] PM: Adding info for No Bus:dm-3
[   12.118940] PM: Adding info for No Bus:253:3
[   12.136050] PM: Adding info for No Bus:dm-4
[   12.136121] PM: Adding info for No Bus:253:4
[   12.153312] PM: Adding info for No Bus:dm-5
[   12.153382] PM: Adding info for No Bus:253:5
[   12.170558] PM: Adding info for No Bus:dm-6
[   12.170633] PM: Adding info for No Bus:253:6
[   12.190216] PM: Adding info for No Bus:dm-7
[   12.190418] PM: Adding info for No Bus:253:7
[   12.208871] PM: Adding info for No Bus:dm-8
[   12.208948] PM: Adding info for No Bus:253:8
[   12.226684] PM: Adding info for No Bus:dm-9
[   12.226760] PM: Adding info for No Bus:253:9
[   12.245211] PM: Adding info for No Bus:dm-10
[   12.245302] PM: Adding info for No Bus:253:10
[   12.263415] PM: Adding info for No Bus:dm-11
[   12.263495] PM: Adding info for No Bus:253:11
[   12.281785] PM: Adding info for No Bus:dm-12
[   12.281902] PM: Adding info for No Bus:253:12
[   12.301353] PM: Adding info for No Bus:dm-13
[   12.301433] PM: Adding info for No Bus:253:13
[   12.322275] PM: Adding info for No Bus:dm-14
[   12.322349] PM: Adding info for No Bus:253:14
[   12.341215] PM: Adding info for No Bus:dm-15
[   12.341296] PM: Adding info for No Bus:253:15
[   13.277645] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[   13.355514] REISERFS (device md1): found reiserfs format "3.6" with standard journal
[   13.363967] REISERFS (device md1): using ordered data mode
[   13.383114] REISERFS (device md1): journal params: device md1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   13.401745] REISERFS (device md1): checking transaction log (md1)
[   13.457657] REISERFS (device md1): Using r5 hash to sort names
[   18.577606] PM: Adding info for No Bus:vcs2
[   18.577677] PM: Adding info for No Bus:vcsa2
[   18.577994] PM: Adding info for No Bus:vcs3
[   18.578829] PM: Adding info for No Bus:vcsa3
[   18.580027] PM: Adding info for No Bus:vcs4
[   18.580084] PM: Adding info for No Bus:vcsa4
[   18.580378] PM: Adding info for No Bus:vcs5
[   18.580433] PM: Adding info for No Bus:vcsa5
[   18.581438] PM: Adding info for No Bus:vcs6
[   18.581493] PM: Adding info for No Bus:vcsa6
[   18.581782] PM: Adding info for No Bus:vcs7
[   18.581831] PM: Adding info for No Bus:vcsa7
[   18.582882] PM: Adding info for No Bus:vcs8
[   18.582944] PM: Adding info for No Bus:vcsa8
[   18.583688] PM: Adding info for No Bus:vcs9
[   18.583740] PM: Adding info for No Bus:vcsa9
[   18.584433] PM: Adding info for No Bus:vcs10
[   18.584484] PM: Adding info for No Bus:vcsa10
[   18.585191] PM: Adding info for No Bus:vcs11
[   18.585247] PM: Adding info for No Bus:vcsa11
[   18.585954] PM: Adding info for No Bus:vcs12
[   18.586009] PM: Adding info for No Bus:vcsa12
[   20.152736] Adding 2097148k swap on /dev/sdc3.  Priority:-1 extents:1 across:2097148k 
[   20.812138] tg3 0000:02:00.0: irq 27 for MSI/MSI-X
[   20.860786] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   22.576684] tg3 0000:02:00.0: eth0: Link is up at 100 Mbps, full duplex
[   22.583819] tg3 0000:02:00.0: eth0: Flow control is off for TX and off for RX
[   22.585912] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
... (skipping stopping of all non-root md arrays)
[  115.131260] ohci_hcd 0000:00:13.4: remove, state 4
[  115.136444] usb usb6: USB disconnect, address 1
[  115.141332] PM: Removing info for No Bus:ep_81
[  115.141363] PM: Removing info for usb:6-0:1.0
[  115.141396] usb usb6: __pm_runtime_resume()!
[  115.141404] usb usb6: __pm_runtime_resume() returns -19!
[  115.141460] PM: Removing info for No Bus:ep_00
[  115.141494] PM: Removing info for usb:usb6
[  115.141625] ohci_hcd 0000:00:13.4: USB bus 6 deregistered
[  115.147468] ohci_hcd 0000:00:13.4: PCI INT C disabled
[  115.152931] ohci_hcd 0000:00:13.3: remove, state 4
[  115.158109] usb usb5: USB disconnect, address 1
[  115.162999] PM: Removing info for No Bus:ep_81
[  115.163021] PM: Removing info for usb:5-0:1.0
[  115.163047] usb usb5: __pm_runtime_resume()!
[  115.163053] usb usb5: __pm_runtime_resume() returns -19!
[  115.163090] PM: Removing info for No Bus:ep_00
[  115.163123] PM: Removing info for usb:usb5
[  115.163209] ohci_hcd 0000:00:13.3: USB bus 5 deregistered
[  115.169052] ohci_hcd 0000:00:13.3: PCI INT B disabled
[  115.174524] ohci_hcd 0000:00:13.2: remove, state 4
[  115.179689] usb usb4: USB disconnect, address 1
[  115.184572] PM: Removing info for No Bus:ep_81
[  115.184594] PM: Removing info for usb:4-0:1.0
[  115.184618] usb usb4: __pm_runtime_resume()!
[  115.184624] usb usb4: __pm_runtime_resume() returns -19!
[  115.184658] PM: Removing info for No Bus:ep_00
[  115.184689] PM: Removing info for usb:usb4
[  115.184771] ohci_hcd 0000:00:13.2: USB bus 4 deregistered
[  115.190607] ohci_hcd 0000:00:13.2: PCI INT C disabled
[  115.196057] ohci_hcd 0000:00:13.1: remove, state 4
[  115.201243] usb usb3: USB disconnect, address 1
[  115.206117] PM: Removing info for No Bus:ep_81
[  115.206139] PM: Removing info for usb:3-0:1.0
[  115.206162] usb usb3: __pm_runtime_resume()!
[  115.206167] usb usb3: __pm_runtime_resume() returns -19!
[  115.206202] PM: Removing info for No Bus:ep_00
[  115.206233] PM: Removing info for usb:usb3
[  115.206313] ohci_hcd 0000:00:13.1: USB bus 3 deregistered
[  115.212146] ohci_hcd 0000:00:13.1: PCI INT B disabled
[  115.217579] ohci_hcd 0000:00:13.0: remove, state 4
[  115.222735] usb usb2: USB disconnect, address 1
[  115.227621] PM: Removing info for No Bus:ep_81
[  115.227645] PM: Removing info for usb:2-0:1.0
[  115.227672] usb usb2: __pm_runtime_resume()!
[  115.227678] usb usb2: __pm_runtime_resume() returns -19!
[  115.227717] PM: Removing info for No Bus:ep_00
[  115.227750] PM: Removing info for usb:usb2
[  115.227842] ohci_hcd 0000:00:13.0: USB bus 2 deregistered
[  115.233667] ohci_hcd 0000:00:13.0: PCI INT A disabled
[  117.275558] ehci_hcd 0000:00:13.5: remove, state 4
[  117.280736] usb usb1: USB disconnect, address 1
[  117.285657] PM: Removing info for No Bus:ep_81
[  117.285693] PM: Removing info for usb:1-0:1.0
[  117.285725] usb usb1: __pm_runtime_resume()!
[  117.285733] usb usb1: __pm_runtime_resume() returns -19!
[  117.285794] PM: Removing info for No Bus:ep_00
[  117.285830] PM: Removing info for usb:usb1
[  117.285971] ehci_hcd 0000:00:13.5: USB bus 1 deregistered
[  117.291943] ehci_hcd 0000:00:13.5: PCI INT D disabled
[  123.803001] usbcore: deregistering device driver usb
[  123.808420] usbcore: deregistering interface driver usbfs
[  123.814595] usbcore: deregistering interface driver hub
[  392.061793] PM: Syncing filesystems ... done.
[  392.096243] PM: Preparing system for mem sleep
[  392.101205] PM: Adding info for No Bus:vcs63
[  392.101277] PM: Adding info for No Bus:vcsa63
[  392.116060] Freezing user space processes ... (elapsed 0.02 seconds) done.
[  392.145371] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  392.172209] PM: Entering mem sleep
[  392.172330] pci 0000:00:00.0: preparing suspend
[  392.172335] pci 0000:00:00.0: __pm_runtime_resume()!
[  392.172339] pci 0000:00:00.0: __pm_runtime_resume() returns -11!
[  392.172345] pci 0000:00:01.0: preparing suspend
[  392.172349] pci 0000:00:01.0: __pm_runtime_resume()!
[  392.172353] pci 0000:00:01.0: __pm_runtime_resume() returns -11!
[  392.172359] pcieport 0000:00:04.0: preparing suspend
[  392.172362] pcieport 0000:00:04.0: __pm_runtime_resume()!
[  392.172366] pcieport 0000:00:04.0: __pm_runtime_resume() returns -11!
[  392.172372] pcieport 0000:00:05.0: preparing suspend
[  392.172376] pcieport 0000:00:05.0: __pm_runtime_resume()!
[  392.172380] pcieport 0000:00:05.0: __pm_runtime_resume() returns -11!
[  392.172385] pcieport 0000:00:06.0: preparing suspend
[  392.172389] pcieport 0000:00:06.0: __pm_runtime_resume()!
[  392.172393] pcieport 0000:00:06.0: __pm_runtime_resume() returns -11!
[  392.172399] ahci 0000:00:12.0: preparing suspend
[  392.172402] ahci 0000:00:12.0: __pm_runtime_resume()!
[  392.172406] ahci 0000:00:12.0: __pm_runtime_resume() returns -11!
[  392.172412] pci 0000:00:13.0: preparing suspend
[  392.172415] pci 0000:00:13.0: __pm_runtime_resume()!
[  392.172419] pci 0000:00:13.0: __pm_runtime_resume() returns -11!
[  392.172425] pci 0000:00:13.1: preparing suspend
[  392.172429] pci 0000:00:13.1: __pm_runtime_resume()!
[  392.172432] pci 0000:00:13.1: __pm_runtime_resume() returns -11!
[  392.172438] pci 0000:00:13.2: preparing suspend
[  392.172441] pci 0000:00:13.2: __pm_runtime_resume()!
[  392.172445] pci 0000:00:13.2: __pm_runtime_resume() returns -11!
[  392.172450] pci 0000:00:13.3: preparing suspend
[  392.172454] pci 0000:00:13.3: __pm_runtime_resume()!
[  392.172458] pci 0000:00:13.3: __pm_runtime_resume() returns -11!
[  392.172463] pci 0000:00:13.4: preparing suspend
[  392.172467] pci 0000:00:13.4: __pm_runtime_resume()!
[  392.172470] pci 0000:00:13.4: __pm_runtime_resume() returns -11!
[  392.172476] pci 0000:00:13.5: preparing suspend
[  392.172479] pci 0000:00:13.5: __pm_runtime_resume()!
[  392.172483] pci 0000:00:13.5: __pm_runtime_resume() returns -11!
[  392.172488] pci 0000:00:14.0: preparing suspend
[  392.172492] pci 0000:00:14.0: __pm_runtime_resume()!
[  392.172496] pci 0000:00:14.0: __pm_runtime_resume() returns -11!
[  392.172512] pata_atiixp 0000:00:14.1: preparing suspend
[  392.172516] pata_atiixp 0000:00:14.1: __pm_runtime_resume()!
[  392.172520] pata_atiixp 0000:00:14.1: __pm_runtime_resume() returns -11!
[  392.172526] pci 0000:00:14.3: preparing suspend
[  392.172530] pci 0000:00:14.3: __pm_runtime_resume()!
[  392.172533] pci 0000:00:14.3: __pm_runtime_resume() returns -11!
[  392.172539] pci 0000:00:14.4: preparing suspend
[  392.172542] pci 0000:00:14.4: __pm_runtime_resume()!
[  392.172546] pci 0000:00:14.4: __pm_runtime_resume() returns -11!
[  392.172552] ATI IXP AC97 controller 0000:00:14.5: preparing suspend
[  392.172557] ATI IXP AC97 controller 0000:00:14.5: __pm_runtime_resume()!
[  392.172561] ATI IXP AC97 controller 0000:00:14.5: __pm_runtime_resume() returns -11!
[  392.172567] pci 0000:00:18.0: preparing suspend
[  392.172571] pci 0000:00:18.0: __pm_runtime_resume()!
[  392.172575] pci 0000:00:18.0: __pm_runtime_resume() returns -11!
[  392.172580] pci 0000:00:18.1: preparing suspend
[  392.172583] pci 0000:00:18.1: __pm_runtime_resume()!
[  392.172587] pci 0000:00:18.1: __pm_runtime_resume() returns -11!
[  392.172592] pci 0000:00:18.2: preparing suspend
[  392.172596] pci 0000:00:18.2: __pm_runtime_resume()!
[  392.172600] pci 0000:00:18.2: __pm_runtime_resume() returns -11!
[  392.172605] k8temp 0000:00:18.3: preparing suspend
[  392.172609] k8temp 0000:00:18.3: __pm_runtime_resume()!
[  392.172613] k8temp 0000:00:18.3: __pm_runtime_resume() returns -11!
[  392.172619] radeon 0000:01:05.0: preparing suspend
[  392.172623] radeon 0000:01:05.0: __pm_runtime_resume()!
[  392.172627] radeon 0000:01:05.0: __pm_runtime_resume() returns -11!
[  392.172634] tg3 0000:02:00.0: preparing suspend, may wakeup
[  392.172638] tg3 0000:02:00.0: __pm_runtime_resume()!
[  392.172642] tg3 0000:02:00.0: __pm_runtime_resume() returns -11!
[  392.172648] tg3 0000:03:00.0: preparing suspend, may wakeup
[  392.172652] tg3 0000:03:00.0: __pm_runtime_resume()!
[  392.172656] tg3 0000:03:00.0: __pm_runtime_resume() returns -11!
[  392.172700] platform pcspkr: preparing suspend
[  392.172705] platform microcode: preparing suspend
[  392.172813] serial8250 serial8250: preparing suspend
[  392.172847] i8042 i8042: preparing suspend
[  392.172862] it87 it87.3712: preparing suspend
[  392.172999] ac97 0-0:ALC655: legacy suspend
[  392.173088] it87 it87.3712: suspend
[  392.173094] input input2: type suspend
[  392.173100] rtc rtc0: legacy class suspend
[  392.173147] serio serio1: suspend
[  392.173153] atkbd serio0: suspend
[  392.173255] scsi host5: legacy suspend
[  392.173264] scsi host4: legacy suspend
[  392.173274] sd 2:0:0:0: legacy suspend
[  392.173284] sd 2:0:0:0: [sdc] Synchronizing SCSI cache
[  392.173379] sd 1:0:0:0: legacy suspend
[  392.173386] sd 1:0:0:0: [sdb] Synchronizing SCSI cache
[  392.173459] sd 2:0:0:0: [sdc] Stopping disk
[  392.173508] sd 0:0:0:0: legacy suspend
[  392.173514] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  392.173598] sd 1:0:0:0: [sdb] Stopping disk
[  392.173723] sd 0:0:0:0: [sda] Stopping disk
[  392.175834] i8042 i8042: suspend
[  392.176016] serial8250 serial8250: suspend
[  392.176550] drm card0-HDMI Type A-1: legacy class suspend
[  392.176556] i2c i2c-2: suspend
[  392.176562] drm card0-DVI-D-1: legacy class suspend
[  392.176568] i2c i2c-1: suspend
[  392.176573] drm card0-SVIDEO-1: legacy class suspend
[  392.176579] drm card0-VGA-1: legacy class suspend
[  392.176585] i2c i2c-0: suspend
[  392.176592] drm card0: legacy class suspend
[  392.176598] drm controlD64: legacy class suspend
[  392.176603] drm ttm: legacy class suspend
[  392.176689] input input1: type suspend
[  392.176696] input input0: type suspend
[  392.176712] platform microcode: suspend
[  392.176717] platform pcspkr: suspend
[  392.176738] system 00:11: legacy suspend
[  392.176753] system 00:10: legacy suspend
[  392.176757] ACPI handle has no context!
[  392.176763] system 00:0f: legacy suspend
[  392.176772] system 00:0e: legacy suspend
[  392.176781] system 00:0d: legacy suspend
[  392.176790] pnp 00:0c: legacy suspend
[  392.176796] pnp 00:0b: legacy suspend
[  392.176801] system 00:0a: legacy suspend
[  392.176811] pnp 00:09: legacy suspend
[  392.176816] pnp 00:08: legacy suspend
[  392.176821] pnp 00:07: legacy suspend
[  392.176826] pnp 00:06: legacy suspend
[  392.176831] i8042 aux 00:05: legacy suspend
[  392.176841] i8042 kbd 00:04: legacy suspend
[  392.176852] rtc_cmos 00:03: legacy suspend, may wakeup
[  392.176866] pnp 00:02: legacy suspend
[  392.176871] system 00:01: legacy suspend
[  392.176881] pnp 00:00: legacy suspend
[  392.177058] button LNXPWRBN:00: legacy suspend
[  392.177064] acpi LNXTHERM:00: legacy suspend
[  392.177070] pci_link PNP0C0F:07: legacy suspend
[  392.177075] pci_link PNP0C0F:06: legacy suspend
[  392.177081] pci_link PNP0C0F:05: legacy suspend
[  392.177086] pci_link PNP0C0F:04: legacy suspend
[  392.177091] pci_link PNP0C0F:03: legacy suspend
[  392.177096] pci_link PNP0C0F:02: legacy suspend
[  392.177102] pci_link PNP0C0F:01: legacy suspend
[  392.177107] pci_link PNP0C0F:00: legacy suspend
[  392.177113] button PNP0C0C:00: legacy suspend
[  392.177118] acpi PNP0C01:00: legacy suspend
[  392.177123] acpi device:24: legacy suspend
[  392.177129] acpi device:23: legacy suspend
[  392.177134] acpi device:22: legacy suspend
[  392.177139] acpi device:21: legacy suspend
[  392.177144] acpi device:20: legacy suspend
[  392.177150] acpi device:1f: legacy suspend
[  392.177156] acpi device:1e: legacy suspend
[  392.177161] acpi device:1d: legacy suspend
[  392.177166] acpi device:1c: legacy suspend
[  392.177171] acpi device:1b: legacy suspend
[  392.177177] acpi device:1a: legacy suspend
[  392.177182] acpi device:19: legacy suspend
[  392.177187] acpi device:18: legacy suspend
[  392.177192] acpi device:17: legacy suspend
[  392.177197] acpi device:16: legacy suspend
[  392.177202] acpi device:15: legacy suspend
[  392.177207] acpi device:14: legacy suspend
[  392.177212] acpi device:13: legacy suspend
[  392.177219] acpi device:12: legacy suspend
[  392.177224] acpi PNP0C02:05: legacy suspend
[  392.177229] acpi PNP0C02:04: legacy suspend
[  392.177234] acpi PNP0C02:03: legacy suspend
[  392.177239] acpi PNP0C02:02: legacy suspend
[  392.177245] acpi PNP0501:03: legacy suspend
[  392.177250] acpi PNP0501:02: legacy suspend
[  392.177255] acpi PNP0C02:01: legacy suspend
[  392.177260] acpi PNP0501:01: legacy suspend
[  392.177266] acpi PNP0501:00: legacy suspend
[  392.177271] acpi PNP0C04:00: legacy suspend
[  392.177276] acpi PNP0800:00: legacy suspend
[  392.177282] acpi PNP0F03:00: legacy suspend
[  392.177287] acpi PNP0303:00: legacy suspend
[  392.177292] acpi PNP0B00:00: legacy suspend
[  392.177298] acpi PNP0100:00: legacy suspend
[  392.177303] acpi PNP0200:00: legacy suspend
[  392.177308] acpi PNP0000:00: legacy suspend
[  392.177319] acpi device:11: legacy suspend
[  392.177324] acpi device:10: legacy suspend
[  392.177329] acpi device:0f: legacy suspend
[  392.177335] acpi device:0e: legacy suspend
[  392.177340] acpi device:0d: legacy suspend
[  392.177345] acpi device:0c: legacy suspend
[  392.177351] acpi device:0b: legacy suspend
[  392.177357] acpi device:0a: legacy suspend
[  392.177362] acpi device:09: legacy suspend
[  392.177367] acpi device:08: legacy suspend
[  392.177372] acpi device:07: legacy suspend
[  392.177377] acpi device:06: legacy suspend
[  392.177382] acpi device:05: legacy suspend
[  392.177388] acpi device:04: legacy suspend
[  392.177393] acpi device:03: legacy suspend
[  392.177398] acpi device:02: legacy suspend
[  392.177404] acpi device:01: legacy suspend
[  392.177409] acpi PNP0C02:00: legacy suspend
[  392.177415] acpi device:00: legacy suspend
[  392.177427] pci_root PNP0A03:00: legacy suspend
[  392.177437] acpi LNXSYBUS:00: legacy suspend
[  392.177442] processor LNXCPU:01: legacy suspend
[  392.177453] processor LNXCPU:00: legacy suspend
[  392.177460] acpi LNXSYSTM:00: legacy suspend
[  392.177484] scsi host3: legacy suspend
[  392.177507] tg3 0000:03:00.0: suspend, may wakeup
[  392.177614] tg3 0000:02:00.0: suspend, may wakeup
[  392.177720] radeon 0000:01:05.0: suspend
[  392.178788] radeon 0000:01:05.0: PCI INT A disabled
[  392.178840] k8temp 0000:00:18.3: suspend
[  392.178849] pci 0000:00:18.2: suspend
[  392.178855] pci 0000:00:18.1: suspend
[  392.178862] pci 0000:00:18.0: suspend
[  392.178870] ATI IXP AC97 controller 0000:00:14.5: suspend
[  392.179091] ATI IXP AC97 controller 0000:00:14.5: PCI INT B disabled
[  392.179177] pci 0000:00:14.4: suspend
[  392.179183] pci 0000:00:14.3: suspend
[  392.179190] pata_atiixp 0000:00:14.1: suspend
[  392.179195] pata_atiixp 0000:00:14.1: Suspending ATA host device ...
[  392.179307] pata_atiixp 0000:00:14.1: Saving PCI state ...
[  392.179372] pata_atiixp 0000:00:14.1: Disabling PCI device ...
[  392.179384] pata_atiixp 0000:00:14.1: PCI INT A disabled
[  392.179389] pata_atiixp 0000:00:14.1: Switching PCI device to D3hot...
[  392.179393] pata_atiixp 0000:00:14.1: Done suspending :)
[  392.179402] pci 0000:00:14.0: suspend
[  392.179408] pci 0000:00:13.5: suspend
[  392.179414] pci 0000:00:13.4: suspend
[  392.179420] pci 0000:00:13.3: suspend
[  392.179427] pci 0000:00:13.2: suspend
[  392.179433] pci 0000:00:13.1: suspend
[  392.179439] pci 0000:00:13.0: suspend
[  392.179453] pcieport 0000:00:06.0: suspend
[  392.179465] pcieport 0000:00:05.0: suspend
[  392.179540] pci 0000:00:00.0: suspend
[  393.109700] scsi target1:0:0: legacy suspend
[  393.109716] scsi host1: legacy suspend
[  393.114397] scsi target0:0:0: legacy suspend
[  393.114408] scsi host0: legacy suspend
[  393.183590] scsi target2:0:0: legacy suspend
[  393.183602] scsi host2: legacy suspend
[  393.183612] ahci 0000:00:12.0: suspend
[  393.183617] ahci 0000:00:12.0: Disabliing AHCI interrupts ...
[  393.183624] ahci 0000:00:12.0: Ready to stop ATA pic device ...
[  393.183628] ahci 0000:00:12.0: Suspending ATA host device ...
[  393.352544] pci 0000:00:01.0: suspend
[  393.361581] tg3 0000:02:00.0: PME# enabled
[  393.365942] pcieport 0000:00:04.0: wake-up capability enabled by ACPI
[  393.392564] pcieport 0000:00:04.0: suspend
[  393.410144] ahci 0000:00:12.0: Saving PCI state ...
[  393.415337] ahci 0000:00:12.0: Disabling PCI device ...
[  393.420862] ahci 0000:00:12.0: PCI INT A disabled
[  393.425781] ahci 0000:00:12.0: Switching PCI device to D3hot...
[  393.450019] ahci 0000:00:12.0: Done suspending :)
[  393.454985] PM: suspend of devices complete after 1282.018 msecs
[  393.461767] it87 it87.3712: LATE suspend
[  393.465935] input input2: LATE type suspend
[  393.470310] serio serio1: LATE suspend
[  393.474396] atkbd serio0: LATE suspend
[  393.478448] i8042 i8042: LATE suspend
[  393.482391] serial8250 serial8250: LATE suspend
[  393.487242] i2c i2c-2: LATE suspend
[  393.490992] i2c i2c-1: LATE suspend
[  393.494747] i2c i2c-0: LATE suspend
[  393.498523] input input1: LATE type suspend
[  393.503033] input input0: LATE type suspend
[  393.507556] platform microcode: LATE suspend
[  393.512176] platform pcspkr: LATE suspend
[  393.512192] tg3 0000:03:00.0: LATE suspend, may wakeup
[  393.512197] tg3 0000:02:00.0: LATE suspend, may wakeup
[  393.512202] radeon 0000:01:05.0: LATE suspend
[  393.512206] k8temp 0000:00:18.3: LATE suspend
[  393.512230] pci 0000:00:18.2: LATE suspend
[  393.512249] pci 0000:00:18.1: LATE suspend
[  393.512266] pci 0000:00:18.0: LATE suspend
[  393.512287] ATI IXP AC97 controller 0000:00:14.5: LATE suspend
[  393.512292] pci 0000:00:14.4: LATE suspend
[  393.512347] pci 0000:00:14.3: LATE suspend
[  393.512403] pata_atiixp 0000:00:14.1: LATE suspend
[  393.512407] pci 0000:00:14.0: LATE suspend
[  393.512901] pci 0000:00:13.5: LATE suspend
[  393.512977] pci 0000:00:13.4: LATE suspend
[  393.513033] pci 0000:00:13.3: LATE suspend
[  393.513088] pci 0000:00:13.2: LATE suspend
[  393.513143] pci 0000:00:13.1: LATE suspend
[  393.513199] pci 0000:00:13.0: LATE suspend
[  393.513255] ahci 0000:00:12.0: LATE suspend
[  393.513259] pcieport 0000:00:06.0: LATE suspend
[  393.513264] pcieport 0000:00:05.0: LATE suspend
[  393.513268] pcieport 0000:00:04.0: LATE suspend
[  393.513272] pci 0000:00:01.0: LATE suspend
[  393.513309] pci 0000:00:00.0: LATE suspend
[  393.513360] PM: late suspend of devices complete after 52.054 msecs
[  393.513583] ACPI: Preparing to enter system sleep state S3
[  393.515037] Disabling non-boot CPUs ...
[  393.780021] CPU 1 is now offline
[  393.783508] SMP alternatives: switching to UP code
[  393.797930] Back to C!
[  393.797930] Enabling non-boot CPUs ...
[  394.806567] SMP alternatives: switching to SMP code
[  396.444828] Booting Node 0 Processor 1 APIC 0x1
[  398.180201] microcode: microcode: CPU1: AMD CPU family 0xf not supported
[  400.417207] CPU1 is up
[  401.220377] ACPI: Waking up from system sleep state S3
[  402.916060] pci 0000:00:00.0: EARLY resume
[  404.292721] pci 0000:00:01.0: EARLY resume
[  405.669673] pcieport 0000:00:04.0: EARLY resume
[  407.175654] pcieport 0000:00:04.0: restoring config space at offset 0x7 (was 0x1f1, writing 0x200001f1)
[  410.294344] pcieport 0000:00:04.0: restoring config space at offset 0x1 (was 0x100106, writing 0x100506)
[  413.447330] pcieport 0000:00:05.0: EARLY resume
[  414.955424] pcieport 0000:00:05.0: restoring config space at offset 0x7 (was 0x1f1, writing 0x200001f1)
[  418.071559] pcieport 0000:00:05.0: restoring config space at offset 0x1 (was 0x100106, writing 0x100506)
[  421.225744] pcieport 0000:00:06.0: EARLY resume
[  422.735469] pcieport 0000:00:06.0: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
[  425.880392] ahci 0000:00:12.0: EARLY resume
[  427.284910] ahci 0000:00:12.0: restoring config space at offset 0xf (was 0x100, writing 0x105)
[  430.142837] pci 0000:00:13.0: EARLY resume
[  431.518701] pci 0000:00:13.1: EARLY resume
[  432.895671] pci 0000:00:13.2: EARLY resume
[  434.261798] pci 0000:00:13.3: EARLY resume
[  435.638096] pci 0000:00:13.4: EARLY resume
[  437.015031] pci 0000:00:13.5: EARLY resume
[  438.380192] pci 0000:00:14.0: EARLY resume
[  439.758088] pata_atiixp 0000:00:14.1: EARLY resume
[  441.364845] pata_atiixp 0000:00:14.1: restoring config space at offset 0x3 (was 0x0, writing 0x4000)
[  444.391747] pci 0000:00:14.3: EARLY resume
[  445.759667] pci 0000:00:14.4: EARLY resume
[  447.135667] ATI IXP AC97 controller 0000:00:14.5: EARLY resume
[  449.084912] ATI IXP AC97 controller 0000:00:14.5: restoring config space at offset 0x1 (was 0x4300117, writing 0x4300113)
[  452.717979] pci 0000:00:18.0: EARLY resume
[  454.083442] pci 0000:00:18.1: EARLY resume
[  455.459439] pci 0000:00:18.2: EARLY resume
[  456.836671] k8temp 0000:00:18.3: EARLY resume
[  458.288803] radeon 0000:01:05.0: EARLY resume
[  459.750800] radeon 0000:01:05.0: restoring config space at offset 0xf (was 0x1ff, writing 0x10a)
[  462.666887] radeon 0000:01:05.0: restoring config space at offset 0x3 (was 0x0, writing 0x4010)
[  465.549184] tg3 0000:02:00.0: EARLY resume
[  466.928911] tg3 0000:02:00.0: restoring config space at offset 0xc (was 0x0, writing 0xc2900000)
[  469.844947] tg3 0000:02:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
[  472.596911] tg3 0000:02:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100506)
[  475.596158] tg3 0000:03:00.0: EARLY resume
[  476.973255] tg3 0000:03:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
[  479.717983] tg3 0000:03:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100106)
[  482.716159] platform pcspkr: EARLY resume
[  484.065147] platform microcode: EARLY resume
[  485.489242] input input0: EARLY type resume
[  486.894204] input input1: EARLY type resume
[  488.298870] i2c i2c-0: EARLY resume
[  489.464220] i2c i2c-1: EARLY resume
[  490.640598] i2c i2c-2: EARLY resume
[  491.815937] serial8250 serial8250: EARLY resume
[  493.326121] i8042 i8042: EARLY resume
[  494.558779] atkbd serio0: EARLY resume
[  495.820671] serio serio1: EARLY resume
[  497.082508] input input2: EARLY type resume
[  498.477492] it87 it87.3712: EARLY resume
[  499.796382] PM: early resume of devices complete after 96880.327 msecs
[  501.966153] acpi LNXSYSTM:00: legacy resume
[  501.966223] pci 0000:00:00.0: resume
[  501.966236] pci 0000:00:01.0: resume
[  501.966260] pcieport 0000:00:04.0: resume
[  501.966272] pcieport 0000:00:05.0: resume
[  501.966281] pcieport 0000:00:06.0: resume
[  501.966291] ahci 0000:00:12.0: resume
[  501.966319] ahci 0000:00:12.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[  501.966531] pci 0000:00:13.0: resume
[  501.966537] pci 0000:00:13.1: resume
[  501.966543] pci 0000:00:13.2: resume
[  501.966549] pci 0000:00:13.3: resume
[  501.966555] pci 0000:00:13.4: resume
[  501.966561] pci 0000:00:13.5: resume
[  501.966567] pci 0000:00:14.0: resume
[  501.966573] pata_atiixp 0000:00:14.1: resume
[  501.966593] pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  501.966625] pci 0000:00:14.3: resume
[  501.966631] pci 0000:00:14.4: resume
[  501.966658] ATI IXP AC97 controller 0000:00:14.5: resume
[  501.966672] ATI IXP AC97 controller 0000:00:14.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[  501.968999] atiixp: codec reset timeout
[  501.974652] pci 0000:00:18.0: resume
[  501.974658] pci 0000:00:18.1: resume
[  501.974664] pci 0000:00:18.2: resume
[  501.974671] k8temp 0000:00:18.3: resume
[  501.974679] radeon 0000:01:05.0: resume
[  501.976036] tg3 0000:02:00.0: resume
[  501.976036] pcieport 0000:00:04.0: wake-up capability disabled by ACPI
[  501.976036] tg3 0000:02:00.0: PME# disabled
[  501.976036] tg3 0000:02:00.0: eth0: Link is down
[  501.998717] tg3 0000:03:00.0: resume
[  501.998726] scsi host0: legacy resume
[  501.998735] scsi host1: legacy resume
[  501.998742] scsi host2: legacy resume
[  501.998750] scsi host3: legacy resume
[  501.998758] scsi target0:0:0: legacy resume
[  501.998764] sd 0:0:0:0: legacy resume
[  501.998772] sd 0:0:0:0: [sda] Starting disk
[  501.998913] scsi target1:0:0: legacy resume
[  501.998920] sd 1:0:0:0: legacy resume
[  501.998925] sd 1:0:0:0: [sdb] Starting disk
[  501.998992] scsi target2:0:0: legacy resume
[  501.998999] sd 2:0:0:0: legacy resume
[  501.999004] sd 2:0:0:0: [sdc] Starting disk
[  501.999077] scsi host4: legacy resume
[  501.999087] scsi host5: legacy resume
[  567.025198] radeon 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  567.026067] tg3 0000:02:00.0: eth0: Link is up at 100 Mbps, full duplex
[  567.026069] tg3 0000:02:00.0: eth0: Flow control is off for TX and off for RX
[  567.026074] processor LNXCPU:00: legacy resume
[  567.026078] processor LNXCPU:01: legacy resume
[  567.026080] acpi LNXSYBUS:00: legacy resume
[  567.026083] pci_root PNP0A03:00: legacy resume
[  567.026085] acpi device:00: legacy resume
[  567.026087] acpi PNP0C02:00: legacy resume
[  567.026089] acpi device:01: legacy resume
[  567.026091] acpi device:02: legacy resume
[  567.026093] acpi device:03: legacy resume
[  567.026096] acpi device:04: legacy resume
[  567.026098] acpi device:05: legacy resume
[  567.026100] acpi device:06: legacy resume
[  567.026102] acpi device:07: legacy resume
[  567.026104] acpi device:08: legacy resume
[  567.026106] acpi device:09: legacy resume
[  567.026108] acpi device:0a: legacy resume
[  567.026110] acpi device:0b: legacy resume
[  567.026112] acpi device:0c: legacy resume
[  567.026114] acpi device:0d: legacy resume
[  567.026116] acpi device:0e: legacy resume
[  567.026118] acpi device:0f: legacy resume
[  567.026121] acpi device:10: legacy resume
[  567.026123] acpi device:11: legacy resume
[  567.026125] acpi PNP0000:00: legacy resume
[  567.026127] acpi PNP0200:00: legacy resume
[  567.026129] acpi PNP0100:00: legacy resume
[  567.026131] acpi PNP0B00:00: legacy resume
[  567.026133] acpi PNP0303:00: legacy resume
[  567.026136] acpi PNP0F03:00: legacy resume
[  567.026138] acpi PNP0800:00: legacy resume
[  567.026140] acpi PNP0C04:00: legacy resume
[  567.026142] acpi PNP0501:00: legacy resume
[  567.026144] acpi PNP0501:01: legacy resume
[  567.026146] acpi PNP0C02:01: legacy resume
[  567.026148] acpi PNP0501:02: legacy resume
[  567.026150] acpi PNP0501:03: legacy resume
[  567.026152] acpi PNP0C02:02: legacy resume
[  567.026154] acpi PNP0C02:03: legacy resume
[  567.026156] acpi PNP0C02:04: legacy resume
[  567.026158] acpi PNP0C02:05: legacy resume
[  567.026161] acpi device:12: legacy resume
[  567.026163] acpi device:13: legacy resume
[  567.026165] acpi device:14: legacy resume
[  567.026167] acpi device:15: legacy resume
[  567.026169] acpi device:16: legacy resume
[  567.026171] acpi device:17: legacy resume
[  567.026173] acpi device:18: legacy resume
[  567.026175] acpi device:19: legacy resume
[  567.026177] acpi device:1a: legacy resume
[  567.026179] acpi device:1b: legacy resume
[  567.026182] acpi device:1c: legacy resume
[  567.026184] acpi device:1d: legacy resume
[  567.026186] acpi device:1e: legacy resume
[  567.026188] acpi device:1f: legacy resume
[  567.026190] acpi device:20: legacy resume
[  567.026192] acpi device:21: legacy resume
[  567.026194] acpi device:22: legacy resume
[  567.026196] acpi device:23: legacy resume
[  567.026198] acpi device:24: legacy resume
[  567.026200] acpi PNP0C01:00: legacy resume
[  567.026203] button PNP0C0C:00: legacy resume
[  567.026205] pci_link PNP0C0F:00: legacy resume
[  567.026208] pci_link PNP0C0F:01: legacy resume
[  567.026210] pci_link PNP0C0F:02: legacy resume
[  567.026212] pci_link PNP0C0F:03: legacy resume
[  567.026214] pci_link PNP0C0F:04: legacy resume
[  567.026216] pci_link PNP0C0F:05: legacy resume
[  567.026218] pci_link PNP0C0F:06: legacy resume
[  567.026221] pci_link PNP0C0F:07: legacy resume
[  567.026223] acpi LNXTHERM:00: legacy resume
[  567.026225] button LNXPWRBN:00: legacy resume
[  567.026236] pnp 00:00: legacy resume
[  567.026239] system 00:01: legacy resume
[  567.026242] pnp 00:02: legacy resume
[  567.026245] rtc_cmos 00:03: legacy resume
[  567.026248] i8042 kbd 00:04: legacy resume
[  567.026251] i8042 aux 00:05: legacy resume
[  567.026254] pnp 00:06: legacy resume
[  567.026256] pnp 00:07: legacy resume
[  567.026258] pnp 00:08: legacy resume
[  567.026260] pnp 00:09: legacy resume
[  567.026262] system 00:0a: legacy resume
[  567.026265] pnp 00:0b: legacy resume
[  567.026267] pnp 00:0c: legacy resume
[  567.026269] system 00:0d: legacy resume
[  567.026272] system 00:0e: legacy resume
[  567.026274] system 00:0f: legacy resume
[  567.026277] system 00:10: legacy resume
[  567.026279] system 00:11: legacy resume
[  567.026288] platform pcspkr: resume
[  567.026290] platform microcode: resume
[  567.026296] input input0: type resume
[  567.026298] input input1: type resume
[  567.026329] drm ttm: legacy class resume
[  567.111183] [drm] radeon: 1 quad pipes, 1 z pipes initialized.
[  567.130185] [drm] radeon: ring at 0x0000000080000000
[  567.130208] [drm] ring test succeeded in 0 usecs
[  567.130231] [drm] ib test succeeded in 0 usecs
[  719.270266] drm controlD64: legacy class resume
[  720.806491] drm card0: legacy class resume
[  720.812225] ata4: SATA link down (SStatus 0 SControl 300)
[  720.812285] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  720.812342] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  720.812395] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  730.432402] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[  730.432677] i2c i2c-0: resume
[  730.432684] drm card0-VGA-1: legacy class resume
[  730.432690] drm card0-SVIDEO-1: legacy class resume
[  730.432695] i2c i2c-1: resume
[  730.432700] drm card0-DVI-D-1: legacy class resume
[  730.432706] i2c i2c-2: resume
[  730.432710] drm card0-HDMI Type A-1: legacy class resume
[  730.432719] serial8250 serial8250: resume
[  732.520722] ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
[  732.520753] ata2.00: SB600 AHCI: limiting to 255 sectors per cmd
[  732.521715] ata2.00: SB600 AHCI: limiting to 255 sectors per cmd
[  732.521717] ata2.00: configured for UDMA/100
[  732.521747] ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
[  732.521749] ata3.00: configured for UDMA/100
[  732.591260] i8042 i8042: resume
[  732.591304] atkbd serio0: resume
[  732.591309] serio serio1: resume
[  732.591314] rtc rtc0: legacy class resume
[  732.591348] input input2: type resume
[  732.591353] it87 it87.3712: resume
[  732.615682] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[  732.622609] ata1.00: configured for UDMA/100
[  732.965545] ac97 0-0:ALC655: legacy resume
[  732.970471] PM: resume of devices complete after 231004.446 msecs
[  732.977735] it87 it87.3712: completing resume
[  732.982914] i8042 i8042: completing resume
[  732.987804] serial8250 serial8250: completing resume
[  732.993749] platform microcode: completing resume
[  732.999331] platform pcspkr: completing resume
[  733.004648] tg3 0000:03:00.0: completing resume
[  733.010039] tg3 0000:02:00.0: completing resume
[  733.015438] radeon 0000:01:05.0: completing resume
[  733.021154] k8temp 0000:00:18.3: completing resume
[  733.026829] pci 0000:00:18.2: completing resume
[  733.032224] pci 0000:00:18.1: completing resume
[  733.037582] pci 0000:00:18.0: completing resume
[  733.042967] ATI IXP AC97 controller 0000:00:14.5: completing resume
[  733.050387] pci 0000:00:14.4: completing resume
[  733.055718] pci 0000:00:14.3: completing resume
[  733.061128] pata_atiixp 0000:00:14.1: completing resume
[  733.067326] pci 0000:00:14.0: completing resume
[  733.072712] pci 0000:00:13.5: completing resume
[  733.078085] pci 0000:00:13.4: completing resume
[  733.083470] pci 0000:00:13.3: completing resume
[  733.088869] pci 0000:00:13.2: completing resume
[  733.094271] pci 0000:00:13.1: completing resume
[  733.099662] pci 0000:00:13.0: completing resume
[  733.105038] ahci 0000:00:12.0: completing resume
[  733.110536] pcieport 0000:00:06.0: completing resume
[  733.116453] pcieport 0000:00:05.0: completing resume
[  733.122374] pcieport 0000:00:04.0: completing resume
[  733.128259] pci 0000:00:01.0: completing resume
[  733.133660] pci 0000:00:00.0: completing resume
[  733.139163] PM: Finishing wakeup.
[  733.143100] Restarting tasks ... done.
