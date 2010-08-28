Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab0H1PUA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 11:20:00 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:59890 "EHLO
	mx02.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752240Ab0H1PT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 11:19:58 -0400
Date: Sat, 28 Aug 2010 11:19:53 -0400 (EDT)
From: caiqian@redhat.com
To: linux-next@vger.kernel.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        kexec <kexec@lists.infradead.org>
Message-ID: <1623596874.1474801283008793181.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <2082161789.1474781283008521258.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Subject: Re: kdump regression compared to v2.6.35
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.71]
X-Mailer: Zimbra 5.0.21_GA_3150.RHEL4_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.21_GA_3150.RHEL4_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm, after bisect the mainline, it pointed to a wrong commit earlier than v2.6.35, since we knew that v2.6.35 was working fine and v2.6.36-rc1 was broken. Here was the log starting from HEAD (bad) and v2.6.35 (good).

I noticed that we got this too,
# git bisect good
Bisecting: a merge base must be tested
[21aa9af03d06cb1d19a3738e5cf12acff984e69b] sched: add hooks for workqueue

# git bisect log
git bisect start
# good: [ab69bcd66fb4be64edfc767365cb9eb084961246] Merge git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core-2.6
git bisect good ab69bcd66fb4be64edfc767365cb9eb084961246
# good: [1cfd2bda8c486ae0e7a8005354758ebb68172bca] Merge branch 'linux-next' of git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6
git bisect good 1cfd2bda8c486ae0e7a8005354758ebb68172bca
# bad: [faa38b5e0e092914764cdba9f83d31a3f794d182] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6
git bisect bad faa38b5e0e092914764cdba9f83d31a3f794d182
# bad: [5df6b8e65ad0f2eaee202ff002ac00d1ac605315] Merge branch 'nfs-for-2.6.36' of git://git.linux-nfs.org/projects/trondmy/nfs-2.6
git bisect bad 5df6b8e65ad0f2eaee202ff002ac00d1ac605315
# bad: [1fc7995d19139d6f99203b43c161968f3f554a15] Merge git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6
git bisect bad 1fc7995d19139d6f99203b43c161968f3f554a15
# good: [e8779776afbd5f2d5315cf48c4257ca7e9b250fb] Merge branch 'x86-mce-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect good e8779776afbd5f2d5315cf48c4257ca7e9b250fb
# bad: [f34217977d717385a3e9fd7018ac39fade3964c0] workqueue: implement unbound workqueue
git bisect bad f34217977d717385a3e9fd7018ac39fade3964c0
# good: [7e27d6e778cd87b6f2415515d7127eba53fe5d02] Linux 2.6.35-rc3
git bisect good 7e27d6e778cd87b6f2415515d7127eba53fe5d02
# good: [21aa9af03d06cb1d19a3738e5cf12acff984e69b] sched: add hooks for workqueue
git bisect good 21aa9af03d06cb1d19a3738e5cf12acff984e69b
# good: [c8e55f360210c1bc49bea5d62bc3939b7ee13483] workqueue: implement worker states
git bisect good c8e55f360210c1bc49bea5d62bc3939b7ee13483
# good: [d320c03830b17af64e4547075003b1eeb274bc6c] workqueue: s/__create_workqueue()/alloc_workqueue()/, and add system workqueues
git bisect good d320c03830b17af64e4547075003b1eeb274bc6c
# good: [4ce48b37bfedc2bc11e61eae76784887e88b922c] workqueue: fix race condition in flush_workqueue()
git bisect good 4ce48b37bfedc2bc11e61eae76784887e88b922c
# good: [d313dd85ad846bc768d58e9ceb28588f917f4c9a] workqueue: fix worker management invocation without pending works
git bisect good d313dd85ad846bc768d58e9ceb28588f917f4c9a
# good: [bdbc5dd7de5d07d6c9d3536e598956165a031d4c] workqueue: prepare for WQ_UNBOUND implementation
git bisect good bdbc5dd7de5d07d6c9d3536e598956165a031d4c

Any suggestion how to track it down?

----- "CAI Qian" <caiqian@redhat.com> wrote:

