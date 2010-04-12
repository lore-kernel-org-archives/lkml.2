Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab0DLSyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 14:54:21 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:49452 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab0DLSyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 14:54:17 -0400
Date: Mon, 12 Apr 2010 11:54:16 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Yinghai <yinghai.lu@oracle.com>
Cc: guenter.roeck@ericsson.com, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH] x86: Reserve legacy VGA MMIO area for x86_64 as well
	as x86_32
Message-ID: <20100412185416.GA19959@hexapodia.org>
References: <20100409222103.GA11130@hexapodia.org> <4BBFA9BF.60608@oracle.com> <20100409223532.GC11130@hexapodia.org> <4BBFB1D8.6090802@oracle.com> <20100410000030.GE11130@hexapodia.org> <4BBFD019.9040405@oracle.com> <20100410014308.GG11130@hexapodia.org> <4BBFD8EF.6020108@oracle.com> <20100410015711.GH11130@hexapodia.org> <4BBFE66C.2040603@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4BBFE66C.2040603@oracle.com>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 09, 2010 at 07:46:04PM -0700, Yinghai wrote:
> please use this one replace second patch
> [PATCH] x86,pci, acpi: Inherent BUSY flag when setup_resource for root bus
> 
> So make pci root resource from _CRS honor the range We reserve in e820 below 1M
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/pci/acpi.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> Index: linux-2.6/arch/x86/pci/acpi.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/pci/acpi.c
> +++ linux-2.6/arch/x86/pci/acpi.c
> @@ -175,6 +175,10 @@ setup_resource(struct acpi_resource *acp
>  			"conflicts with %s %pR\n",
>  			res, conflict->name, conflict);
>  	} else {
> +		/* In case it falls in big reserved region */
> +		if (res->parent->flags & IORESOURCE_BUSY)
> +			res->flags |= IORESOURCE_BUSY;
> +
>  		pci_bus_add_resource(info->bus, res, 0);

That doesn't work:

[    0.000000] Linux version 2.6.34-rc3-00412-gef61642 (andy@farthing) (gcc version 4.3.3 (Debian 4.3.3-5) ) #13 SMP Mon Apr 12 11:12:43 PDT 2010
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-2.6.34-rc3-00412-gef61642 root=UUID=a2359eda-9295-451c-924f-c181c6f49d0d ro console=tty0 console=ttyS0,115200
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bfe01c00 (usable)
[    0.000000]  BIOS-e820: 00000000bfe01c00 - 00000000bfe53c00 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bfe53c00 - 00000000bfe55c00 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bfe55c00 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000feda0000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 00000001bc000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.5 present.
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x1bc000 max_arch_pfn = 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xbfe01 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000fe710] fe710
[    0.000000] init_memory_mapping: 0000000000000000-00000000bfe01000
[    0.000000] init_memory_mapping: 0000000100000000-00000001bc000000
[    0.000000] RAMDISK: 37c8e000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000febf0 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000000fcea4 0006C (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: FACP 00000000000fcfcc 000F4 (v03 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: DSDT 00000000fff5aafd 03794 (v01   DELL    dt_ex 00001000 INTL 20050624)
[    0.000000] ACPI: FACS 00000000bfe01c00 00040
[    0.000000] ACPI: SSDT 00000000fff5e291 00099 (v01   DELL    st_ex 00001000 INTL 20050624)
[    0.000000] ACPI: APIC 00000000000fd0c0 00092 (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: BOOT 00000000000fd152 00028 (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: ASF! 00000000000fd17a 00096 (v32 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: MCFG 00000000000fd210 0003E (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: HPET 00000000000fd24e 00038 (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: TCPA 00000000000fd4aa 00032 (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: SLIC 00000000000fd286 00176 (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-00000001bc000000
[    0.000000] Initmem setup node 0 0000000000000000-00000001bc000000
[    0.000000]   NODE_DATA [0000000100000000 - 0000000100004fff]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000001 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x001bc000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000001 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000bfe01
[    0.000000]     0: 0x00100000 -> 0x001bc000
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x01] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high level lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bfe01000 - 00000000bfe02000
[    0.000000] PM: Registered nosave memory: 00000000bfe02000 - 00000000bfe53000
[    0.000000] PM: Registered nosave memory: 00000000bfe53000 - 00000000bfe54000
[    0.000000] PM: Registered nosave memory: 00000000bfe54000 - 00000000bfe55000
[    0.000000] PM: Registered nosave memory: 00000000bfe55000 - 00000000bfe56000
[    0.000000] PM: Registered nosave memory: 00000000bfe56000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000feda0000
[    0.000000] PM: Registered nosave memory: 00000000feda0000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fef00000
[    0.000000] PM: Registered nosave memory: 00000000fef00000 - 00000000ffb00000
[    0.000000] PM: Registered nosave memory: 00000000ffb00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:20000000)
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880001e00000 s81896 r8192 d20504 u262144
[    0.000000] pcpu-alloc: s81896 r8192 d20504 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1531006
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-2.6.34-rc3-00412-gef61642 root=UUID=a2359eda-9295-451c-924f-c181c6f49d0d ro console=tty0 console=ttyS0,115200
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Subtract (62 early reservations)
[    0.000000]   #1 [0001000000 - 0001db1168]   TEXT DATA BSS
[    0.000000]   #2 [0037c8e000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [0001db2000 - 0001db21a8]             BRK
[    0.000000]   #4 [00000fe720 - 0000100000]   BIOS reserved
[    0.000000]   #5 [00000fe710 - 00000fe720]    MP-table mpf
[    0.000000]   #6 [000009ec00 - 00000f0000]   BIOS reserved
[    0.000000]   #7 [00000f0304 - 00000fe710]   BIOS reserved
[    0.000000]   #8 [00000f0000 - 00000f0304]    MP-table mpc
[    0.000000]   #9 [0000001000 - 0000003000]      TRAMPOLINE
[    0.000000]   #10 [0000003000 - 0000007000]     ACPI WAKEUP
[    0.000000]   #11 [0000008000 - 000000b000]         PGTABLE
[    0.000000]   #12 [000000b000 - 000000e000]         PGTABLE
[    0.000000]   #13 [0100000000 - 0100005000]       NODE_DATA
[    0.000000]   #14 [0001db21c0 - 0001db31c0]         BOOTMEM
[    0.000000]   #15 [0001db1180 - 0001db1600]         BOOTMEM
[    0.000000]   #16 [0100005000 - 0100006000]         BOOTMEM
[    0.000000]   #17 [0100006000 - 0100007000]         BOOTMEM
[    0.000000]   #18 [0100200000 - 0105600000]        MEMMAP 0
[    0.000000]   #19 [0001db1600 - 0001db1780]         BOOTMEM
[    0.000000]   #20 [0001db31c0 - 0001dcb1c0]         BOOTMEM
[    0.000000]   #21 [0001dcb1c0 - 0001de31c0]         BOOTMEM
[    0.000000]   #22 [0001de4000 - 0001de5000]         BOOTMEM
[    0.000000]   #23 [0001db1780 - 0001db17c1]         BOOTMEM
[    0.000000]   #24 [0001db1800 - 0001db1843]         BOOTMEM
[    0.000000]   #25 [0001db1880 - 0001db1b58]         BOOTMEM
[    0.000000]   #26 [0001db1b80 - 0001db1be8]         BOOTMEM
[    0.000000]   #27 [0001db1c00 - 0001db1c68]         BOOTMEM
[    0.000000]   #28 [0001db1c80 - 0001db1ce8]         BOOTMEM
[    0.000000]   #29 [0001db1d00 - 0001db1d68]         BOOTMEM
[    0.000000]   #30 [0001db1d80 - 0001db1de8]         BOOTMEM
[    0.000000]   #31 [0001db1e00 - 0001db1e68]         BOOTMEM
[    0.000000]   #32 [0001db1e80 - 0001db1ee8]         BOOTMEM
[    0.000000]   #33 [0001db1f00 - 0001db1f68]         BOOTMEM
[    0.000000]   #34 [0001db1f80 - 0001db1fe8]         BOOTMEM
[    0.000000]   #35 [0001de31c0 - 0001de3228]         BOOTMEM
[    0.000000]   #36 [0001de3240 - 0001de32a8]         BOOTMEM
[    0.000000]   #37 [0001de32c0 - 0001de3328]         BOOTMEM
[    0.000000]   #38 [0001de3340 - 0001de3360]         BOOTMEM
[    0.000000]   #39 [0001de3380 - 0001de33a0]         BOOTMEM
[    0.000000]   #40 [0001de33c0 - 0001de3442]         BOOTMEM
[    0.000000]   #41 [0001de3480 - 0001de3502]         BOOTMEM
[    0.000000]   #42 [0001e00000 - 0001e1b000]         BOOTMEM
[    0.000000]   #43 [0001e40000 - 0001e5b000]         BOOTMEM
[    0.000000]   #44 [0001e80000 - 0001e9b000]         BOOTMEM
[    0.000000]   #45 [0001ec0000 - 0001edb000]         BOOTMEM
[    0.000000]   #46 [0001f00000 - 0001f1b000]         BOOTMEM
[    0.000000]   #47 [0001f40000 - 0001f5b000]         BOOTMEM
[    0.000000]   #48 [0001f80000 - 0001f9b000]         BOOTMEM
[    0.000000]   #49 [0001fc0000 - 0001fdb000]         BOOTMEM
[    0.000000]   #50 [0001de3540 - 0001de3548]         BOOTMEM
[    0.000000]   #51 [0001de3580 - 0001de3588]         BOOTMEM
[    0.000000]   #52 [0001de35c0 - 0001de35e0]         BOOTMEM
[    0.000000]   #53 [0001de3600 - 0001de3640]         BOOTMEM
[    0.000000]   #54 [0001de3640 - 0001de3760]         BOOTMEM
[    0.000000]   #55 [0001de3780 - 0001de37c8]         BOOTMEM
[    0.000000]   #56 [0001de3800 - 0001de3848]         BOOTMEM
[    0.000000]   #57 [0001de5000 - 0001ded000]         BOOTMEM
[    0.000000]   #58 [0001fdb000 - 0005fdb000]         BOOTMEM
[    0.000000]   #59 [0001e1b000 - 0001e3b000]         BOOTMEM
[    0.000000]   #60 [0005fdb000 - 000601b000]         BOOTMEM
[    0.000000]   #61 [000000f000 - 0000017000]         BOOTMEM
[    0.000000] Memory: 6052848k/7274496k available (5380k kernel code, 1051016k absent, 170632k reserved, 6497k data, 612k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:2304
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2393.926 MHz processor.
[    0.002006] Calibrating delay loop (skipped), value calculated using timer frequency.. 4787.85 BogoMIPS (lpj=2393926)
[    0.004021] Security Framework initialized
[    0.005004] SELinux:  Initializing.
[    0.007340] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.013595] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.017347] Mount-cache hash table entries: 256
[    0.018186] Initializing cgroup subsys ns
[    0.019007] Initializing cgroup subsys cpuacct
[    0.020005] Initializing cgroup subsys blkio
[    0.021032] CPU: Physical Processor ID: 0
[    0.022002] CPU: Processor Core ID: 0
[    0.023003] using mwait in idle threads.
[    0.024002] Performance Events: Core2 events, Intel PMU driver.
[    0.027003] ... version:                2
[    0.028002] ... bit width:              40
[    0.029002] ... generic registers:      2
[    0.030002] ... value mask:             000000ffffffffff
[    0.031002] ... max period:             000000007fffffff
[    0.032002] ... fixed-purpose events:   3
[    0.033002] ... event mask:             0000000700000003
[    0.034039] ACPI: Core revision 20100121
[    0.201613] Setting APIC routing to flat
[    0.203194] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.214375] CPU0: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
[    0.217999] Booting Node   0, Processors  #1 #2 #3
[    0.434006] Brought up 4 CPUs
[    0.435002] Total of 4 processors activated (19151.15 BogoMIPS).
[    0.437105] khelper used greatest stack depth: 6008 bytes left
[    0.444410] Time: 18:31:15  Date: 04/12/10
[    0.445034] NET: Registered protocol family 16
[    0.446035] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.447007] ACPI: bus type pci registered
[    0.448043] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.449002] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.471880] PCI: Using configuration type 1 for base access
[    0.484044] bio: create slab <bio-0> at 0
[    0.517496] ACPI: BIOS _OSI(Linux) query ignored
[    0.564286] ACPI: Interpreter enabled
[    0.568002] ACPI: (supports S0 S1 S3 S4 S5)
[    0.572787] ACPI: Using IOAPIC for interrupt routing
[    0.768235] ACPI Warning: Incorrect checksum in table [TCPA] - 00, should be 87 (20100121/tbutils-314)
[    0.778105] ACPI: No dock devices found.
[    0.782003] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.802383] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.828187] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.834002] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.841002] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.849001] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000effff]
[    0.856002] pci_root PNP0A03:00: host bridge window [mem 0x000f0000-0x000fffff]
[    0.864002] pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfebfffff]
[    0.871002] pci_root PNP0A03:00: host bridge window [mem 0xbff00000-0xdfffffff]
[    0.878002] pci_root PNP0A03:00: host bridge window [mem 0xff980800-0xff980bff]
[    0.886001] pci_root PNP0A03:00: host bridge window [mem 0xff97c000-0xff97ffff]
[    0.893001] pci_root PNP0A03:00: host bridge window [mem 0xfed20000-0xfed9ffff]
[    0.901888] pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
[    0.910003] pci 0000:00:1f.0: quirk: [io  0x0880-0x08bf] claimed by ICH6 GPIO
[    0.917003] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0c00 (mask 007f)
[    0.925003] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 00e0 (mask 0007)
[    0.933265] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.938034] pci 0000:00:06.0: PCI bridge to [bus 02-02]
[    0.944052] pci 0000:00:1c.0: PCI bridge to [bus 03-03]
[    0.949184] pci 0000:00:1c.5: PCI bridge to [bus 04-04]
[    0.954146] pci 0000:00:1e.0: PCI bridge to [bus 05-05] (subtractive decode)
[    2.992616] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 15)
[    3.000443] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 15)
[    3.009073] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 9 10 11 12 15)
[    3.017695] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
[    3.027703] ACPI: PCI Interrupt Link [LNKE] (IRQs *3 4 5 6 7 9 10 11 12 15)
[    3.036307] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
[    3.045337] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 12 15)
[    3.053793] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 9 10 11 12 15)
[    3.062035] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    3.071003] vgaarb: loaded
[    3.074034] SCSI subsystem initialized
[    3.078023] usbcore: registered new interface driver usbfs
[    3.084007] usbcore: registered new interface driver hub
[    3.089020] usbcore: registered new device driver usb
[    3.094025] Advanced Linux Sound Architecture Driver Version 1.0.22.1.
[    3.101002] PCI: Using ACPI for IRQ routing
[    3.105037] pci 0000:00:1f.2: no compatible bridge window for [mem 0xff970000-0xff9707ff]
[    3.114047] Expanded resource reserved due to conflict with PCI Bus 0000:00
[    3.121071] cfg80211: Calling CRDA to update world regulatory domain
[    3.127017] NetLabel: Initializing
[    3.131001] NetLabel:  domain hash size = 128
[    3.135001] NetLabel:  protocols = UNLABELED CIPSOv4
[    3.140011] NetLabel:  unlabeled traffic allowed by default
[    3.146004] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    3.153004] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    3.158393] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    3.168022] Switching to clocksource tsc
[    3.181767] pnp: PnP ACPI init
[    3.185027] ACPI: bus type pnp registered
[    3.206083] pnp 00:01: disabling [io  0x0800-0x085f] because it overlaps 0000:00:1f.0 BAR 7 [io  0x0800-0x087f]
[    3.216482] pnp 00:01: disabling [io  0x0860-0x08ff] because it overlaps 0000:00:1f.0 BAR 7 [io  0x0800-0x087f]
[    3.291583] pnp: PnP ACPI: found 12 devices
[    3.295946] ACPI: ACPI bus type pnp unregistered
[    3.300748] system 00:01: [io  0x0c00-0x0c7f] has been reserved
[    3.312250] pci 0000:00:1c.0: BAR 9: assigned [mem 0xf0000000-0xf01fffff 64bit pref]
[    3.320319] pci 0000:00:1c.5: BAR 9: assigned [mem 0xf0200000-0xf03fffff 64bit pref]
[    3.328379] pci 0000:00:1c.0: BAR 7: assigned [io  0x1000-0x1fff]
[    3.334645] pci 0000:00:1c.5: BAR 7: assigned [io  0x2000-0x2fff]
[    3.340912] pci 0000:00:1f.2: BAR 5: assigned [mem 0x000a0000-0x000a07ff]
[    3.347874] pci 0000:00:1f.2: BAR 5: set to [mem 0x000a0000-0x000a07ff] (PCI address [0xa0000-0xa07ff]
[    3.357490] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    3.362891] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    3.369169] pci 0000:00:01.0:   bridge window [mem 0xfa000000-0xfdefffff]
[    3.376141] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    3.384208] pci 0000:00:06.0: PCI bridge to [bus 02-02]
[    3.389608] pci 0000:00:06.0:   bridge window [io  disabled]
[    3.395442] pci 0000:00:06.0:   bridge window [mem disabled]
[    3.401276] pci 0000:00:06.0:   bridge window [mem pref disabled]
[    3.407543] pci 0000:00:1c.0: PCI bridge to [bus 03-03]
[    3.412946] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    3.419218] pci 0000:00:1c.0:   bridge window [mem 0xf9f00000-0xf9ffffff]
[    3.426188] pci 0000:00:1c.0:   bridge window [mem 0xf0000000-0xf01fffff 64bit pref]
[    3.434257] pci 0000:00:1c.5: PCI bridge to [bus 04-04]
[    3.439658] pci 0000:00:1c.5:   bridge window [io  0x2000-0x2fff]
[    3.445926] pci 0000:00:1c.5:   bridge window [mem 0xf9e00000-0xf9efffff]
[    3.452888] pci 0000:00:1c.5:   bridge window [mem 0xf0200000-0xf03fffff 64bit pref]
[    3.460946] pci 0000:00:1e.0: PCI bridge to [bus 05-05]
[    3.466346] pci 0000:00:1e.0:   bridge window [io  disabled]
[    3.472191] pci 0000:00:1e.0:   bridge window [mem 0xf9d00000-0xf9dfffff]
[    3.479162] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    3.485440] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.492320] pci 0000:00:06.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.499212] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.506106] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.513081] NET: Registered protocol family 2
[    3.517821] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    3.526825] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    3.539418] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    3.546927] TCP: Hash tables configured (established 524288 bind 65536)
[    3.553715] TCP reno registered
[    3.557051] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    3.563418] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    3.570345] NET: Registered protocol family 1
[    3.575101] RPC: Registered udp transport module.
[    3.579983] RPC: Registered tcp transport module.
[    3.584866] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    4.703019] pci 0000:00:1d.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001
[    4.710417] Trying to unpack rootfs image as initramfs...
[    4.780651] Freeing initrd memory: 3464k freed
[    4.786286] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    4.792900] Placing 64MB software IO TLB between ffff880001fdb000 - ffff880005fdb000
[    4.800942] software IO TLB at phys 0x1fdb000 - 0x5fdb000
[    4.806768] Simple Boot Flag at 0x7a set to 0x1
[    4.813742] microcode: CPU0 sig=0x6fb, pf=0x10, revision=0xb3
[    4.819672] microcode: CPU1 sig=0x6fb, pf=0x10, revision=0xb3
[    4.825597] microcode: CPU2 sig=0x6fb, pf=0x10, revision=0xb3
[    4.831521] microcode: CPU3 sig=0x6fb, pf=0x10, revision=0xb3
[    4.841109] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    4.850612] audit: initializing netlink socket (disabled)
[    4.856205] type=2000 audit(1271097077.856:1): initialized
[    4.881674] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    4.892424] VFS: Disk quotas dquot_6.5.2
[    4.896631] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    4.904525] msgmni has been set to 11828
[    4.909414] alg: No test for stdrng (krng)
[    4.913847] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    4.921553] io scheduler noop registered
[    4.925646] io scheduler deadline registered
[    4.930258] io scheduler cfq registered (default)
[    4.936330] pcieport 0000:00:01.0: Requesting control of PCIe PME from ACPI BIOS
[    4.944036] pcieport 0000:00:01.0: Failed to receive control of PCIe PME service: no _OSC support
[    4.953225] pcie_pme: probe of 0000:00:01.0:pcie01 failed with error -13
[    4.960093] pcieport 0000:00:06.0: Requesting control of PCIe PME from ACPI BIOS
[    4.967790] pcieport 0000:00:06.0: Failed to receive control of PCIe PME service: no _OSC support
[    4.976959] pcie_pme: probe of 0000:00:06.0:pcie01 failed with error -13
[    4.983828] pcieport 0000:00:1c.0: Requesting control of PCIe PME from ACPI BIOS
[    4.991536] pcieport 0000:00:1c.0: Failed to receive control of PCIe PME service: no _OSC support
[    5.000704] pcie_pme: probe of 0000:00:1c.0:pcie01 failed with error -13
[    5.007572] pcieport 0000:00:1c.5: Requesting control of PCIe PME from ACPI BIOS
[    5.015289] pcieport 0000:00:1c.5: Failed to receive control of PCIe PME service: no _OSC support
[    5.024476] pcie_pme: probe of 0000:00:1c.5:pcie01 failed with error -13
[    5.031480] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    5.037685] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    5.046360] ACPI: Power Button [VBTN]
[    5.050324] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    5.058026] ACPI: Power Button [PWRF]
[    5.162277] Non-volatile memory driver v1.3
[    5.166644] Linux agpgart interface v0.103
[    5.171228] [drm] Initialized drm 1.1.0 20060810
[    5.176016] [drm:i915_init] *ERROR* drm/i915 can't work without intel_agp module!
[    5.183799] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
ÿ[    5.434353] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    5.441169] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    5.449894] brd: module loaded
[    5.454495] loop: module loaded
[    5.457942] Loading iSCSI transport class v2.0-870.
[    5.463672] ahci 0000:00:1f.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
[    5.470633] ahci 0000:00:1f.2: BAR 5: can't reserve [mem 0x000a0000-0x000a07ff]
[    5.478257] ahci: probe of 0000:00:1f.2 failed with error -16

-andy