> Just a head-up, the kdump kernel is stuck here. Bisect indicated that
> cc41f5cede3c63836d1c0958204630b07f5b5ee7 was also good.
> 
> Kernel command line: ro root=/dev/mapper/vg_intels3e3601-lv_root
> rd_LVM_LV=vg_intels3e3601/lv_root rd_LVM_LV=vg_intels3e3601/lv_swap
> rd_NO_LUKS rd_NO_MD rd_NO_DM LANG=en_US.UTF-8
> SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=us
> console=ttyS0,115200 irqpoll maxcpus=1 reset_devices
> cgroup_disable=memory  memmap=exactmap memmap=640K@0K
> memmap=130412K@49792K elfcorehdr=180204K memmap=128K$896K
> memmap=2124K#1978520K memmap=4280K#1980644K memmap=464K$1984924K
> memmap=156K#1985388K memmap=84K$1985544K memmap=92K#1985628K
> memmap=8K$1985720K memmap=124K#1985728K memmap=136K$1985852K
> memmap=192K#1985988K memmap=260K$1986180K memmap=2816K#1986440K
> memmap=176K$1989256K memmap=3028K#1989432K memmap=2048K#1992460K
> memmap=2072K#1994508K memmap=8K$1996580K memmap=324K#1996588K
> memmap=428K$1996912K memmap=31584K#1997340K memmap=960K$2028924K
> memmap=1248K#2029884K memmap=288K#2031132K memmap=192K#2031420K
> memmap=327684K$2031612K memmap=16384K$4128768K memmap=16K$4174960K
> memmap=16384K$4177920K
> Misrouted IRQ fixup and polling support enabled
> This may significantly impact system performance
> Disabling memory control group subsystem
> PID hash table entries: 512 (order: 0, 4096 bytes)
> Checking aperture...
> No AGP bridge found
> Queued invalidation will be enabled to support x2apic and
> Intr-remapping.
> Subtract (141 early reservations)
>   #1 [0004000000 - 00052b1548]   TEXT DATA BSS
>   #2 [000ab63000 - 000afef000]         RAMDISK
>   #3 [00052b2000 - 00052b2220]             BRK
>   #4 [000009b000 - 00000fdd20]   BIOS reserved
>   #5 [00000fdd30 - 0000100000]   BIOS reserved
>   #6 [00000fdd20 - 00000fdd30]    MP-table mpf
>   #7 [0000000012 - 000000f012]    MP-table mpc
>   #8 [0000010000 - 0000012000]      TRAMPOLINE
>   #9 [0000012000 - 0000016000]     ACPI WAKEUP
>   #10 [0000016000 - 0000017000]         PGTABLE
>   #11 [0000017000 - 000001703c]       ACPI SLIT
>   #12 [000000f040 - 000000f4c0]      MEMNODEMAP
>   #13 [00030a0000 - 00030c7000]       NODE_DATA
>   #14 [00030c7000 - 00030c8000]         BOOTMEM
>   #15 [00034c8000 - 00034c8030]         BOOTMEM
>   #16 [00038c9000 - 00038ca000]         BOOTMEM
>   #17 [00038ca000 - 00038cb000]         BOOTMEM
>   #18 [0003a00000 - 0003e00000]        MEMMAP 0
>   #19 [00030c8000 - 00030e0000]         BOOTMEM
>   #20 [00030e0000 - 00030f8000]         BOOTMEM
>   #21 [00030f8000 - 00030f9000]         BOOTMEM
>   #22 [00030f9000 - 00030f9041]         BOOTMEM
>   #23 [00030f9080 - 00030f9149]         BOOTMEM
>   #24 [00030f9180 - 00030f9768]         BOOTMEM
>   #25 [00030f9780 - 00030f97e8]         BOOTMEM
>   #26 [00030f9800 - 00030f9868]         BOOTMEM
>   #27 [00030f9880 - 00030f98e8]         BOOTMEM
>   #28 [00030f9900 - 00030f9968]         BOOTMEM
>   #29 [00030f9980 - 00030f99e8]         BOOTMEM
>   #30 [00030f9a00 - 00030f9a68]         BOOTMEM
>   #31 [00030f9a80 - 00030f9ae8]         BOOTMEM
>   #32 [00030f9b00 - 00030f9b68]         BOOTMEM
>   #33 [00030f9b80 - 00030f9be8]         BOOTMEM
>   #34 [00030f9c00 - 00030f9c68]         BOOTMEM
>   #35 [00030f9c80 - 00030f9ce8]         BOOTMEM
>   #36 [00030f9d00 - 00030f9d68]         BOOTMEM
>   #37 [00030f9d80 - 00030f9de8]         BOOTMEM
>   #38 [00030f9e00 - 00030f9e68]         BOOTMEM
>   #39 [00030f9e80 - 00030f9ee8]         BOOTMEM
>   #40 [00030f9f00 - 00030f9f68]         BOOTMEM
>   #41 [00030f9f80 - 00030f9fe8]         BOOTMEM
>   #42 [00030fa000 - 00030fa068]         BOOTMEM
>   #43 [00030fa080 - 00030fa0e8]         BOOTMEM
>   #44 [00030fa100 - 00030fa168]         BOOTMEM
>   #45 [00030fa180 - 00030fa1e8]         BOOTMEM
>   #46 [00030fa200 - 00030fa268]         BOOTMEM
>   #47 [00030fa280 - 00030fa2e8]         BOOTMEM
>   #48 [00030fa300 - 00030fa368]         BOOTMEM
>   #49 [00030fa380 - 00030fa3e8]         BOOTMEM
>   #50 [00030fa400 - 00030fa468]         BOOTMEM
>   #51 [00030fa480 - 00030fa4e8]         BOOTMEM
>   #52 [00030fa500 - 00030fa568]         BOOTMEM
>   #53 [00030fa580 - 00030fa5e8]         BOOTMEM
>   #54 [00030fa600 - 00030fa668]         BOOTMEM
>   #55 [00030fa680 - 00030fa6e8]         BOOTMEM
>   #56 [00030fa700 - 00030fa768]         BOOTMEM
>   #57 [00030fa780 - 00030fa7e8]         BOOTMEM
>   #58 [00030fa800 - 00030fa820]         BOOTMEM
>   #59 [00030fa840 - 00030fac0e]         BOOTMEM
>   #60 [00030fac40 - 00030fb00e]         BOOTMEM
>   #61 [0005400000 - 000541e000]         BOOTMEM
>   #62 [0005420000 - 000543e000]         BOOTMEM
>   #63 [0005440000 - 000545e000]         BOOTMEM
>   #64 [0005460000 - 000547e000]         BOOTMEM
>   #65 [0005480000 - 000549e000]         BOOTMEM
>   #66 [00054a0000 - 00054be000]         BOOTMEM
>   #67 [00054c0000 - 00054de000]         BOOTMEM
>   #68 [00054e0000 - 00054fe000]         BOOTMEM
>   #69 [0005500000 - 000551e000]         BOOTMEM
>   #70 [0005520000 - 000553e000]         BOOTMEM
>   #71 [0005540000 - 000555e000]         BOOTMEM
>   #72 [0005560000 - 000557e000]         BOOTMEM
>   #73 [0005580000 - 000559e000]         BOOTMEM
>   #74 [00055a0000 - 00055be000]         BOOTMEM
>   #75 [00055c0000 - 00055de000]         BOOTMEM
>   #76 [00055e0000 - 00055fe000]         BOOTMEM
>   #77 [0005600000 - 000561e000]         BOOTMEM
>   #78 [0005620000 - 000563e000]         BOOTMEM
>   #79 [0005640000 - 000565e000]         BOOTMEM
>   #80 [0005660000 - 000567e000]         BOOTMEM
>   #81 [0005680000 - 000569e000]         BOOTMEM
>   #82 [00056a0000 - 00056be000]         BOOTMEM
>   #83 [00056c0000 - 00056de000]         BOOTMEM
>   #84 [00056e0000 - 00056fe000]         BOOTMEM
>   #85 [0005700000 - 000571e000]         BOOTMEM
>   #86 [0005720000 - 000573e000]         BOOTMEM
>   #87 [0005740000 - 000575e000]         BOOTMEM
>   #88 [0005760000 - 000577e000]         BOOTMEM
>   #89 [0005780000 - 000579e000]         BOOTMEM
>   #90 [00057a0000 - 00057be000]         BOOTMEM
>   #91 [00057c0000 - 00057de000]         BOOTMEM
>   #92 [00057e0000 - 00057fe000]         BOOTMEM
>   #93 [0005800000 - 000581e000]         BOOTMEM
>   #94 [0005820000 - 000583e000]         BOOTMEM
>   #95 [0005840000 - 000585e000]         BOOTMEM
>   #96 [0005860000 - 000587e000]         BOOTMEM
>   #97 [0005880000 - 000589e000]         BOOTMEM
>   #98 [00058a0000 - 00058be000]         BOOTMEM
>   #99 [00058c0000 - 00058de000]         BOOTMEM
>   #100 [00058e0000 - 00058fe000]         BOOTMEM
>   #101 [0005900000 - 000591e000]         BOOTMEM
>   #102 [0005920000 - 000593e000]         BOOTMEM
>   #103 [0005940000 - 000595e000]         BOOTMEM
>   #104 [0005960000 - 000597e000]         BOOTMEM
>   #105 [0005980000 - 000599e000]         BOOTMEM
>   #106 [00059a0000 - 00059be000]         BOOTMEM
>   #107 [00059c0000 - 00059de000]         BOOTMEM
>   #108 [00059e0000 - 00059fe000]         BOOTMEM
>   #109 [0005a00000 - 0005a1e000]         BOOTMEM
>   #110 [0005a20000 - 0005a3e000]         BOOTMEM
>   #111 [0005a40000 - 0005a5e000]         BOOTMEM
>   #112 [0005a60000 - 0005a7e000]         BOOTMEM
>   #113 [0005a80000 - 0005a9e000]         BOOTMEM
>   #114 [0005aa0000 - 0005abe000]         BOOTMEM
>   #115 [0005ac0000 - 0005ade000]         BOOTMEM
>   #116 [0005ae0000 - 0005afe000]         BOOTMEM
>   #117 [0005b00000 - 0005b1e000]         BOOTMEM
>   #118 [0005b20000 - 0005b3e000]         BOOTMEM
>   #119 [0005b40000 - 0005b5e000]         BOOTMEM
>   #120 [0005b60000 - 0005b7e000]         BOOTMEM
>   #121 [0005b80000 - 0005b9e000]         BOOTMEM
>   #122 [0005ba0000 - 0005bbe000]         BOOTMEM
>   #123 [0005bc0000 - 0005bde000]         BOOTMEM
>   #124 [0005be0000 - 0005bfe000]         BOOTMEM
>   #125 [00030fd040 - 00030fd048]         BOOTMEM
>   #126 [00030fd080 - 00030fd088]         BOOTMEM
>   #127 [00030fd0c0 - 00030fd1c0]         BOOTMEM
>   #128 [00030fd1c0 - 00030fd3c0]         BOOTMEM
>   #129 [00030fd3c0 - 00030fd4d0]         BOOTMEM
>   #130 [00030fd500 - 00030fd548]         BOOTMEM
>   #131 [00030fd580 - 00030fd5c8]         BOOTMEM
>   #132 [00030fb040 - 00030fb240]         BOOTMEM
>   #133 [00030fb240 - 00030fb440]         BOOTMEM
>   #134 [00030fb440 - 00030fb640]         BOOTMEM
>   #135 [00030fb640 - 00030fb840]         BOOTMEM
>   #136 [00030fb840 - 00030fba40]         BOOTMEM
>   #137 [00030fba40 - 00030fbc40]         BOOTMEM
>   #138 [00030fbc40 - 00030fbe40]         BOOTMEM
>   #139 [00030fbe40 - 00030fc040]         BOOTMEM
>   #140 [00030fc040 - 00030fd040]         BOOTMEM
> Memory: 94968k/180204k available (4766k kernel code, 49156k absent,
> 36080k reserved, 7642k data, 1448k init)
> Hierarchical RCU implementation.
> 	RCU-based detection of stalled CPUs is disabled.
> 	Verbose stalled-CPUs detection is disabled.
> NR_IRQS:262400 nr_irqs:2008
> Extended CMOS year: 2000
> Spurious LAPIC timer interrupt on cpu 0
> Console: colour VGA+ 80x25
> console [ttyS0] enabled
> Fast TSC calibration using PIT
> Detected 1994.798 MHz processor.
> Calibrating delay loop (skipped), value calculated using timer
> frequency.. 3989.59 BogoMIPS (lpj=1994798)
> pid_max: default: 65536 minimum: 512
> Security Framework initialized
> SELinux:  Initializing.
> Dentry cache hash table entries: 16384 (order: 5, 131072 bytes)
> Inode-cache hash table entries: 8192 (order: 4, 65536 bytes)
> Mount-cache hash table entries: 256
> Initializing cgroup subsys ns
> Initializing cgroup subsys cpuacct
> Initializing cgroup subsys memory
> Initializing cgroup subsys devices
> Initializing cgroup subsys freezer
> Initializing cgroup subsys net_cls
> Initializing cgroup subsys blkio
> CPU: Physical Processor ID: 3
> CPU: Processor Core ID: 0
> mce: CPU supports 22 MCE banks
> using mwait in idle threads.
> Performance Events: PEBS fmt1+, Nehalem events, Intel PMU driver.
> ... version:                3
> ... bit width:              48
> ... generic registers:      4
> ... value mask:             0000ffffffffffff
> ... max period:             000000007fffffff
> ... fixed-purpose events:   3
> ... event mask:             000000070000000f
> SMP alternatives: switching to UP code
> ACPI: Core revision 20100702
> ftrace: converting mcount calls to 0f 1f 44 00 00
> ftrace: allocating 18514 entries in 73 pages
> DMAR: Host address width 48
> DMAR: DRHD base: 0x000000fd800000 flags: 0x0
> IOMMU 0: reg_base_addr fd800000 ver 1:0 cap c90780106f0462 ecap f020fe
> DMAR: DRHD base: 0x000000fd000000 flags: 0x1
> IOMMU 1: reg_base_addr fd000000 ver 1:0 cap c90780106f0462 ecap f020fe
> DMAR: RMRR base: 0x0000007be29000 end: 0x0000007be2bfff
> DMAR: RMRR base: 0x0000007be16000 end: 0x0000007be16fff
> DMAR: RMRR base: 0x0000007be13000 end: 0x0000007be13fff
> DMAR: RMRR base: 0x0000007be10000 end: 0x0000007be10fff
> DMAR: RMRR base: 0x0000007be0d000 end: 0x0000007be0dfff
> DMAR: RMRR base: 0x0000007be0a000 end: 0x0000007be0afff
> DMAR: RMRR base: 0x0000007be07000 end: 0x0000007be07fff
> DMAR: RMRR base: 0x0000007be04000 end: 0x0000007be04fff
> DMAR: RMRR base: 0x0000007be01000 end: 0x0000007be01fff
> DMAR: ATSR flags: 0x0
> DMAR: ATSR flags: 0x0
> DMAR: RHSA base: 0x000000fd000000 proximity domain: 0x0
> DMAR: RHSA base: 0x000000fd800000 proximity domain: 0x2
> IOAPIC id 10 under DRHD base  0xfd800000 IOMMU 0
> IOAPIC id 8 under DRHD base  0xfd000000 IOMMU 1
> IOAPIC id 9 under DRHD base  0xfd000000 IOMMU 1
> Enabled Interrupt-remapping
> Setting APIC routing to cluster x2apic
> ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> CPU0: Intel(R) Xeon(R) CPU           X7550  @ 2.00GHz stepping 06
> Brought up 1 CPUs
> Total of 1 processors activated (3989.59 BogoMIPS).
> devtmpfs: initialized
> regulator: core version 0.5
> NET: Registered protocol family 16
> ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
> ACPI: bus type pci registered
> PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
> 0x80000000-0x8fffffff] (base 0x80000000)
> PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] reserved in E820
> PCI: Using configuration type 1 for base access
> bio: create slab <bio-0> at 0
