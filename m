Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab0KMX5z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 18:57:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:36454 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395Ab0KMX5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 18:57:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,192,1288594800"; 
   d="scan'208";a="677250985"
Date: Sun, 14 Nov 2010 07:57:46 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Nikanth Karthikesan <knikanth@suse.de>,
        David Rientjes <rientjes@google.com>,
        "Zheng, Shaohui" <shaohui.zheng@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-hotplug@vger.kernel.org" <linux-hotplug@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Venkatesh Pallipadi <venki@google.com>, Nikhil Rao <ncrao@google.com>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Subject: Re: [BUG 2.6.27-rc1] find_busiest_group() LOCKUP
Message-ID: <20101113235746.GA9458@localhost>
References: <20101111100628.GA24728@localhost>
 <1289478978.2084.74.camel@laptop>
 <20101111124015.GA9706@localhost>
 <1289480656.2084.80.camel@laptop>
 <20101113084018.GA23098@localhost>
 <1289644224.2084.521.camel@laptop>
 <20101113120030.GA31517@localhost>
 <1289653078.2084.675.camel@laptop>
 <20101113131042.GA5522@localhost>
 <4CDEE314.6090107@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CDEE314.6090107@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 14, 2010 at 03:12:20AM +0800, Yinghai Lu wrote:
> On 11/13/2010 05:10 AM, Wu Fengguang wrote:
> > On Sat, Nov 13, 2010 at 08:57:58PM +0800, Peter Zijlstra wrote:
> >> On Sat, 2010-11-13 at 20:00 +0800, Wu Fengguang wrote:
> >>> On Sat, Nov 13, 2010 at 06:30:24PM +0800, Peter Zijlstra wrote:
> >>>> On Sat, 2010-11-13 at 16:40 +0800, Wu Fengguang wrote:
> >>>>>> Will try and figure out how the heck that's happening, Ingo any clue?
> >>>>>
> >>>>> It's back to normal on 2.6.37-rc1 when reverting commit 50f2d7f682f9
> >>>>> ("x86, numa: Assign CPUs to nodes in round-robin manner on fake NUMA").
> >>>>>
> >>>>> The interesting part is, the commit was introduced in 
> >>>>> 2.6.36-rc7..2.6.36, however 2.6.36 boots OK, while 2.6.37-rc1 panics.
> >>>>
> >>>> Argh, that commit again..
> >>>>
> >>>> Does this fix it: http://lkml.org/lkml/2010/11/12/8
> >>>
> >>> No it still panics. Here is the dmesg.
> >>
> >> OK, I'll let Nikanth have a look, if all else fails we can always
> >> revert that patch.
> > 
> > It's the same bug.
> > 
> > Just tried another machine, I get the same divide error.  The patch
> > posted in lkml/2010/11/12/8 does not fix it. But after reverting
> > commit 50f2d7f682f9, it boots OK.
> > 
> > Thanks,
> > Fengguang
> > ---
> > PS. dmesg with divide error
> > 
> > [    0.000000] console [ttyS0] enabled, bootconsole disabled
> > [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> > [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
> > [    0.000000] ... MAX_LOCK_DEPTH:          48
> > [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
> > [    0.000000] ... CLASSHASH_SIZE:          4096
> > [    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
> > [    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
> > [    0.000000] ... CHAINHASH_SIZE:          16384
> > [    0.000000]  memory used by lock dependency info: 6367 kB
> > [    0.000000]  per task-struct memory footprint: 2688 bytes
> > [    0.000000] allocated 167772160 bytes of page_cgroup
> > [    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
> > [    0.000000] ODEBUG: 15 of 15 active objects replaced
> > [    0.000000] hpet clockevent registered
> > [    0.001000] Fast TSC calibration using PIT
> > [    0.002000] Detected 2800.469 MHz processor.
> > [    0.000010] Calibrating delay loop (skipped), value calculated using timer frequency.. 5600.93 BogoMIPS (lpj=2800469)
> > [    0.010818] pid_max: default: 32768 minimum: 301
> > [    0.021745] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
> > [    0.035657] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
> > [    0.044553] Mount-cache hash table entries: 256
> > [    0.049469] Initializing cgroup subsys debug
> > [    0.053834] Initializing cgroup subsys ns
> > [    0.057940] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
> > [    0.066968] Initializing cgroup subsys cpuacct
> > [    0.071511] Initializing cgroup subsys memory
> > [    0.075988] Initializing cgroup subsys devices
> > [    0.080527] Initializing cgroup subsys freezer
> > [    0.085107] CPU: Physical Processor ID: 0
> > [    0.089209] CPU: Processor Core ID: 0
> > [    0.092974] mce: CPU supports 9 MCE banks
> > [    0.097095] CPU0: Thermal monitoring enabled (TM1)
> > [    0.101990] using mwait in idle threads.
> > [    0.106006] Performance Events: PEBS fmt1+, Westmere events, Intel PMU driver.
> > [    0.113535] ... version:                3
> > [    0.117641] ... bit width:              48
> > [    0.121828] ... generic registers:      4
> > [    0.125926] ... value mask:             0000ffffffffffff
> > [    0.131328] ... max period:             000000007fffffff
> > [    0.136734] ... fixed-purpose events:   3
> > [    0.140839] ... event mask:             000000070000000f
> > [    0.147297] ACPI: Core revision 20101013
> > [    0.175646] ftrace: allocating 24175 entries in 95 pages
> > [    0.190912] Setting APIC routing to flat
> > [    0.195562] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> > [    0.211643] CPU0: Intel(R) Xeon(R) CPU           X5660  @ 2.80GHz stepping 01
> > [    0.325243] lockdep: fixing up alternatives.
> > [    0.330242] Booting Node   0, Processors  #1lockdep: fixing up alternatives.
> > [    0.430140]  #2lockdep: fixing up alternatives.
> > [    0.526962]  #3lockdep: fixing up alternatives.
> > [    0.623755]  #4lockdep: fixing up alternatives.
> > [    0.720588]  Ok.
> > [    0.722525] Booting Node   1, Processors  #5lockdep: fixing up alternatives.
> > [    0.822389]  Ok.
> > [    0.824327] Booting Node   0, Processors  #6
> > [    0.919089] TSC synchronization [CPU#0 -> CPU#6]:
> > [    0.924155] Measured 296 cycles TSC warp between CPUs, turning off TSC clock.
> > [    0.003999] Marking TSC unstable due to check_tsc_sync_source failed
> > [    0.557048] lockdep: fixing up alternatives.
> > [    0.558041]  Ok.
> > [    0.559004] Booting Node   1, Processors  #7 Ok.
> > [    0.632157] Brought up 8 CPUs
> > [    0.633006] Total of 8 processors activated (44799.46 BogoMIPS).
> 
> assume that when you have 
> CONFIG_NR_CPUS=16
> instead of
> CONFIG_NR_CPUS=8
> 
> it will boot ok?

No. But it boots OK with CONFIG_NR_CPUS=64: it actually has 24 CPUs, a bit more
than your expectation :)

This also boots the other 16 CPU box that used to lockup in find_busiest_group().

Hope it helps debugging the bug.

Thanks,
Fengguang
---

boot log with CONFIG_NR_CPUS=64

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.37-rc1 (wfg@bee) (gcc version 4.5.0 (GCC) ) #114 SMP PREEMPT Sun Nov 14 07:21:17 CST 2010
[    0.000000] Command line: ip=::::wfg-ws02::dhcp netconsole=@:/eth0,6666@10.239.51.110/00:30:48:fe:19:94 panic=10 hung_task_panic=1 softlockup_panic=1 unknown_nmi_panic=1 nmi_watchdog=panic,lapic load_ramdisk=2 prompt_ramdisk=0 console=tty0 console=ttyS0,115200 earlyprintk=vga sched_debug nfsroot=10.239.51.240:/nfsroot/wfg,tcp,v3,rsize=524288,wsize=524288 rw BOOT_IMAGE=x86_64/vmlinuz
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009c400 (usable)
[    0.000000]  BIOS-e820: 000000000009c400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf30b000 (usable)
[    0.000000]  BIOS-e820: 00000000bf30b000 - 00000000bf38b000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf38b000 - 00000000bf3a1000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf3a1000 - 00000000bf3a2000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf3a2000 - 00000000bf3b3000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf3b3000 - 00000000bf3b6000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf3b6000 - 00000000bf3dd000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf3dd000 - 00000000bf3de000 (usable)
[    0.000000]  BIOS-e820: 00000000bf3de000 - 00000000bf3df000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf3df000 - 00000000bf414000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf414000 - 00000000bf416000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf416000 - 00000000bf418000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf418000 - 00000000bf420000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf420000 - 00000000bf421000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf421000 - 00000000bf423000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf423000 - 00000000bf42b000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf42b000 - 00000000bf454000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf454000 - 00000000bf657000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf657000 - 00000000bf800000 (usable)
[    0.000000]  BIOS-e820: 00000000c0000000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000440000000 (usable)
[    0.000000] bootconsole [earlyvga0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: X8DTN/X8DTN, BIOS 4.6.3 01/06/2010
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x440000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FC00000000 write-back
[    0.000000]   1 base 0400000000 mask FFC0000000 write-back
[    0.000000]   2 base 00C0000000 mask FFC0000000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000c0000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbf800 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000fcf20] fcf20
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-00000000bf800000
[    0.000000]  0000000000 - 00bf800000 page 4k
[    0.000000] kernel direct mapping tables up to bf800000 @ 1fa00000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-0000000440000000
[    0.000000]  0100000000 - 0440000000 page 4k
[    0.000000] kernel direct mapping tables up to 440000000 @ bd0f9000-bf30b000
[    0.000000] ACPI: RSDP 00000000000f0410 00024 (v02  A M I)
[    0.000000] ACPI: XSDT 00000000bf421e18 0008C (v01  A M I   ALASKA 01072009 MSFT 00010013)
[    0.000000] ACPI: FACP 00000000bf41fd98 000F4 (v04  A M I   ALASKA 01072009 MSFT 00010013)
[    0.000000] ACPI Warning: 32/64 FACS address mismatch in FADT - two FACS tables! (20101013/tbfadt-369)
[    0.000000] ACPI Warning: 32/64X FACS address mismatch in FADT - 0xBF420F40/0x00000000BF420E40, using 32 (20101013/tbfadt-486)
[    0.000000] ACPI: DSDT 00000000bf418018 06059 (v01  A M I   ALASKA 00000001 INTL 20051117)
[    0.000000] ACPI: FACS 00000000bf420f40 00040
[    0.000000] ACPI: APIC 00000000bf41fc18 00130 (v02  A M I   ALASKA 01072009 MSFT 00010013)
[    0.000000] ACPI: SSDT 00000000bf415798 006EE (v01 AMICPU     PROC 00000001 MSFT 03000001)
[    0.000000] ACPI: MCFG 00000000bf422f18 0003C (v01 A M I  OEMMCFG  01072009 MSFT 00000097)
[    0.000000] ACPI: SRAT 00000000bf414c98 00228 (v01 A M I  AMI SRAT 00000001 AMI. 00000000)
[    0.000000] ACPI: SLIT 00000000bf422e98 00030 (v01 A M I  AMI SLIT 00000000 AMI. 00000000)
[    0.000000] ACPI: HPET 00000000bf422e18 00038 (v01 A M I  ICH7HPET 01072009 AMI. 00000003)
[    0.000000] ACPI: SPMI 00000000bf422d98 00040 (v05 A M I   OEMSPMI 00000000 AMI. 00000000)
[    0.000000] ACPI: EINJ 00000000bf41fa98 00130 (v01    AMI AMI EINJ 00000000      00000000)
[    0.000000] ACPI: ERST 00000000bf414a18 00210 (v01  AMIER AMI ERST 00000000      00000000)
[    0.000000] ACPI: HEST 00000000bf414f18 000A8 (v01    AMI AMI HEST 00000000      00000000)
[    0.000000] ACPI: BERT 00000000bf422d18 00030 (v01    AMI AMI BERT 00000000      00000000)
[    0.000000] ACPI: DMAR 00000000bf415f18 000D4 (v01 A M I   OEMDMAR 00000001 INTL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x10 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x11 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x12 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x13 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x14 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x15 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x20 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x21 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x23 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x24 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x25 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x30 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x31 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x32 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x33 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x34 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x35 -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 0-c0000000
[    0.000000] SRAT: Node 0 PXM 0 100000000-240000000
[    0.000000] SRAT: Node 1 PXM 1 240000000-440000000
[    0.000000] SRAT: Node 0 [0,c0000000) + [100000000,240000000) -> [0,240000000)
[    0.000000] NUMA: Using 30 for the hash shift.
[    0.000000] Initmem setup node 0 0000000000000000-0000000240000000
[    0.000000]   NODE_DATA [000000023fffb000 - 000000023fffffff]
[    0.000000] Initmem setup node 1 0000000240000000-0000000440000000
[    0.000000]   NODE_DATA [000000043fffa000 - 000000043fffefff]
[    0.000000]  [ffffea0000000000-ffffea0007dfffff] PMD -> [ffff880237e00000-ffff88023edfffff] on node 0
[    0.000000]  [ffffea0007e00000-ffffea000edfffff] PMD -> [ffff880437e00000-ffff88043edfffff] on node 1
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00440000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[6] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009c
[    0.000000]     0: 0x00000100 -> 0x000bf30b
[    0.000000]     0: 0x000bf3dd -> 0x000bf3de
[    0.000000]     0: 0x000bf657 -> 0x000bf800
[    0.000000]     0: 0x00100000 -> 0x00240000
[    0.000000]     1: 0x00240000 -> 0x00440000
[    0.000000] On node 0 totalpages: 2094145
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3918 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 765165 pages, LIFO batch:31
[    0.000000]   Normal zone: 17920 pages used for memmap
[    0.000000]   Normal zone: 1292800 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 2097152
[    0.000000]   Normal zone: 28672 pages used for memmap
[    0.000000]   Normal zone: 2068480 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x24] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x30] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x32] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x34] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x25] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x31] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x33] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x35] enabled)
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec01000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 2, version 32, address 0xfec01000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec02000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 3, version 32, address 0xfec02000, GSI 48-71
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec90000] gsi_base[72])
[    0.000000] IOAPIC[3]: apic_id 4, version 32, address 0xfec90000, GSI 72-95
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] SMP: Allowing 24 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 112
[    0.000000] Allocating PCI resources starting at d0000000 (gap: d0000000:2ed1c000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:24 nr_node_ids:2
[    0.000000] PERCPU: Embedded 475 pages/cpu @ffff8800bb800000 s1915520 r8192 d21888 u2097152
[    0.000000] pcpu-alloc: s1915520 r8192 d21888 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 [0] 01 [0] 02 [0] 03 [0] 04 [0] 05 [0] 12 [0] 13
[    0.000000] pcpu-alloc: [0] 14 [0] 15 [0] 16 [0] 17 [1] 06 [1] 07 [1] 08 [1] 09
[    0.000000] pcpu-alloc: [1] 10 [1] 11 [1] 18 [1] 19 [1] 20 [1] 21 [1] 22 [1] 23
[    0.000000] Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 4130363
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: ip=::::wfg-ws02::dhcp netconsole=@:/eth0,6666@10.239.51.110/00:30:48:fe:19:94 panic=10 hung_task_panic=1 softlockup_panic=1 unknown_nmi_panic=1 nmi_watchdog=panic,lapic load_ramdisk=2 prompt_ramdisk=0 console=tty0 console=ttyS0,115200 earlyprintk=vga sched_debug nfsroot=10.239.51.240:/nfsroot/wfg,tcp,v3,rsize=524288,wsize=524288 rw BOOT_IMAGE=x86_64/vmlinuz
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Memory: 16355432k/17825792k available (9918k kernel code, 1060604k absent, 409756k reserved, 10845k data, 2720k init)
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at /home/wfg/cc/linux-2.6/kernel/lockdep.c:2481 lockdep_trace_alloc+0xed/0x100()
[    0.000000] Hardware name: X8DTN
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.37-rc1 #114
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff810bc4fd>] warn_slowpath_common+0xad/0xf0
[    0.000000]  [<ffffffff810bc55a>] warn_slowpath_null+0x1a/0x20
[    0.000000]  [<ffffffff8110de8d>] lockdep_trace_alloc+0xed/0x100
[    0.000000]  [<ffffffff81201d70>] __kmalloc_node+0x30/0x340
[    0.000000]  [<ffffffff8110abc8>] ? lock_release_holdtime+0xb8/0x160
[    0.000000]  [<ffffffff811d0ada>] pcpu_mem_alloc+0x16a/0x1b0
[    0.000000]  [<ffffffff82642ba1>] percpu_init_late+0x48/0xc2
[    0.000000]  [<ffffffff8261dd2f>] start_kernel+0x1d4/0x473
[    0.000000]  [<ffffffff8261d35c>] x86_64_start_reservations+0x163/0x167
[    0.000000]  [<ffffffff8261d498>] x86_64_start_kernel+0x138/0x147
[    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.000000] Preemptable hierarchical RCU implementation.
[    0.000000]  RCU debugfs-based tracing is enabled.
[    0.000000]  RCU-based detection of stalled CPUs is disabled.
[    0.000000]  Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:2096 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled, bootconsole disabled
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
[    0.000000] allocated 167772160 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] ODEBUG: 31 of 31 active objects replaced
[    0.000000] hpet clockevent registered
[    0.001000] Fast TSC calibration using PIT
[    0.002000] Detected 2800.178 MHz processor.
[    0.000016] Calibrating delay loop (skipped), value calculated using timer frequency.. 5600.35 BogoMIPS (lpj=2800178)
[    0.010836] pid_max: default: 32768 minimum: 301
[    0.021803] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.035706] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.044621] Mount-cache hash table entries: 256
[    0.049552] Initializing cgroup subsys debug
[    0.053921] Initializing cgroup subsys ns
[    0.058025] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.067055] Initializing cgroup subsys cpuacct
[    0.071607] Initializing cgroup subsys memory
[    0.076095] Initializing cgroup subsys devices
[    0.080641] Initializing cgroup subsys freezer
[    0.085226] CPU: Physical Processor ID: 0
[    0.089330] CPU: Processor Core ID: 0
[    0.093098] mce: CPU supports 9 MCE banks
[    0.097217] CPU0: Thermal monitoring enabled (TM1)
[    0.102119] using mwait in idle threads.
[    0.106136] Performance Events: PEBS fmt1+, Westmere events, Intel PMU driver.
[    0.113674] ... version:                3
[    0.117779] ... bit width:              48
[    0.121974] ... generic registers:      4
[    0.126083] ... value mask:             0000ffffffffffff
[    0.131492] ... max period:             000000007fffffff
[    0.136898] ... fixed-purpose events:   3
[    0.141005] ... event mask:             000000070000000f
[    0.147471] ACPI: Core revision 20101013
[    0.176380] ftrace: allocating 24175 entries in 95 pages
[    0.191595] Setting APIC routing to physical flat
[    0.197035] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.213111] CPU0: Intel(R) Xeon(R) CPU           X5660  @ 2.80GHz stepping 01
[    0.327225] lockdep: fixing up alternatives.
[    0.332222] Booting Node   0, Processors  #1lockdep: fixing up alternatives.
[    0.432127]  #2lockdep: fixing up alternatives.
[    0.528955]  #3lockdep: fixing up alternatives.
[    0.625744]  #4lockdep: fixing up alternatives.
[    0.722551]  #5lockdep: fixing up alternatives.
[    0.819386]  Ok.
[    0.821322] Booting Node   1, Processors  #6
[    0.916109] TSC synchronization [CPU#0 -> CPU#6]:
[    0.921179] Measured 294 cycles TSC warp between CPUs, turning off TSC clock.
[    0.003999] Marking TSC unstable due to check_tsc_sync_source failed
[    0.556037] lockdep: fixing up alternatives.
[    0.557042]  #7lockdep: fixing up alternatives.
[    0.632045]  #8lockdep: fixing up alternatives.
[    0.707047]  #9lockdep: fixing up alternatives.
[    0.782052]  #10lockdep: fixing up alternatives.
[    0.858049]  #11lockdep: fixing up alternatives.
[    0.933058]  Ok.
[    0.934006] Booting Node   0, Processors  #12lockdep: fixing up alternatives.
[    1.009056]  #13lockdep: fixing up alternatives.
[    1.085067]  #14lockdep: fixing up alternatives.
[    1.161064]  #15lockdep: fixing up alternatives.
[    1.237058]  #16lockdep: fixing up alternatives.
[    1.313056]  #17lockdep: fixing up alternatives.
[    1.389041]  Ok.
[    1.390004] Booting Node   1, Processors  #18lockdep: fixing up alternatives.
[    1.465080]  #19lockdep: fixing up alternatives.
[    1.541043]  #20lockdep: fixing up alternatives.
[    1.617058]  #21lockdep: fixing up alternatives.
[    1.693041]  #22lockdep: fixing up alternatives.
[    1.769061]  #23 Ok.
[    1.841195] Brought up 24 CPUs
[    1.842006] Total of 24 processors activated (134396.94 BogoMIPS).
[    1.843047] Testing NMI watchdog ... OK.
[    1.865212] CPU0 attaching sched-domain:
[    1.866005]  domain 0: span 0,12 level SIBLING
[    1.868003]   groups: 0 (cpu_power = 589) 12 (cpu_power = 589)
[    1.871308]   domain 1: span 0-5,12-17 level MC
[    1.873016]    groups: 0,12 (cpu_power = 1178) 1,13 (cpu_power = 1178) 2,14 (cpu_power = 1178) 3,15 (cpu_power = 1178) 4,16 (cpu_power = 1178) 5,17 (cpu_power = 1178)
[    1.884278]    domain 2: span 0-23 level NODE
[    1.886031]     groups: 0-5,12-17 (cpu_power = 7068) 6-11,18-23 (cpu_power = 7068)
[    1.892056] CPU1 attaching sched-domain:
[    1.893004]  domain 0: span 1,13 level SIBLING
[    1.895003]   groups: 1 (cpu_power = 589) 13 (cpu_power = 589)
[    1.901044]   domain 1: span 0-5,12-17 level MC
[    1.903004]    groups: 1,13 (cpu_power = 1178) 2,14 (cpu_power = 1178) 3,15 (cpu_power = 1178) 4,16 (cpu_power = 1178) 5,17 (cpu_power = 1178) 0,12 (cpu_power = 1178)
[    1.912279]    domain 2: span 0-23 level NODE
[    1.914004]     groups: 0-5,12-17 (cpu_power = 7068) 6-11,18-23 (cpu_power = 7068)
[    1.920005] CPU2 attaching sched-domain:
[    1.921004]  domain 0: span 2,14 level SIBLING
[    1.923003]   groups: 2 (cpu_power = 589) 14 (cpu_power = 589)
[    1.929039]   domain 1: span 0-5,12-17 level MC
[    1.931003]    groups: 2,14 (cpu_power = 1178) 3,15 (cpu_power = 1178) 4,16 (cpu_power = 1178) 5,17 (cpu_power = 1178) 0,12 (cpu_power = 1178) 1,13 (cpu_power = 1178)
[    1.940278]    domain 2: span 0-23 level NODE
[    1.942005]     groups: 0-5,12-17 (cpu_power = 7068) 6-11,18-23 (cpu_power = 7068)
[    1.948005] CPU3 attaching sched-domain:
[    1.949004]  domain 0: span 3,15 level SIBLING
[    1.951003]   groups: 3 (cpu_power = 589) 15 (cpu_power = 589)
[    1.957029]   domain 1: span 0-5,12-17 level MC
[    1.959003]    groups: 3,15 (cpu_power = 1178) 4,16 (cpu_power = 1178) 5,17 (cpu_power = 1178) 0,12 (cpu_power = 1178) 1,13 (cpu_power = 1178) 2,14 (cpu_power = 1178)
[    1.968286]    domain 2: span 0-23 level NODE
[    1.970003]     groups: 0-5,12-17 (cpu_power = 7068) 6-11,18-23 (cpu_power = 7068)
[    1.976006] CPU4 attaching sched-domain:
[    1.977004]  domain 0: span 4,16 level SIBLING
[    1.979003]   groups: 4 (cpu_power = 589) 16 (cpu_power = 589)
[    1.984042]   domain 1: span 0-5,12-17 level MC
[    1.986003]    groups: 4,16 (cpu_power = 1178) 5,17 (cpu_power = 1178) 0,12 (cpu_power = 1178) 1,13 (cpu_power = 1178) 2,14 (cpu_power = 1178) 3,15 (cpu_power = 1178)
[    1.995278]    domain 2: span 0-23 level NODE
[    1.997003]     groups: 0-5,12-17 (cpu_power = 7068) 6-11,18-23 (cpu_power = 7068)
[    2.003005] CPU5 attaching sched-domain:
[    2.004004]  domain 0: span 5,17 level SIBLING
[    2.006003]   groups: 5 (cpu_power = 589) 17 (cpu_power = 589)
[    2.012042]   domain 1: span 0-5,12-17 level MC
[    2.014003]    groups: 5,17 (cpu_power = 1178) 0,12 (cpu_power = 1178) 1,13 (cpu_power = 1178) 2,14 (cpu_power = 1178) 3,15 (cpu_power = 1178) 4,16 (cpu_power = 1178)
[    2.023278]    domain 2: span 0-23 level NODE
[    2.025004]     groups: 0-5,12-17 (cpu_power = 7068) 6-11,18-23 (cpu_power = 7068)
[    2.031005] CPU6 attaching sched-domain:
[    2.032004]  domain 0: span 6,18 level SIBLING
[    2.034003]   groups: 6 (cpu_power = 589) 18 (cpu_power = 589)
[    2.039041]   domain 1: span 6-11,18-23 level MC
[    2.041004]    groups: 6,18 (cpu_power = 1178) 7,19 (cpu_power = 1178) 8,20 (cpu_power = 1178) 9,21 (cpu_power = 1178) 10,22 (cpu_power = 1178) 11,23 (cpu_power = 1178)
[    2.051280]    domain 2: span 0-23 level NODE
[    2.053003]     groups: 6-11,18-23 (cpu_power = 7068) 0-5,12-17 (cpu_power = 7068)
[    2.058290] CPU7 attaching sched-domain:
[    2.059004]  domain 0: span 7,19 level SIBLING
[    2.061004]   groups: 7 (cpu_power = 589) 19 (cpu_power = 589)
[    2.066004]   domain 1: span 6-11,18-23 level MC
[    2.068004]    groups: 7,19 (cpu_power = 1178) 8,20 (cpu_power = 1178) 9,21 (cpu_power = 1178) 10,22 (cpu_power = 1178) 11,23 (cpu_power = 1178) 6,18 (cpu_power = 1178)
[    2.077286]    domain 2: span 0-23 level NODE
[    2.079003]     groups: 6-11,18-23 (cpu_power = 7068) 0-5,12-17 (cpu_power = 7068)
[    2.084321] CPU8 attaching sched-domain:
[    2.085005]  domain 0: span 8,20 level SIBLING
[    2.087005]   groups: 8 (cpu_power = 589) 20 (cpu_power = 589)
[    2.091005]   domain 1: span 6-11,18-23 level MC
[    2.093004]    groups: 8,20 (cpu_power = 1178) 9,21 (cpu_power = 1178) 10,22 (cpu_power = 1178) 11,23 (cpu_power = 1178) 6,18 (cpu_power = 1178) 7,19 (cpu_power = 1178)
[    2.102280]    domain 2: span 0-23 level NODE
[    2.104003]     groups: 6-11,18-23 (cpu_power = 7068) 0-5,12-17 (cpu_power = 7068)
[    2.109310] CPU9 attaching sched-domain:
[    2.110004]  domain 0: span 9,21 level SIBLING
[    2.112030]   groups: 9 (cpu_power = 589) 21 (cpu_power = 589)
[    2.115327]   domain 1: span 6-11,18-23 level MC
[    2.117004]    groups: 9,21 (cpu_power = 1178) 10,22 (cpu_power = 1178) 11,23 (cpu_power = 1178) 6,18 (cpu_power = 1178) 7,19 (cpu_power = 1178) 8,20 (cpu_power = 1178)
[    2.128009]    domain 2: span 0-23 level NODE
[    2.130004]     groups: 6-11,18-23 (cpu_power = 7068) 0-5,12-17 (cpu_power = 7068)
[    2.136289] CPU10 attaching sched-domain:
[    2.137004]  domain 0: span 10,22 level SIBLING
[    2.139004]   groups: 10 (cpu_power = 589) 22 (cpu_power = 589)
[    2.142285]   domain 1: span 6-11,18-23 level MC
[    2.144003]    groups: 10,22 (cpu_power = 1178) 11,23 (cpu_power = 1178) 6,18 (cpu_power = 1178) 7,19 (cpu_power = 1178) 8,20 (cpu_power = 1178) 9,21 (cpu_power = 1178)
[    2.154281]    domain 2: span 0-23 level NODE
[    2.156039]     groups: 6-11,18-23 (cpu_power = 7068) 0-5,12-17 (cpu_power = 7068)
[    2.162007] CPU11 attaching sched-domain:
[    2.163004]  domain 0: span 11,23 level SIBLING
[    2.165005]   groups: 11 (cpu_power = 589) 23 (cpu_power = 589)
[    2.168321]   domain 1: span 6-11,18-23 level MC
[    2.170003]    groups: 11,23 (cpu_power = 1178) 6,18 (cpu_power = 1178) 7,19 (cpu_power = 1178) 8,20 (cpu_power = 1178) 9,21 (cpu_power = 1178) 10,22 (cpu_power = 1178)
[    2.182004]    domain 2: span 0-23 level NODE
[    2.184004]     groups: 6-11,18-23 (cpu_power = 7068) 0-5,12-17 (cpu_power = 7068)
[    2.189288] CPU12 attaching sched-domain:
[    2.190005]  domain 0: span 0,12 level SIBLING
[    2.192004]   groups: 12 (cpu_power = 589) 0 (cpu_power = 589)
[    2.195283]   domain 1: span 0-5,12-17 level MC
[    2.197003]    groups: 0,12 (cpu_power = 1178) 1,13 (cpu_power = 1178) 2,14 (cpu_power = 1178) 3,15 (cpu_power = 1178) 4,16 (cpu_power = 1178) 5,17 (cpu_power = 1178)
[    2.209035]    domain 2: span 0-23 level NODE
[    2.211003]     groups: 0-5,12-17 (cpu_power = 7068) 6-11,18-23 (cpu_power = 7068)
[    2.216283] CPU13 attaching sched-domain:
[    2.217004]  domain 0: span 1,13 level SIBLING
[    2.219004]   groups: 13 (cpu_power = 589) 1 (cpu_power = 589)
[    2.222283]   domain 1: span 0-5,12-17 level MC
[    2.224010]    groups: 1,13 (cpu_power = 1178) 2,14 (cpu_power = 1178) 3,15 (cpu_power = 1178) 4,16 (cpu_power = 1178) 5,17 (cpu_power = 1178) 0,12 (cpu_power = 1178)
[    2.233283]    domain 2: span 0-23 level NODE
[    2.235004]     groups: 0-5,12-17 (cpu_power = 7068) 6-11,18-23 (cpu_power = 7068)
[    2.240324] CPU14 attaching sched-domain:
[    2.241005]  domain 0: span 2,14 level SIBLING
[    2.243005]   groups: 14 (cpu_power = 589) 2 (cpu_power = 589)
[    2.246312]   domain 1: span 0-5,12-17 level MC
[    2.248011]    groups: 2,14 (cpu_power = 1178) 3,15 (cpu_power = 1178) 4,16 (cpu_power = 1178) 5,17 (cpu_power = 1178) 0,12 (cpu_power = 1178) 1,13 (cpu_power = 1178)
[    2.257287]    domain 2: span 0-23 level NODE
[    2.259004]     groups: 0-5,12-17 (cpu_power = 7068) 6-11,18-23 (cpu_power = 7068)
[    2.264323] CPU15 attaching sched-domain:
[    2.265004]  domain 0: span 3,15 level SIBLING
[    2.267016]   groups: 15 (cpu_power = 589) 3 (cpu_power = 589)
[    2.270320]   domain 1: span 0-5,12-17 level MC
[    2.272036]    groups: 3,15 (cpu_power = 1178) 4,16 (cpu_power = 1178) 5,17 (cpu_power = 1178) 0,12 (cpu_power = 1178) 1,13 (cpu_power = 1178) 2,14 (cpu_power = 1178)
[    2.281279]    domain 2: span 0-23 level NODE
[    2.283003]     groups: 0-5,12-17 (cpu_power = 7068) 6-11,18-23 (cpu_power = 7068)
[    2.288304] CPU16 attaching sched-domain:
[    2.289004]  domain 0: span 4,16 level SIBLING
[    2.291024]   groups: 16 (cpu_power = 589) 4 (cpu_power = 589)
[    2.294285]   domain 1: span 0-5,12-17 level MC
[    2.296004]    groups: 4,16 (cpu_power = 1178) 5,17 (cpu_power = 1178) 0,12 (cpu_power = 1178) 1,13 (cpu_power = 1178) 2,14 (cpu_power = 1178) 3,15 (cpu_power = 1178)
[    2.306278]    domain 2: span 0-23 level NODE
[    2.308003]     groups: 0-5,12-17 (cpu_power = 7068) 6-11,18-23 (cpu_power = 7068)
[    2.314006] CPU17 attaching sched-domain:
[    2.315004]  domain 0: span 5,17 level SIBLING
[    2.317004]   groups: 17 (cpu_power = 589) 5 (cpu_power = 589)
[    2.321004]   domain 1: span 0-5,12-17 level MC
[    2.323004]    groups: 5,17 (cpu_power = 1178) 0,12 (cpu_power = 1178) 1,13 (cpu_power = 1178) 2,14 (cpu_power = 1178) 3,15 (cpu_power = 1178) 4,16 (cpu_power = 1178)
[    2.333278]    domain 2: span 0-23 level NODE
[    2.335003]     groups: 0-5,12-17 (cpu_power = 7068) 6-11,18-23 (cpu_power = 7068)
[    2.341007] CPU18 attaching sched-domain:
[    2.342004]  domain 0: span 6,18 level SIBLING
[    2.344004]   groups: 18 (cpu_power = 589) 6 (cpu_power = 589)
[    2.348279]   domain 1: span 6-11,18-23 level MC
[    2.350005]    groups: 6,18 (cpu_power = 1178) 7,19 (cpu_power = 1178) 8,20 (cpu_power = 1178) 9,21 (cpu_power = 1178) 10,22 (cpu_power = 1178) 11,23 (cpu_power = 1178)
[    2.360280]    domain 2: span 0-23 level NODE
[    2.362035]     groups: 6-11,18-23 (cpu_power = 7068) 0-5,12-17 (cpu_power = 7068)
[    2.368007] CPU19 attaching sched-domain:
[    2.369004]  domain 0: span 7,19 level SIBLING
[    2.371004]   groups: 19 (cpu_power = 589) 7 (cpu_power = 589)
[    2.375005]   domain 1: span 6-11,18-23 level MC
[    2.377005]    groups: 7,19 (cpu_power = 1178) 8,20 (cpu_power = 1178) 9,21 (cpu_power = 1178) 10,22 (cpu_power = 1178) 11,23 (cpu_power = 1178) 6,18 (cpu_power = 1178)
[    2.386280]    domain 2: span 0-23 level NODE
[    2.388003]     groups: 6-11,18-23 (cpu_power = 7068) 0-5,12-17 (cpu_power = 7068)
[    2.393281] CPU20 attaching sched-domain:
[    2.394004]  domain 0: span 8,20 level SIBLING
[    2.396004]   groups: 20 (cpu_power = 589) 8 (cpu_power = 589)
[    2.399321]   domain 1: span 6-11,18-23 level MC
[    2.401003]    groups: 8,20 (cpu_power = 1178) 9,21 (cpu_power = 1178) 10,22 (cpu_power = 1178) 11,23 (cpu_power = 1178) 6,18 (cpu_power = 1178) 7,19 (cpu_power = 1178)
[    2.412005]    domain 2: span 0-23 level NODE
[    2.414005]     groups: 6-11,18-23 (cpu_power = 7068) 0-5,12-17 (cpu_power = 7068)
[    2.419289] CPU21 attaching sched-domain:
[    2.420005]  domain 0: span 9,21 level SIBLING
[    2.422003]   groups: 21 (cpu_power = 589) 9 (cpu_power = 589)
[    2.425285]   domain 1: span 6-11,18-23 level MC
[    2.427004]    groups: 9,21 (cpu_power = 1178) 10,22 (cpu_power = 1178) 11,23 (cpu_power = 1178) 6,18 (cpu_power = 1178) 7,19 (cpu_power = 1178) 8,20 (cpu_power = 1178)
[    2.439281]    domain 2: span 0-23 level NODE
[    2.441004]     groups: 6-11,18-23 (cpu_power = 7068) 0-5,12-17 (cpu_power = 7068)
[    2.446290] CPU22 attaching sched-domain:
[    2.447035]  domain 0: span 10,22 level SIBLING
[    2.449003]   groups: 22 (cpu_power = 589) 10 (cpu_power = 589)
[    2.455039]   domain 1: span 6-11,18-23 level MC
[    2.457005]    groups: 10,22 (cpu_power = 1178) 11,23 (cpu_power = 1178) 6,18 (cpu_power = 1178) 7,19 (cpu_power = 1178) 8,20 (cpu_power = 1178) 9,21 (cpu_power = 1178)
[    2.467279]    domain 2: span 0-23 level NODE
[    2.469003]     groups: 6-11,18-23 (cpu_power = 7068) 0-5,12-17 (cpu_power = 7068)
[    2.474333] CPU23 attaching sched-domain:
[    2.475004]  domain 0: span 11,23 level SIBLING
[    2.477003]   groups: 23 (cpu_power = 589) 11 (cpu_power = 589)
[    2.480281]   domain 1: span 6-11,18-23 level MC
[    2.482003]    groups: 11,23 (cpu_power = 1178) 6,18 (cpu_power = 1178) 7,19 (cpu_power = 1178) 8,20 (cpu_power = 1178) 9,21 (cpu_power = 1178) 10,22 (cpu_power = 1178)
[    2.494004]    domain 2: span 0-23 level NODE
[    2.496004]     groups: 6-11,18-23 (cpu_power = 7068) 0-5,12-17 (cpu_power = 7068)
[    2.503103] kworker/u:0 used greatest stack depth: 6256 bytes left
[    2.509663] kworker/u:0 used greatest stack depth: 6184 bytes left
[    2.542676] Time:  7:24:04  Date: 11/14/10
[    2.547091] NET: Registered protocol family 16
[    2.554136] ACPI: bus type pci registered
[    2.559189] dca service started, version 1.12.1
[    2.564137] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xc0000000-0xcfffffff] (base 0xc0000000)
[    2.573008] PCI: MMCONFIG at [mem 0xc0000000-0xcfffffff] reserved in E820
[    2.674777] PCI: Using configuration type 1 for base access
[    2.751174] ACPI: EC: Look up EC in DSDT
[    2.757663] \_SB_:_OSC evaluation returned wrong type
[    2.762004] _OSC request data:1 6
[    2.771347] ACPI: Executed 1 blocks of module-level executable AML code
[    2.818630] ACPI: SSDT 00000000bf416018 01494 (v01    AMI      IST 00000001 MSFT 03000001)
[    2.834125] ACPI: Dynamic OEM Table Load:
[    2.838286] ACPI: SSDT           (null) 01494 (v01    AMI      IST 00000001 MSFT 03000001)
[    2.867908] ACPI: Interpreter enabled
[    2.871006] ACPI: (supports S0 S5)
[    2.875010] ACPI: Using IOAPIC for interrupt routing
[    2.890103] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    2.952329] ACPI: No dock devices found.
[    2.956007] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    2.966583] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    2.973364] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    2.980008] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    2.987008] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    2.994010] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xffffffff]
[    3.002029] pci 0000:00:00.0: [8086:3406] type 0 class 0x000600
[    3.008064] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    3.014009] pci 0000:00:00.0: PME# disabled
[    3.018029] pci 0000:00:01.0: [8086:3408] type 1 class 0x000604
[    3.024072] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    3.031007] pci 0000:00:01.0: PME# disabled
[    3.035034] pci 0000:00:03.0: [8086:340a] type 1 class 0x000604
[    3.041062] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    3.047007] pci 0000:00:03.0: PME# disabled
[    3.052030] pci 0000:00:05.0: [8086:340c] type 1 class 0x000604
[    3.058060] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    3.064008] pci 0000:00:05.0: PME# disabled
[    3.068034] pci 0000:00:07.0: [8086:340e] type 1 class 0x000604
[    3.074062] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    3.081029] pci 0000:00:07.0: PME# disabled
[    3.085029] pci 0000:00:09.0: [8086:3410] type 1 class 0x000604
[    3.091060] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    3.097006] pci 0000:00:09.0: PME# disabled
[    3.102108] pci 0000:00:13.0: [8086:342d] type 0 class 0x000800
[    3.108017] pci 0000:00:13.0: reg 10: [mem 0xfbe24000-0xfbe24fff]
[    3.114058] pci 0000:00:13.0: PME# supported from D0 D3hot D3cold
[    3.120006] pci 0000:00:13.0: PME# disabled
[    3.125028] pci 0000:00:14.0: [8086:342e] type 0 class 0x000800
[    3.131157] pci 0000:00:14.1: [8086:3422] type 0 class 0x000800
[    3.137081] pci 0000:00:14.2: [8086:3423] type 0 class 0x000800
[    3.143081] pci 0000:00:14.3: [8086:3438] type 0 class 0x000800
[    3.149077] pci 0000:00:16.0: [8086:3430] type 0 class 0x000880
[    3.155019] pci 0000:00:16.0: reg 10: [mem 0xfbe1c000-0xfbe1ffff 64bit]
[    3.162084] pci 0000:00:16.1: [8086:3431] type 0 class 0x000880
[    3.168019] pci 0000:00:16.1: reg 10: [mem 0xfbe18000-0xfbe1bfff 64bit]
[    3.175081] pci 0000:00:16.2: [8086:3432] type 0 class 0x000880
[    3.181018] pci 0000:00:16.2: reg 10: [mem 0xfbe14000-0xfbe17fff 64bit]
[    3.188135] pci 0000:00:16.3: [8086:3433] type 0 class 0x000880
[    3.194019] pci 0000:00:16.3: reg 10: [mem 0xfbe10000-0xfbe13fff 64bit]
[    3.201116] pci 0000:00:16.4: [8086:3429] type 0 class 0x000880
[    3.207018] pci 0000:00:16.4: reg 10: [mem 0xfbe0c000-0xfbe0ffff 64bit]
[    3.214113] pci 0000:00:16.5: [8086:342a] type 0 class 0x000880
[    3.220019] pci 0000:00:16.5: reg 10: [mem 0xfbe08000-0xfbe0bfff 64bit]
[    3.227107] pci 0000:00:16.6: [8086:342b] type 0 class 0x000880
[    3.233018] pci 0000:00:16.6: reg 10: [mem 0xfbe04000-0xfbe07fff 64bit]
[    3.240114] pci 0000:00:16.7: [8086:342c] type 0 class 0x000880
[    3.246020] pci 0000:00:16.7: reg 10: [mem 0xfbe00000-0xfbe03fff 64bit]
[    3.253125] pci 0000:00:1a.0: [8086:3a37] type 0 class 0x000c03
[    3.259055] pci 0000:00:1a.0: reg 20: [io  0xf0c0-0xf0df]
[    3.264065] pci 0000:00:1a.2: [8086:3a39] type 0 class 0x000c03
[    3.270054] pci 0000:00:1a.2: reg 20: [io  0xf0a0-0xf0bf]
[    3.276070] pci 0000:00:1a.7: [8086:3a3c] type 0 class 0x000c03
[    3.282028] pci 0000:00:1a.7: reg 10: [mem 0xfbe23000-0xfbe233ff]
[    3.288090] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    3.295008] pci 0000:00:1a.7: PME# disabled
[    3.299033] pci 0000:00:1c.0: [8086:3a40] type 1 class 0x000604
[    3.305072] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    3.311007] pci 0000:00:1c.0: PME# disabled
[    3.315031] pci 0000:00:1c.4: [8086:3a48] type 1 class 0x000604
[    3.321079] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    3.328008] pci 0000:00:1c.4: PME# disabled
[    3.332038] pci 0000:00:1d.0: [8086:3a34] type 0 class 0x000c03
[    3.338054] pci 0000:00:1d.0: reg 20: [io  0xf080-0xf09f]
[    3.344059] pci 0000:00:1d.1: [8086:3a35] type 0 class 0x000c03
[    3.350054] pci 0000:00:1d.1: reg 20: [io  0xf060-0xf07f]
[    3.355063] pci 0000:00:1d.2: [8086:3a36] type 0 class 0x000c03
[    3.361053] pci 0000:00:1d.2: reg 20: [io  0xf040-0xf05f]
[    3.367069] pci 0000:00:1d.7: [8086:3a3a] type 0 class 0x000c03
[    3.373028] pci 0000:00:1d.7: reg 10: [mem 0xfbe22000-0xfbe223ff]
[    3.379089] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    3.386045] pci 0000:00:1d.7: PME# disabled
[    3.390032] pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
[    3.396075] pci 0000:00:1f.0: [8086:3a16] type 0 class 0x000601
[    3.402093] pci 0000:00:1f.0: quirk: [io  0x0400-0x047f] claimed by ICH6 ACPI/GPIO/TCO
[    3.410007] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
[    3.418008] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0600 (mask 00ff)
[    3.425007] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0ca0 (mask 000f)
[    3.433006] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0290 (mask 001f)
[    3.441006] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 0ca0 (mask 000f)
[    3.449092] pci 0000:00:1f.2: [8086:3a22] type 0 class 0x000106
[    3.455026] pci 0000:00:1f.2: reg 10: [io  0xf110-0xf117]
[    3.460012] pci 0000:00:1f.2: reg 14: [io  0xf100-0xf103]
[    3.466013] pci 0000:00:1f.2: reg 18: [io  0xf0f0-0xf0f7]
[    3.471012] pci 0000:00:1f.2: reg 1c: [io  0xf0e0-0xf0e3]
[    3.477013] pci 0000:00:1f.2: reg 20: [io  0xf020-0xf03f]
[    3.482013] pci 0000:00:1f.2: reg 24: [mem 0xfbe21000-0xfbe217ff]
[    3.489085] pci 0000:00:1f.2: PME# supported from D3hot
[    3.494007] pci 0000:00:1f.2: PME# disabled
[    3.498026] pci 0000:00:1f.3: [8086:3a30] type 0 class 0x000c05
[    3.504021] pci 0000:00:1f.3: reg 10: [mem 0xfbe20000-0xfbe200ff 64bit]
[    3.511028] pci 0000:00:1f.3: reg 20: [io  0xf000-0xf01f]
[    3.517145] pci 0000:01:00.0: [8086:10c9] type 0 class 0x000200
[    3.524017] pci 0000:01:00.0: reg 10: [mem 0xfbaa0000-0xfbabffff]
[    3.531040] pci 0000:01:00.0: reg 14: [mem 0xfba80000-0xfba9ffff]
[    3.537014] pci 0000:01:00.0: reg 18: [io  0xe020-0xe03f]
[    3.542013] pci 0000:01:00.0: reg 1c: [mem 0xfbb44000-0xfbb47fff]
[    3.549069] pci 0000:01:00.0: reg 30: [mem 0xfba60000-0xfba7ffff pref]
[    3.555039] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    3.562051] pci 0000:01:00.0: PME# disabled
[    3.566048] pci 0000:01:00.1: [8086:10c9] type 0 class 0x000200
[    3.572018] pci 0000:01:00.1: reg 10: [mem 0xfba40000-0xfba5ffff]
[    3.578014] pci 0000:01:00.1: reg 14: [mem 0xfba20000-0xfba3ffff]
[    3.584013] pci 0000:01:00.1: reg 18: [io  0xe000-0xe01f]
[    3.590014] pci 0000:01:00.1: reg 1c: [mem 0xfbb40000-0xfbb43fff]
[    3.596032] pci 0000:01:00.1: reg 30: [mem 0xfba00000-0xfba1ffff pref]
[    3.603039] pci 0000:01:00.1: PME# supported from D0 D3hot D3cold
[    3.609007] pci 0000:01:00.1: PME# disabled
[    3.613022] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    3.619007] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    3.625007] pci 0000:00:01.0:   bridge window [mem 0xfba00000-0xfbbfffff]
[    3.632009] pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    3.640050] pci 0000:00:03.0: PCI bridge to [bus 03-03]
[    3.646019] pci 0000:00:03.0:   bridge window [io  0xf000-0x0000] (disabled)
[    3.653007] pci 0000:00:03.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    3.661008] pci 0000:00:03.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    3.669049] pci 0000:00:05.0: PCI bridge to [bus 04-04]
[    3.674006] pci 0000:00:05.0:   bridge window [io  0xf000-0x0000] (disabled)
[    3.682060] pci 0000:00:05.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    3.690052] pci 0000:00:05.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    3.698050] pci 0000:00:07.0: PCI bridge to [bus 05-05]
[    3.703006] pci 0000:00:07.0:   bridge window [io  0xf000-0x0000] (disabled)
[    3.711016] pci 0000:00:07.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    3.718007] pci 0000:00:07.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    3.727063] pci 0000:06:00.0: [8086:0329] type 1 class 0x000604
[    3.733023] pci 0000:06:00.0: PXH quirk detected; SHPC device MSI disabled
[    3.740061] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    3.746006] pci 0000:06:00.0: PME# disabled
[    3.750027] pci 0000:06:00.2: [8086:032a] type 1 class 0x000604
[    3.757023] pci 0000:06:00.2: PXH quirk detected; SHPC device MSI disabled
[    3.764087] pci 0000:06:00.2: PME# supported from D0 D3hot D3cold
[    3.770007] pci 0000:06:00.2: PME# disabled
[    3.774023] pci 0000:00:09.0: PCI bridge to [bus 06-08]
[    3.780008] pci 0000:00:09.0:   bridge window [io  0xd000-0xdfff]
[    3.786006] pci 0000:00:09.0:   bridge window [mem 0xfb700000-0xfb9fffff]
[    3.793008] pci 0000:00:09.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    3.801080] pci 0000:06:00.0: PCI bridge to [bus 07-07]
[    3.807013] pci 0000:06:00.0:   bridge window [io  0xf000-0x0000] (disabled)
[    3.814008] pci 0000:06:00.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    3.822008] pci 0000:06:00.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    3.830060] pci 0000:08:01.0: [8086:1229] type 0 class 0x000200
[    3.836022] pci 0000:08:01.0: reg 10: [mem 0xfb900000-0xfb900fff]
[    3.842015] pci 0000:08:01.0: reg 14: [io  0xd000-0xd03f]
[    3.848015] pci 0000:08:01.0: reg 18: [mem 0xfb800000-0xfb8fffff]
[    3.854042] pci 0000:08:01.0: reg 30: [mem 0xfb700000-0xfb7fffff pref]
[    3.861024] pci 0000:08:01.0: supports D1 D2
[    3.865005] pci 0000:08:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    3.872008] pci 0000:08:01.0: PME# disabled
[    3.876054] pci 0000:06:00.2: PCI bridge to [bus 08-08]
[    3.882008] pci 0000:06:00.2:   bridge window [io  0xd000-0xdfff]
[    3.888007] pci 0000:06:00.2:   bridge window [mem 0xfb700000-0xfb9fffff]
[    3.895009] pci 0000:06:00.2:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    3.903081] pci 0000:09:00.0: [1000:0058] type 0 class 0x000100
[    3.909020] pci 0000:09:00.0: reg 10: [io  0xc000-0xc0ff]
[    3.915021] pci 0000:09:00.0: reg 14: [mem 0xfb610000-0xfb613fff 64bit]
[    3.922022] pci 0000:09:00.0: reg 1c: [mem 0xfb600000-0xfb60ffff 64bit]
[    3.928026] pci 0000:09:00.0: reg 30: [mem 0xfb400000-0xfb5fffff pref]
[    3.935039] pci 0000:09:00.0: supports D1 D2
[    3.939022] pci 0000:00:1c.0: PCI bridge to [bus 09-09]
[    3.945007] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    3.951007] pci 0000:00:1c.0:   bridge window [mem 0xfb400000-0xfb6fffff]
[    3.958009] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    3.966077] pci 0000:0a:00.0: [197b:2368] type 0 class 0x000101
[    3.972025] pci 0000:0a:00.0: reg 10: [io  0xb040-0xb047]
[    3.978019] pci 0000:0a:00.0: reg 14: [io  0xb030-0xb033]
[    3.983018] pci 0000:0a:00.0: reg 18: [io  0xb020-0xb027]
[    3.989019] pci 0000:0a:00.0: reg 1c: [io  0xb010-0xb013]
[    3.994019] pci 0000:0a:00.0: reg 20: [io  0xb000-0xb00f]
[    4.000032] pci 0000:0a:00.0: reg 30: [mem 0xfbd00000-0xfbd0ffff pref]
[    4.006086] pci 0000:00:1c.4: PCI bridge to [bus 0a-0a]
[    4.012007] pci 0000:00:1c.4:   bridge window [io  0xb000-0xbfff]
[    4.018008] pci 0000:00:1c.4:   bridge window [mem 0xfbd00000-0xfbdfffff]
[    4.025010] pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    4.033050] pci 0000:0b:01.0: [1002:515e] type 0 class 0x000300
[    4.039023] pci 0000:0b:01.0: reg 10: [mem 0xf0000000-0xf7ffffff pref]
[    4.046014] pci 0000:0b:01.0: reg 14: [io  0xa000-0xa0ff]
[    4.052084] pci 0000:0b:01.0: reg 18: [mem 0xfbc20000-0xfbc2ffff]
[    4.058043] pci 0000:0b:01.0: reg 30: [mem 0xfbc00000-0xfbc1ffff pref]
[    4.065091] pci 0000:0b:01.0: supports D1 D2
[    4.069057] pci 0000:00:1e.0: PCI bridge to [bus 0b-0b] (subtractive decode)
[    4.076006] pci 0000:00:1e.0:   bridge window [io  0xa000-0xafff]
[    4.082006] pci 0000:00:1e.0:   bridge window [mem 0xfbc00000-0xfbcfffff]
[    4.089009] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
[    4.097006] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    4.105007] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    4.113005] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    4.122006] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xffffffff] (subtractive decode)
[    4.131046] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    4.139137] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
[    4.146096] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    4.152191] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    4.159260] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE9._PRT]
[    4.166198] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE9.PXHA._PRT]
[    4.173307] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE9.PXHB._PRT]
[    4.267232] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    4.275134] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 15)
[    4.283108] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15)
[    4.290600] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 10 11 12 14 15)
[    4.298509] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0
[    4.306461] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0
[    4.314472] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0
[    4.322465] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *10 11 12 14 15)
[    4.331171] vgaarb: device added: PCI:0000:0b:01.0,decodes=io+mem,owns=io+mem,locks=none
[    4.339006] vgaarb: loaded
[    4.343159] usbcore: registered new interface driver usbfs
[    4.349078] usbcore: registered new interface driver hub
[    4.355154] usbcore: registered new device driver usb
[    4.363177] wmi: Mapper loaded
[    4.366073] Advanced Linux Sound Architecture Driver Version 1.0.23.
[    4.373013] PCI: Using ACPI for IRQ routing
[    4.377007] PCI: pci_cache_line_size set to 64 bytes
[    4.382255] reserve RAM buffer: 000000000009c400 - 000000000009ffff
[    4.389012] reserve RAM buffer: 00000000bf30b000 - 00000000bfffffff
[    4.395020] reserve RAM buffer: 00000000bf3de000 - 00000000bfffffff
[    4.402017] reserve RAM buffer: 00000000bf800000 - 00000000bfffffff
[    4.409132] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    4.415291] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    4.423012] Switching to clocksource hpet
[    4.428481] Warning: could not register all branches stats
[    4.434091] Warning: could not register annotated branches stats
[    4.475533] pnp: PnP ACPI init
[    4.478730] ACPI: bus type pnp registered
[    4.483091] pnp 00:00: [bus 00-ff]
[    4.486603] pnp 00:00: [io  0x0cf8-0x0cff]
[    4.490804] pnp 00:00: [io  0x0000-0x0cf7 window]
[    4.495605] pnp 00:00: [io  0x0d00-0xffff window]
[    4.500406] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    4.505903] pnp 00:00: [mem 0x00000000 window]
[    4.510451] pnp 00:00: [mem 0xc0000000-0xffffffff window]
[    4.516463] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    4.523884] pnp 00:01: [mem 0xfc000000-0xfcffffff]
[    4.528777] pnp 00:01: [mem 0xfd000000-0xfdffffff]
[    4.533671] pnp 00:01: [mem 0xfe000000-0xfe9fffff]
[    4.538569] pnp 00:01: [mem 0xfea00000-0xfea0001f]
[    4.543466] pnp 00:01: [mem 0xfeb00000-0xfebfffff]
[    4.548360] pnp 00:01: [mem 0xfed00400-0xfed3ffff]
[    4.553252] pnp 00:01: [mem 0xfed45000-0xfedfffff]
[    4.558649] pnp 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[    4.565965] pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
[    4.571992] pnp 00:02: [io  0x0290-0x029f]
[    4.576198] pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
[    4.582224] pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
[    4.588249] pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
[    4.594817] pnp 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    4.601551] pnp 00:03: [io  0x0060]
[    4.605145] pnp 00:03: [io  0x0064]
[    4.608742] pnp 00:03: [irq 1]
[    4.612268] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    4.619803] pnp 00:04: [irq 12]
[    4.623350] pnp 00:04: Plug and Play ACPI device, IDs PNP0f03 PNP0f13 (active)
[    4.635327] pnp 00:05: [io  0x03f8-0x03ff]
[    4.641123] pnp 00:05: [irq 4]
[    4.644302] pnp 00:05: [dma 0 disabled]
[    4.648794] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    4.658238] pnp 00:06: [io  0x02f8-0x02ff]
[    4.662450] pnp 00:06: [irq 3]
[    4.665603] pnp 00:06: [dma 0 disabled]
[    4.670108] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    4.678129] pnp 00:07: [dma 4]
[    4.681292] pnp 00:07: [io  0x0000-0x000f]
[    4.685496] pnp 00:07: [io  0x0081-0x0083]
[    4.689701] pnp 00:07: [io  0x0087]
[    4.693295] pnp 00:07: [io  0x0089-0x008b]
[    4.697498] pnp 00:07: [io  0x008f]
[    4.701085] pnp 00:07: [io  0x00c0-0x00df]
[    4.705685] pnp 00:07: Plug and Play ACPI device, IDs PNP0200 (active)
[    4.712348] pnp 00:08: [io  0x0070-0x0071]
[    4.716553] pnp 00:08: [irq 8]
[    4.720144] pnp 00:08: Plug and Play ACPI device, IDs PNP0b00 (active)
[    4.726807] pnp 00:09: [io  0x0061]
[    4.730732] kworker/u:0 used greatest stack depth: 5352 bytes left
[    4.730785] pnp 00:09: Plug and Play ACPI device, IDs PNP0800 (active)
[    4.730885] pnp 00:0a: [io  0x0010-0x001f]
[    4.730888] pnp 00:0a: [io  0x0022-0x003f]
[    4.730893] pnp 00:0a: [io  0x0044-0x005f]
[    4.730896] pnp 00:0a: [io  0x0062-0x0063]
[    4.730900] pnp 00:0a: [io  0x0065-0x006f]
[    4.730904] pnp 00:0a: [io  0x0072-0x007f]
[    4.730908] pnp 00:0a: [io  0x0080]
[    4.730911] pnp 00:0a: [io  0x0084-0x0086]
[    4.730915] pnp 00:0a: [io  0x0088]
[    4.730919] pnp 00:0a: [io  0x008c-0x008e]
[    4.730922] pnp 00:0a: [io  0x0090-0x009f]
[    4.730926] pnp 00:0a: [io  0x00a2-0x00bf]
[    4.730929] pnp 00:0a: [io  0x00e0-0x00ef]
[    4.730934] pnp 00:0a: [io  0x04d0-0x04d1]
[    4.731781] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    4.731835] pnp 00:0b: [io  0x00f0-0x00ff]
[    4.731848] pnp 00:0b: [irq 13]
[    4.732371] pnp 00:0b: Plug and Play ACPI device, IDs PNP0c04 (active)
[    4.734333] pnp 00:0c: [io  0x0400-0x047f]
[    4.734339] pnp 00:0c: [io  0x1180-0x119f]
[    4.734346] pnp 00:0c: [io  0x0500-0x057f]
[    4.734353] pnp 00:0c: [mem 0xfed1c000-0xfed1ffff]
[    4.734361] pnp 00:0c: [mem 0xfec00000-0xfecfffff]
[    4.734368] pnp 00:0c: [mem 0xff000000-0xffffffff]
[    4.735456] pnp 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
[    4.736869] pnp 00:0d: [mem 0xfed00000-0xfed003ff]
[    4.737700] pnp 00:0d: Plug and Play ACPI device, IDs PNP0103 (active)
[    4.740380] pnp: PnP ACPI: found 14 devices
[    4.740387] ACPI: ACPI bus type pnp unregistered
[    4.740459] system 00:01: [mem 0xfc000000-0xfcffffff] has been reserved
[    4.740471] system 00:01: [mem 0xfd000000-0xfdffffff] has been reserved
[    4.740483] system 00:01: [mem 0xfe000000-0xfe9fffff] has been reserved
[    4.740496] system 00:01: [mem 0xfea00000-0xfea0001f] has been reserved
[    4.740508] system 00:01: [mem 0xfeb00000-0xfebfffff] has been reserved
[    4.740524] system 00:01: [mem 0xfed00400-0xfed3ffff] could not be reserved
[    4.740535] system 00:01: [mem 0xfed45000-0xfedfffff] has been reserved
[    4.740836] system 00:02: [io  0x0290-0x029f] has been reserved
[    4.740881] system 00:0a: [io  0x04d0-0x04d1] has been reserved
[    4.740917] system 00:0c: [io  0x0400-0x047f] has been reserved
[    4.740928] system 00:0c: [io  0x1180-0x119f] has been reserved
[    4.740941] system 00:0c: [io  0x0500-0x057f] could not be reserved
[    4.740953] system 00:0c: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    4.740969] system 00:0c: [mem 0xfec00000-0xfecfffff] could not be reserved
[    4.740980] system 00:0c: [mem 0xff000000-0xffffffff] has been reserved
[    4.791497] pci 0000:00:1c.0: BAR 9: assigned [mem 0xfee00000-0xfeffffff 64bit pref]
[    4.791511] pci 0000:00:1c.4: BAR 9: assigned [mem 0xfb200000-0xfb3fffff 64bit pref]
[    4.791520] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    4.791530] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    4.791544] pci 0000:00:01.0:   bridge window [mem 0xfba00000-0xfbbfffff]
[    4.791555] pci 0000:00:01.0:   bridge window [mem pref disabled]
[    4.791571] pci 0000:00:03.0: PCI bridge to [bus 03-03]
[    4.791577] pci 0000:00:03.0:   bridge window [io  disabled]
[    4.791589] pci 0000:00:03.0:   bridge window [mem disabled]
[    4.791599] pci 0000:00:03.0:   bridge window [mem pref disabled]
[    4.791616] pci 0000:00:05.0: PCI bridge to [bus 04-04]
[    4.791621] pci 0000:00:05.0:   bridge window [io  disabled]
[    4.791633] pci 0000:00:05.0:   bridge window [mem disabled]
[    4.791644] pci 0000:00:05.0:   bridge window [mem pref disabled]
[    4.791660] pci 0000:00:07.0: PCI bridge to [bus 05-05]
[    4.791666] pci 0000:00:07.0:   bridge window [io  disabled]
[    4.791680] pci 0000:00:07.0:   bridge window [mem disabled]
[    4.791690] pci 0000:00:07.0:   bridge window [mem pref disabled]
[    4.791706] pci 0000:06:00.0: PCI bridge to [bus 07-07]
[    4.791711] pci 0000:06:00.0:   bridge window [io  disabled]
[    4.791725] pci 0000:06:00.0:   bridge window [mem disabled]
[    4.791735] pci 0000:06:00.0:   bridge window [mem pref disabled]
[    4.791753] pci 0000:06:00.2: PCI bridge to [bus 08-08]
[    4.791761] pci 0000:06:00.2:   bridge window [io  0xd000-0xdfff]
[    4.791776] pci 0000:06:00.2:   bridge window [mem 0xfb700000-0xfb9fffff]
[    4.791785] pci 0000:06:00.2:   bridge window [mem pref disabled]
[    4.791802] pci 0000:00:09.0: PCI bridge to [bus 06-08]
[    4.791813] pci 0000:00:09.0:   bridge window [io  0xd000-0xdfff]
[    4.791826] pci 0000:00:09.0:   bridge window [mem 0xfb700000-0xfb9fffff]
[    4.791837] pci 0000:00:09.0:   bridge window [mem pref disabled]
[    4.791854] pci 0000:00:1c.0: PCI bridge to [bus 09-09]
[    4.791862] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    4.791877] pci 0000:00:1c.0:   bridge window [mem 0xfb400000-0xfb6fffff]
[    4.791888] pci 0000:00:1c.0:   bridge window [mem 0xfee00000-0xfeffffff 64bit pref]
[    4.791907] pci 0000:00:1c.4: PCI bridge to [bus 0a-0a]
[    4.791917] pci 0000:00:1c.4:   bridge window [io  0xb000-0xbfff]
[    4.791933] pci 0000:00:1c.4:   bridge window [mem 0xfbd00000-0xfbdfffff]
[    4.791946] pci 0000:00:1c.4:   bridge window [mem 0xfb200000-0xfb3fffff 64bit pref]
[    4.791964] pci 0000:00:1e.0: PCI bridge to [bus 0b-0b]
[    4.791975] pci 0000:00:1e.0:   bridge window [io  0xa000-0xafff]
[    4.791989] pci 0000:00:1e.0:   bridge window [mem 0xfbc00000-0xfbcfffff]
[    4.792048] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
[    4.792132] pci 0000:00:01.0: PCI INT A -> GSI 76 (level, low) -> IRQ 76
[    4.792145] pci 0000:00:01.0: setting latency timer to 64
[    4.792186] pci 0000:00:03.0: PCI INT A -> GSI 72 (level, low) -> IRQ 72
[    4.792199] pci 0000:00:03.0: setting latency timer to 64
[    4.792242] pci 0000:00:05.0: PCI INT A -> GSI 74 (level, low) -> IRQ 74
[    4.792255] pci 0000:00:05.0: setting latency timer to 64
[    4.792297] pci 0000:00:07.0: PCI INT A -> GSI 78 (level, low) -> IRQ 78
[    4.792312] pci 0000:00:07.0: setting latency timer to 64
[    4.792357] pci 0000:00:09.0: PCI INT A -> GSI 80 (level, low) -> IRQ 80
[    4.792368] pci 0000:00:09.0: setting latency timer to 64
[    4.792398] pci 0000:06:00.0: setting latency timer to 64
[    4.792425] pci 0000:06:00.2: setting latency timer to 64
[    4.792466] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    4.792478] pci 0000:00:1c.0: setting latency timer to 64
[    4.792503] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    4.792517] pci 0000:00:1c.4: setting latency timer to 64
[    4.792538] pci 0000:00:1e.0: setting latency timer to 64
[    4.792549] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    4.792555] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    4.792561] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    4.792567] pci_bus 0000:00: resource 7 [mem 0xc0000000-0xffffffff]
[    4.792574] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    4.792581] pci_bus 0000:01: resource 1 [mem 0xfba00000-0xfbbfffff]
[    4.792589] pci_bus 0000:06: resource 0 [io  0xd000-0xdfff]
[    4.792595] pci_bus 0000:06: resource 1 [mem 0xfb700000-0xfb9fffff]
[    4.792601] pci_bus 0000:08: resource 0 [io  0xd000-0xdfff]
[    4.792607] pci_bus 0000:08: resource 1 [mem 0xfb700000-0xfb9fffff]
[    4.792613] pci_bus 0000:09: resource 0 [io  0xc000-0xcfff]
[    4.792619] pci_bus 0000:09: resource 1 [mem 0xfb400000-0xfb6fffff]
[    4.792625] pci_bus 0000:09: resource 2 [mem 0xfee00000-0xfeffffff 64bit pref]
[    4.792632] pci_bus 0000:0a: resource 0 [io  0xb000-0xbfff]
[    4.792639] pci_bus 0000:0a: resource 1 [mem 0xfbd00000-0xfbdfffff]
[    4.792646] pci_bus 0000:0a: resource 2 [mem 0xfb200000-0xfb3fffff 64bit pref]
[    4.792652] pci_bus 0000:0b: resource 0 [io  0xa000-0xafff]
[    4.792658] pci_bus 0000:0b: resource 1 [mem 0xfbc00000-0xfbcfffff]
[    4.792665] pci_bus 0000:0b: resource 2 [mem 0xf0000000-0xf7ffffff 64bit pref]
[    4.792672] pci_bus 0000:0b: resource 4 [io  0x0000-0x0cf7]
[    4.792679] pci_bus 0000:0b: resource 5 [io  0x0d00-0xffff]
[    4.792684] pci_bus 0000:0b: resource 6 [mem 0x000a0000-0x000bffff]
[    4.792690] pci_bus 0000:0b: resource 7 [mem 0xc0000000-0xffffffff]
[    4.792816] NET: Registered protocol family 2
[    4.797820] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    4.809425] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    4.817175] TCP bind hash table entries: 65536 (order: 10, 5242880 bytes)
[    4.819180] TCP: Hash tables configured (established 524288 bind 65536)
[    4.819189] TCP reno registered
[    4.820949] UDP hash table entries: 8192 (order: 8, 1572864 bytes)
[    4.823252] UDP-Lite hash table entries: 8192 (order: 8, 1572864 bytes)
[    4.825396] NET: Registered protocol family 1
[    4.826619] RPC: Registered udp transport module.
[    4.826626] RPC: Registered tcp transport module.
[    4.826632] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    4.826873] pci 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x003f
[    4.826880] pci 0000:00:1a.0: Performing full reset
[    4.826921] pci 0000:00:1a.2: uhci_check_and_reset_hc: legsup = 0x003f
[    4.826927] pci 0000:00:1a.2: Performing full reset
[    5.574610] pci 0000:00:1a.7: EHCI: BIOS handoff
[    5.601192] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x103f
[    5.607834] pci 0000:00:1d.0: Performing full reset
[    5.612839] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x003f
[    5.619470] pci 0000:00:1d.1: Performing full reset
[    5.624479] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x003f
[    5.631104] pci 0000:00:1d.2: Performing full reset
[    5.637800] pci 0000:00:1d.7: EHCI: BIOS handoff
[    5.664397] pci 0000:0b:01.0: Boot video device
[    5.669048] PCI: CLS 64 bytes, default 64
[    5.673314] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    5.679862] Placing 64MB software IO TLB between ffff8800b7800000 - ffff8800bb800000
[    5.687780] software IO TLB at phys 0xb7800000 - 0xbb800000
[    5.739790] Machine check injector initialized
[    5.765970] microcode: CPU0 sig=0x206c1, pf=0x1, revision=0x3
[    5.771837] microcode: CPU1 sig=0x206c1, pf=0x1, revision=0x3
[    5.777707] microcode: CPU2 sig=0x206c1, pf=0x1, revision=0x3
[    5.783571] microcode: CPU3 sig=0x206c1, pf=0x1, revision=0x3
[    5.789437] microcode: CPU4 sig=0x206c1, pf=0x1, revision=0x3
[    5.795297] microcode: CPU5 sig=0x206c1, pf=0x1, revision=0x3
[    5.801152] microcode: CPU6 sig=0x206c1, pf=0x1, revision=0x3
[    5.807028] microcode: CPU7 sig=0x206c1, pf=0x1, revision=0x3
[    5.812886] microcode: CPU8 sig=0x206c1, pf=0x1, revision=0x3
[    5.818744] microcode: CPU9 sig=0x206c1, pf=0x1, revision=0x3
[    5.824594] microcode: CPU10 sig=0x206c1, pf=0x1, revision=0x3
[    5.830529] microcode: CPU11 sig=0x206c1, pf=0x1, revision=0x3
[    5.836471] microcode: CPU12 sig=0x206c1, pf=0x1, revision=0x3
[    5.842418] microcode: CPU13 sig=0x206c1, pf=0x1, revision=0x3
[    5.848491] microcode: CPU14 sig=0x206c1, pf=0x1, revision=0x3
[    5.854441] microcode: CPU15 sig=0x206c1, pf=0x1, revision=0x3
[    5.860406] microcode: CPU16 sig=0x206c1, pf=0x1, revision=0x3
[    5.866358] microcode: CPU17 sig=0x206c1, pf=0x1, revision=0x3
[    5.872315] microcode: CPU18 sig=0x206c1, pf=0x1, revision=0x3
[    5.878263] microcode: CPU19 sig=0x206c1, pf=0x1, revision=0x3
[    5.884205] microcode: CPU20 sig=0x206c1, pf=0x1, revision=0x3
[    5.890150] microcode: CPU21 sig=0x206c1, pf=0x1, revision=0x3
[    5.896086] microcode: CPU22 sig=0x206c1, pf=0x1, revision=0x3
[    5.902185] microcode: CPU23 sig=0x206c1, pf=0x1, revision=0x3
[    5.908358] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    5.917320] Scanning for low memory corruption every 60 seconds
[    5.928092] Initializing RT-Tester: OK
[    5.931985] audit: initializing netlink socket (disabled)
[    5.937514] type=2000 audit(1289719444.936:1): initialized
[    5.952089] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    5.960060] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    5.970455] fuse init (API version 7.15)
[    5.974884] msgmni has been set to 31944
[    5.984413] pcieport 0000:00:01.0: ACPI _OSC control granted for 0x1c
[    5.990971] pcieport 0000:00:01.0: setting latency timer to 64
[    5.996951] pcieport 0000:00:01.0: irq 112 for MSI/MSI-X
[    6.004875] pcieport 0000:00:03.0: ACPI _OSC control granted for 0x1c
[    6.011431] pcieport 0000:00:03.0: setting latency timer to 64
[    6.017432] pcieport 0000:00:03.0: irq 113 for MSI/MSI-X
[    6.025457] pcieport 0000:00:05.0: ACPI _OSC control granted for 0x1c
[    6.032023] pcieport 0000:00:05.0: setting latency timer to 64
[    6.037997] pcieport 0000:00:05.0: irq 114 for MSI/MSI-X
[    6.046242] pcieport 0000:00:07.0: ACPI _OSC control granted for 0x1c
[    6.052798] pcieport 0000:00:07.0: setting latency timer to 64
[    6.058798] pcieport 0000:00:07.0: irq 115 for MSI/MSI-X
[    6.067269] pcieport 0000:00:09.0: ACPI _OSC control granted for 0x1c
[    6.073831] pcieport 0000:00:09.0: setting latency timer to 64
[    6.079864] pcieport 0000:00:09.0: irq 116 for MSI/MSI-X
[    6.088025] pcieport 0000:00:1c.0: ACPI _OSC control granted for 0x1c
[    6.094579] pcieport 0000:00:1c.0: setting latency timer to 64
[    6.100593] pcieport 0000:00:1c.0: irq 117 for MSI/MSI-X
[    6.108762] pcieport 0000:00:1c.4: ACPI _OSC control granted for 0x1c
[    6.115329] pcieport 0000:00:1c.4: setting latency timer to 64
[    6.121358] pcieport 0000:00:1c.4: irq 118 for MSI/MSI-X
[    6.127890] aer 0000:00:01.0:pcie02: service driver aer loaded
[    6.134028] aer 0000:00:03.0:pcie02: service driver aer loaded
[    6.140098] aer 0000:00:05.0:pcie02: service driver aer loaded
[    6.146130] aer 0000:00:07.0:pcie02: service driver aer loaded
[    6.152321] aer 0000:00:09.0:pcie02: service driver aer loaded
[    6.158700] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    6.166885] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input0
[    6.175250] ACPI: Sleep Button [SLPB]
[    6.179907] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    6.188275] ACPI: Power Button [PWRB]
[    6.192563] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    6.200142] ACPI: Power Button [PWRF]
[    6.206159] ACPI: acpi_idle registered with cpuidle
[    6.212142] Monitor-Mwait will be used to enter C-3 state
[    6.217760] Monitor-Mwait will be used to enter C-3 state
[    6.555530] Initializing Nozomi driver 2.1d (build date: Nov 14 2010 07:18:48)
[    6.566017] Non-volatile memory driver v1.3
[    6.571399] Linux agpgart interface v0.103
[    6.575867] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    6.584999] Hangcheck: Using getrawmonotonic().
[    6.589896] [drm] Initialized drm 1.1.0 20060810
[    6.594616] [drm:i915_init] *ERROR* drm/i915 can't work without intel_agp module!
[    6.602273] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    6.629407] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    6.673525] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    6.749666] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    6.789313] 00:06: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    6.827825] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k6-NAPI
[    6.834984] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    6.841253] e1000e: Intel(R) PRO/1000 Network Driver - 1.2.7-k2
[    6.847278] e1000e: Copyright (c) 1999 - 2010 Intel Corporation.
[    6.853662] Intel(R) Gigabit Ethernet Network Driver - version 2.1.0-k2
[    6.860385] Copyright (c) 2007-2009 Intel Corporation.
[    6.865892] igb 0000:01:00.0: PCI INT A -> GSI 76 (level, low) -> IRQ 76
[    6.872714] igb 0000:01:00.0: setting latency timer to 64
[    6.878642] igb 0000:01:00.0: irq 119 for MSI/MSI-X
[    6.883632] igb 0000:01:00.0: irq 120 for MSI/MSI-X
[    6.888614] igb 0000:01:00.0: irq 121 for MSI/MSI-X
[    6.893596] igb 0000:01:00.0: irq 122 for MSI/MSI-X
[    6.898580] igb 0000:01:00.0: irq 123 for MSI/MSI-X
[    6.903562] igb 0000:01:00.0: irq 124 for MSI/MSI-X
[    6.908546] igb 0000:01:00.0: irq 125 for MSI/MSI-X
[    6.913529] igb 0000:01:00.0: irq 126 for MSI/MSI-X
[    6.918513] igb 0000:01:00.0: irq 127 for MSI/MSI-X
[    7.104139] igb 0000:01:00.0: Intel(R) Gigabit Ethernet Network Connection
[    7.111151] igb 0000:01:00.0: eth0: (PCIe:2.5Gb/s:Width x4) 00:30:48:cf:17:26
[    7.118460] igb 0000:01:00.0: eth0: PBA No: 0010ff-0ff
[    7.123704] igb 0000:01:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[    7.131472] igb 0000:01:00.1: PCI INT B -> GSI 88 (level, low) -> IRQ 88
[    7.138289] igb 0000:01:00.1: setting latency timer to 64
[    7.144104] igb 0000:01:00.1: irq 128 for MSI/MSI-X
[    7.149094] igb 0000:01:00.1: irq 129 for MSI/MSI-X
[    7.154075] igb 0000:01:00.1: irq 130 for MSI/MSI-X
[    7.159058] igb 0000:01:00.1: irq 131 for MSI/MSI-X
[    7.164045] igb 0000:01:00.1: irq 132 for MSI/MSI-X
[    7.169025] igb 0000:01:00.1: irq 133 for MSI/MSI-X
[    7.174016] igb 0000:01:00.1: irq 134 for MSI/MSI-X
[    7.179010] igb 0000:01:00.1: irq 135 for MSI/MSI-X
[    7.183992] igb 0000:01:00.1: irq 136 for MSI/MSI-X
[    7.358341] igb 0000:01:00.1: Intel(R) Gigabit Ethernet Network Connection
[    7.365323] igb 0000:01:00.1: eth1: (PCIe:2.5Gb/s:Width x4) 00:30:48:cf:17:27
[    7.372640] igb 0000:01:00.1: eth1: PBA No: 0010ff-0ff
[    7.377883] igb 0000:01:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[    7.385839] Intel(R) Virtual Function Network Driver - version 1.0.0-k0
[    7.392559] Copyright (c) 2009 Intel Corporation.
[    7.397601] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 2.0.84-k2
[    7.405599] ixgbe: Copyright (c) 1999-2010 Intel Corporation.
[    7.411691] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
[    7.418933] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[    7.426754] jme: JMicron JMC2XX ethernet driver version 1.0.7
[    7.432849] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    7.439046] e100: Copyright(c) 1999-2006 Intel Corporation
[    7.444707] e100 0000:08:01.0: PCI INT A -> GSI 48 (level, low) -> IRQ 48
[    7.476300] e100 0000:08:01.0: PME# disabled
[    7.482650] e100 0000:08:01.0: eth2: addr 0xfb900000, irq 48, MAC addr 00:0e:0c:7f:c7:3e
[    7.492405] ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
[    7.500623] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.2.6 (Oct 12, 2010)
[    7.508956] sky2: driver version 1.28
[    7.516617] tun: Universal TUN/TAP device driver, 1.6
[    7.521779] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    7.530337] usbcore: registered new interface driver catc
[    7.535846] catc: v2.8:CATC EL1210A NetMate USB Ethernet driver
[    7.542129] usbcore: registered new interface driver kaweth
[    7.547806] pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
[    7.555691] usbcore: registered new interface driver pegasus
[    7.561457] rtl8150: v0.6.2 (2004/08/27):rtl8150 based usb-ethernet driver
[    7.568670] usbcore: registered new interface driver rtl8150
[    7.574902] usbcore: registered new interface driver asix
[    7.581402] usbcore: registered new interface driver cdc_ether
[    7.587580] usbcore: registered new interface driver cdc_eem
[    7.593572] usbcore: registered new interface driver dm9601
[    7.600087] usbcore: registered new interface driver smsc75xx
[    7.606208] usbcore: registered new interface driver smsc95xx
[    7.612302] usbcore: registered new interface driver gl620a
[    7.618466] usbcore: registered new interface driver net1080
[    7.624464] usbcore: registered new interface driver plusb
[    7.630527] usbcore: registered new interface driver rndis_host
[    7.637310] usbcore: registered new interface driver cdc_subset
[    7.643573] usbcore: registered new interface driver zaurus
[    7.649735] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[    7.657531] usbcore: registered new interface driver int51x1
[    7.663304] netconsole: local port 6665
[    7.667238] netconsole: local IP 10.0.0.0
[    7.671362] netconsole: interface 'eth0'
[    7.676969] netconsole: remote port 6666
[    7.680993] netconsole: remote IP 10.239.51.110
[    7.685620] netconsole: remote ethernet address 00:30:48:fe:19:94
[    7.691816] netconsole: device eth0 not up yet, forcing it
[    9.949586] igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[   16.444357] console [netcon0] enabled
[   16.448136] netconsole: network logging started
[   16.454478] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   16.461130] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[   16.467316] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   16.474623] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[   16.480577] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[   16.485950] /home/wfg/cc/linux-2.6/drivers/usb/core/inode.c: creating file 'devices'
[   16.493884] /home/wfg/cc/linux-2.6/drivers/usb/core/inode.c: creating file '001'
[   16.501466] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[   16.513033] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[   16.522182] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[   16.531797] ehci_hcd 0000:00:1a.7: debug port 1
[   16.536449] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[   16.549456] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[   16.556356] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[   16.562578] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfbe23000
[   16.568354] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[   16.581374] ehci_hcd 0000:00:1a.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[   16.595034] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[   16.600995] usb usb1: default language 0x0409
[   16.605489] usb usb1: udev 1, busnum 1, minor = 0
[   16.610303] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   16.617207] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   16.624613] usb usb1: Product: EHCI Host Controller
[   16.629606] usb usb1: Manufacturer: Linux 2.6.37-rc1 ehci_hcd
[   16.635464] usb usb1: SerialNumber: 0000:00:1a.7
[   16.641260] usb usb1: usb_probe_device
[   16.645408] usb usb1: configuration #1 chosen from 1 choice
[   16.651377] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[   16.658079] hub 1-0:1.0: usb_probe_interface
[   16.662740] hub 1-0:1.0: usb_probe_interface - got id
[   16.668175] hub 1-0:1.0: USB hub found
[   16.672053] hub 1-0:1.0: 6 ports detected
[   16.676183] hub 1-0:1.0: standalone hub
[   16.680137] hub 1-0:1.0: no power switching (usb 1.0)
[   16.685302] hub 1-0:1.0: individual port over-current protection
[   16.691424] hub 1-0:1.0: power on to power good time: 20ms
[   16.697037] hub 1-0:1.0: local power source is good
[   16.702027] hub 1-0:1.0: trying to enable port power on non-switchable hub
[   16.709428] /home/wfg/cc/linux-2.6/drivers/usb/core/inode.c: creating file '001'
[   16.717487] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   16.724764] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   16.730714] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   16.736063] /home/wfg/cc/linux-2.6/drivers/usb/core/inode.c: creating file '002'
[   16.743663] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[   16.755034] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[   16.764184] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[   16.773791] ehci_hcd 0000:00:1d.7: debug port 1
[   16.778441] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[   16.791456] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[   16.798358] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[   16.804246] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfbe22000
[   16.810077] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[   16.810083] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0000
[   16.828684] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[   16.843033] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   16.849901] usb usb2: default language 0x0409
[   16.855549] usb usb2: udev 1, busnum 2, minor = 128
[   16.860804] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   16.867969] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   16.875637] usb usb2: Product: EHCI Host Controller
[   16.880897] usb usb2: Manufacturer: Linux 2.6.37-rc1 ehci_hcd
[   16.887027] usb usb2: SerialNumber: 0000:00:1d.7
[   16.892923] usb usb2: usb_probe_device
[   16.896796] usb usb2: configuration #1 chosen from 1 choice
[   16.902497] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[   16.908910] hub 2-0:1.0: usb_probe_interface
[   16.913299] hub 2-0:1.0: usb_probe_interface - got id
[   16.918472] hub 2-0:1.0: USB hub found
[   16.922346] hub 2-0:1.0: 6 ports detected
[   16.926470] hub 2-0:1.0: standalone hub
[   16.930420] hub 2-0:1.0: no power switching (usb 1.0)
[   16.935589] hub 2-0:1.0: individual port over-current protection
[   16.941711] hub 2-0:1.0: power on to power good time: 20ms
[   16.947324] hub 2-0:1.0: local power source is good
[   16.952313] hub 2-0:1.0: trying to enable port power on non-switchable hub
[   16.959706] /home/wfg/cc/linux-2.6/drivers/usb/core/inode.c: creating file '001'
[   16.967983] uhci_hcd: USB Universal Host Controller Interface driver
[   16.974513] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   16.981803] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[   16.987757] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   16.993114] /home/wfg/cc/linux-2.6/drivers/usb/core/inode.c: creating file '003'
[   17.000701] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[   17.012034] uhci_hcd 0000:00:1a.0: detected 2 ports
[   17.017034] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[   17.023850] uhci_hcd 0000:00:1a.0: Performing full reset
[   17.029284] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[   17.035438] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000f0c0
[   17.041393] usb usb3: default language 0x0409
[   17.045881] usb usb3: udev 1, busnum 3, minor = 256
[   17.050869] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   17.057775] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   17.065194] ehci_hcd 0000:00:1d.7: GetStatus port:1 status 001803 0  ACK POWER sig=j CSC CONNECT
[   17.074170] hub 2-0:1.0: port 1: status 0501 change 0001
[   17.079627] usb usb3: Product: UHCI Host Controller
[   17.084621] usb usb3: Manufacturer: Linux 2.6.37-rc1 uhci_hcd
[   17.090480] usb usb3: SerialNumber: 0000:00:1a.0
[   17.095849] usb usb3: usb_probe_device
[   17.099719] usb usb3: configuration #1 chosen from 1 choice
[   17.105419] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[   17.111836] hub 3-0:1.0: usb_probe_interface
[   17.116224] hub 3-0:1.0: usb_probe_interface - got id
[   17.121395] hub 3-0:1.0: USB hub found
[   17.125269] hub 3-0:1.0: 2 ports detected
[   17.129393] hub 3-0:1.0: standalone hub
[   17.133343] hub 3-0:1.0: no power switching (usb 1.0)
[   17.138512] hub 3-0:1.0: individual port over-current protection
[   17.144634] hub 3-0:1.0: power on to power good time: 2ms
[   17.150160] hub 3-0:1.0: local power source is good
[   17.155150] hub 3-0:1.0: trying to enable port power on non-switchable hub
[   17.162522] /home/wfg/cc/linux-2.6/drivers/usb/core/inode.c: creating file '001'
[   17.170545] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.0
[   17.176728] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[   17.184024] hub 2-0:1.0: state 7 ports 6 chg 0002 evt 0000
[   17.184028] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[   17.184032] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[   17.184045] /home/wfg/cc/linux-2.6/drivers/usb/core/inode.c: creating file '004'
[   17.184079] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 4
[   17.216030] hub 2-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[   17.223034] uhci_hcd 0000:00:1a.2: detected 2 ports
[   17.228033] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[   17.234851] uhci_hcd 0000:00:1a.2: Performing full reset
[   17.240285] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[   17.246172] uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000f0a0
[   17.252118] usb usb4: default language 0x0409
[   17.256615] usb usb4: udev 1, busnum 4, minor = 384
[   17.261601] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[   17.268532] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   17.273218] ehci_hcd 0000:00:1d.7: port 1 full speed --> companion
[   17.273223] ehci_hcd 0000:00:1d.7: GetStatus port:1 status 003801 0  ACK POWER OWNER sig=j CONNECT
[   17.273231] hub 2-0:1.0: port 1 not reset yet, waiting 50ms
[   17.297018] usb usb4: Product: UHCI Host Controller
[   17.302014] usb usb4: Manufacturer: Linux 2.6.37-rc1 uhci_hcd
[   17.307918] usb usb4: SerialNumber: 0000:00:1a.2
[   17.313955] usb usb4: usb_probe_device
[   17.317827] usb usb4: configuration #1 chosen from 1 choice
[   17.323529] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[   17.324067] ehci_hcd 0000:00:1d.7: GetStatus port:1 status 003002 0  ACK POWER OWNER sig=se0 CSC
[   17.324104] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   17.324108] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0002
[   17.351688] hub 4-0:1.0: usb_probe_interface
[   17.356078] hub 4-0:1.0: usb_probe_interface - got id
[   17.361249] hub 4-0:1.0: USB hub found
[   17.365123] hub 4-0:1.0: 2 ports detected
[   17.369245] hub 4-0:1.0: standalone hub
[   17.373196] hub 4-0:1.0: no power switching (usb 1.0)
[   17.378365] hub 4-0:1.0: individual port over-current protection
[   17.384487] hub 4-0:1.0: power on to power good time: 2ms
[   17.390021] hub 4-0:1.0: local power source is good
[   17.395014] hub 4-0:1.0: trying to enable port power on non-switchable hub
[   17.402390] /home/wfg/cc/linux-2.6/drivers/usb/core/inode.c: creating file '001'
[   17.410090] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.2
[   17.416262] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   17.423520] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   17.429733] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   17.435346] /home/wfg/cc/linux-2.6/drivers/usb/core/inode.c: creating file '005'
[   17.443197] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[   17.455034] uhci_hcd 0000:00:1d.0: detected 2 ports
[   17.460302] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[   17.467384] uhci_hcd 0000:00:1d.0: Performing full reset
[   17.473093] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[   17.479494] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000f080
[   17.485413] usb usb5: default language 0x0409
[   17.489904] usb usb5: udev 1, busnum 5, minor = 512
[   17.494893] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[   17.501800] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   17.509233] usb usb5: Product: UHCI Host Controller
[   17.509239] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   17.519805] usb usb5: Manufacturer: Linux 2.6.37-rc1 uhci_hcd
[   17.525664] usb usb5: SerialNumber: 0000:00:1d.0
[   17.531120] usb usb5: usb_probe_device
[   17.534991] usb usb5: configuration #1 chosen from 1 choice
[   17.540689] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[   17.547238] hub 5-0:1.0: usb_probe_interface
[   17.551632] hub 5-0:1.0: usb_probe_interface - got id
[   17.556796] hub 5-0:1.0: USB hub found
[   17.560670] hub 5-0:1.0: 2 ports detected
[   17.564796] hub 5-0:1.0: standalone hub
[   17.568743] hub 5-0:1.0: no power switching (usb 1.0)
[   17.573914] hub 5-0:1.0: individual port over-current protection
[   17.580037] hub 5-0:1.0: power on to power good time: 2ms
[   17.585562] hub 5-0:1.0: local power source is good
[   17.590550] hub 5-0:1.0: trying to enable port power on non-switchable hub
[   17.597923] /home/wfg/cc/linux-2.6/drivers/usb/core/inode.c: creating file '001'
[   17.605936] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[   17.612099] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   17.619379] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   17.625328] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   17.630681] /home/wfg/cc/linux-2.6/drivers/usb/core/inode.c: creating file '006'
[   17.638260] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[   17.649033] uhci_hcd 0000:00:1d.1: detected 2 ports
[   17.654033] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[   17.660851] uhci_hcd 0000:00:1d.1: Performing full reset
[   17.666284] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[   17.672164] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000f060
[   17.678125] usb usb6: default language 0x0409
[   17.682621] usb usb6: udev 1, busnum 6, minor = 640
[   17.687611] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[   17.694512] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   17.701924] uhci_hcd 0000:00:1d.0: port 1 portsc 009b,00
[   17.707373] hub 5-0:1.0: port 1: status 0101 change 0003
[   17.712819] usb usb6: Product: UHCI Host Controller
[   17.717815] usb usb6: Manufacturer: Linux 2.6.37-rc1 uhci_hcd
[   17.723676] usb usb6: SerialNumber: 0000:00:1d.1
[   17.729391] usb usb6: usb_probe_device
[   17.733259] usb usb6: configuration #1 chosen from 1 choice
[   17.738961] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[   17.745645] hub 6-0:1.0: usb_probe_interface
[   17.750042] hub 6-0:1.0: usb_probe_interface - got id
[   17.755214] hub 6-0:1.0: USB hub found
[   17.759088] hub 6-0:1.0: 2 ports detected
[   17.763213] hub 6-0:1.0: standalone hub
[   17.767161] hub 6-0:1.0: no power switching (usb 1.0)
[   17.772331] hub 6-0:1.0: individual port over-current protection
[   17.778452] hub 6-0:1.0: power on to power good time: 2ms
[   17.783979] hub 6-0:1.0: local power source is good
[   17.788968] hub 6-0:1.0: trying to enable port power on non-switchable hub
[   17.796011] /home/wfg/cc/linux-2.6/drivers/usb/core/inode.c: creating file '001'
[   17.804388] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[   17.810547] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   17.817820] hub 5-0:1.0: state 7 ports 2 chg 0002 evt 0000
[   17.817825] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   17.817830] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   17.817842] /home/wfg/cc/linux-2.6/drivers/usb/core/inode.c: creating file '007'
[   17.817874] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[   17.849820] hub 5-0:1.0: port 1, status 0101, change 0000, 12 Mb/s
[   17.857029] uhci_hcd 0000:00:1d.2: detected 2 ports
[   17.862025] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[   17.868836] uhci_hcd 0000:00:1d.2: Performing full reset
[   17.874270] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[   17.880138] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000f040
[   17.886065] usb usb7: default language 0x0409
[   17.890553] usb usb7: udev 1, busnum 7, minor = 768
[   17.895568] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[   17.902473] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   17.909879] usb usb7: Product: UHCI Host Controller
[   17.914869] usb usb7: Manufacturer: Linux 2.6.37-rc1 uhci_hcd
[   17.920730] usb usb7: SerialNumber: 0000:00:1d.2
[   17.926503] usb usb7: usb_probe_device
[   17.930376] usb usb7: configuration #1 chosen from 1 choice
[   17.936080] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[   17.942533] hub 7-0:1.0: usb_probe_interface
[   17.946925] hub 7-0:1.0: usb_probe_interface - got id
[   17.952091] hub 7-0:1.0: USB hub found
[   17.955999] hub 7-0:1.0: 2 ports detected
[   17.958056] usb 5-1: new full speed USB device using uhci_hcd and address 2
[   17.967202] hub 7-0:1.0: standalone hub
[   17.971152] hub 7-0:1.0: no power switching (usb 1.0)
[   17.976320] hub 7-0:1.0: individual port over-current protection
[   17.982443] hub 7-0:1.0: power on to power good time: 2ms
[   17.987969] hub 7-0:1.0: local power source is good
[   17.992956] hub 7-0:1.0: trying to enable port power on non-switchable hub
[   18.000359] /home/wfg/cc/linux-2.6/drivers/usb/core/inode.c: creating file '001'
[   18.008071] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[   18.015070] usbcore: registered new interface driver libusual
[   18.027500] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[   18.038185] serio: i8042 KBD port at 0x60,0x64 irq 1
[   18.043281] serio: i8042 AUX port at 0x60,0x64 irq 12
[   18.051214] mice: PS/2 mouse device common for all mice
[   18.061795] rtc_cmos 00:08: RTC can wake from S4
[   18.073346] rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
[   18.079578] rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
[   18.086398] usb 5-1: ep0 maxpacket = 8
[   18.086907] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
[   18.087925] iTCO_wdt: Found a ICH10R TCO device (Version=2, TCOBASE=0x0460)
[   18.088585] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   18.088594] iTCO_vendor_support: vendor-support=0
[   18.088599] SoftDog: cannot register miscdev on minor=130 (err=-16)
[   18.136633] cpuidle: using governor ladder
[   18.140881] usb 5-1: udev 2, busnum 5, minor = 513
[   18.145805] usb 5-1: New USB device found, idVendor=0557, idProduct=8021
[   18.152648] usb 5-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   18.161351] usb 5-1: usb_probe_device
[   18.165165] usb 5-1: configuration #1 chosen from 1 choice
[   18.173451] usb 5-1: adding 5-1:1.0 (config #1, interface 0)
[   18.179789] hub 5-1:1.0: usb_probe_interface
[   18.184205] hub 5-1:1.0: usb_probe_interface - got id
[   18.189403] hub 5-1:1.0: USB hub found
[   18.194548] hub 5-1:1.0: 4 ports detected
[   18.199052] hub 5-1:1.0: standalone hub
[   18.203062] hub 5-1:1.0: individual port power switching
[   18.204058] usb usb3: suspend_rh (auto-stop)
[   18.204737] cpuidle: using governor menu
[   18.204741] ioatdma: Intel(R) QuickData Technology Driver 4.00
[   18.204789] ioatdma 0000:00:16.0: can't derive routing for PCI INT A
[   18.204792] ioatdma 0000:00:16.0: PCI INT A: no GSI
[   18.204832] ioatdma 0000:00:16.0: setting latency timer to 64
[   18.204988] ioatdma 0000:00:16.0: irq 137 for MSI/MSI-X
[   18.245691] hub 5-1:1.0: individual port over-current protection
[   18.248483] igb 0000:01:00.0: DCA enabled
[   18.249456] igb 0000:01:00.1: DCA enabled
[   18.249508] ioatdma 0000:00:16.1: can't derive routing for PCI INT B
[   18.249512] ioatdma 0000:00:16.1: PCI INT B: no GSI
[   18.249548] ioatdma 0000:00:16.1: setting latency timer to 64
[   18.249709] ioatdma 0000:00:16.1: irq 138 for MSI/MSI-X
[   18.283150] hub 5-1:1.0: power on to power good time: 100ms
[   18.285236] ioatdma 0000:00:16.2: can't derive routing for PCI INT C
[   18.285241] ioatdma 0000:00:16.2: PCI INT C: no GSI
[   18.285280] ioatdma 0000:00:16.2: setting latency timer to 64
[   18.285425] ioatdma 0000:00:16.2: irq 139 for MSI/MSI-X
[   18.313623] ioatdma 0000:00:16.3: can't derive routing for PCI INT D
[   18.314443] hub 5-1:1.0: local power source is good
[   18.314447] hub 5-1:1.0: enabling power on all ports
[   18.318481] /home/wfg/cc/linux-2.6/drivers/usb/core/inode.c: creating file '002'
[   18.318889] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   18.318894] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   18.350479] ioatdma 0000:00:16.3: PCI INT D: no GSI
[   18.355545] ioatdma 0000:00:16.3: setting latency timer to 64
[   18.361531] ioatdma 0000:00:16.3: irq 140 for MSI/MSI-X
[   18.369586] ioatdma 0000:00:16.4: can't derive routing for PCI INT A
[   18.376061] ioatdma 0000:00:16.4: PCI INT A: no GSI
[   18.381135] ioatdma 0000:00:16.4: setting latency timer to 64
[   18.387138] ioatdma 0000:00:16.4: irq 141 for MSI/MSI-X
[   18.394480] ioatdma 0000:00:16.5: can't derive routing for PCI INT B
[   18.400947] ioatdma 0000:00:16.5: PCI INT B: no GSI
[   18.406018] ioatdma 0000:00:16.5: setting latency timer to 64
[   18.412002] ioatdma 0000:00:16.5: irq 142 for MSI/MSI-X
[   18.419494] hub 5-1:1.0: port 1: status 0301 change 0001
[   18.420905] ioatdma 0000:00:16.6: can't derive routing for PCI INT C
[   18.420909] ioatdma 0000:00:16.6: PCI INT C: no GSI
[   18.420947] ioatdma 0000:00:16.6: setting latency timer to 64
[   18.421156] ioatdma 0000:00:16.6: irq 143 for MSI/MSI-X
[   18.450306] ioatdma 0000:00:16.7: can't derive routing for PCI INT D
[   18.454089] usb usb4: suspend_rh (auto-stop)
[   18.461147] ioatdma 0000:00:16.7: PCI INT D: no GSI
[   18.466224] ioatdma 0000:00:16.7: setting latency timer to 64
[   18.472223] ioatdma 0000:00:16.7: irq 144 for MSI/MSI-X
[   18.483590] usbcore: registered new interface driver usbhid
[   18.489275] usbhid: USB HID core driver
[   18.495856] dell-wmi: No known WMI GUID found
[   18.500333] acer-wmi: Acer Laptop ACPI-WMI Extras
[   18.505162] acer-wmi: No or unsupported WMI interface, unable to load
[   18.514234] ALSA device list:
[   18.517319]   No soundcards found.
[   18.521391] oprofile: using NMI interrupt.
[   18.525689] netem: version 1.2
[   18.528854] Netfilter messages via NETLINK v0.30.
[   18.533691] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   18.540949] ctnetlink v0.93: registering with nfnetlink.
[   18.546413] NF_TPROXY: Transparent proxy support initialized, version 4.1.0
[   18.552052] uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 128, phase 0, 12 us
[   18.552075] hub 5-1:1.0: state 7 ports 4 chg 0002 evt 0000
[   18.554498] hub 5-1:1.0: port 1, status 0301, change 0000, 1.5 Mb/s
[   18.574000] NF_TPROXY: Copyright (c) 2006-2007 BalaBit IT Ltd.
[   18.581244] xt_time: kernel timezone is -0000
[   18.587733] ip_tables: (C) 2000-2006 Netfilter Core Team
[   18.594750] ipt_CLUSTERIP: ClusterIP Version 0.8 loaded successfully
[   18.601285] arp_tables: (C) 2002 David S. Miller
[   18.606491] TCP bic registered
[   18.609953] TCP cubic registered
[   18.613583] TCP westwood registered
[   18.617474] TCP highspeed registered
[   18.619495] usb 5-1.1: new low speed USB device using uhci_hcd and address 3
[   18.628886] TCP hybla registered
[   18.632553] TCP htcp registered
[   18.636089] TCP vegas registered
[   18.639713] TCP veno registered
[   18.643263] TCP scalable registered
[   18.647149] TCP lp registered
[   18.650517] TCP yeah registered
[   18.654058] TCP illinois registered
[   18.657949] Initializing XFRM netlink socket
[   18.662652] NET: Registered protocol family 17
[   18.667798] NET: Registered protocol family 15
[   18.672429] Bridge firewalling registered
[   18.676546] Ebtables v2.0 registered
[   18.742538] registered taskstats version 1
[   18.750997]   Magic number: 2:198:420
[   18.751527] usb 5-1.1: skipped 1 descriptor after interface
[   18.751535] usb 5-1.1: skipped 1 descriptor after interface
[   18.751541] usb 5-1.1: skipped 1 descriptor after interface
[   18.758510] usb 5-1.1: default language 0x0409
[   18.776884] thermal cooling_device16: hash matches
[   18.782790] rtc_cmos 00:08: setting system clock to 2010-11-14 07:24:20 UTC (1289719460)
[   18.788501] usb 5-1.1: udev 3, busnum 5, minor = 514
[   18.788505] usb 5-1.1: New USB device found, idVendor=0557, idProduct=2261
[   18.788509] usb 5-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   18.788513] usb 5-1.1: Product: CS1716A V1.0.098
[   18.788515] usb 5-1.1: Manufacturer: ATEN International Co. Ltd
[   18.790258] usb 5-1.1: usb_probe_device
[   18.790264] usb 5-1.1: configuration #1 chosen from 1 choice
[   18.794504] usb 5-1.1: adding 5-1.1:1.0 (config #1, interface 0)
[   18.795407] usbhid 5-1.1:1.0: usb_probe_interface
[   18.795412] usbhid 5-1.1:1.0: usb_probe_interface - got id
[   18.857298] input: ATEN International Co. Ltd CS1716A V1.0.098 as /devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1.1/5-1.1:1.0/input/input3
[   18.869778] uhci_hcd 0000:00:1d.0: reserve dev 3 ep81-INT, period 8, phase 4, 118 us
[   18.878520] generic-usb 0003:0557:2261.0001: input: USB HID v1.00 Keyboard [ATEN International Co. Ltd CS1716A V1.0.098] on usb-0000:00:1d.0-1.1/input0
[   18.892653] usb 5-1.1: adding 5-1.1:1.1 (config #1, interface 1)
[   18.899629] usbhid 5-1.1:1.1: usb_probe_interface
[   18.904469] usbhid 5-1.1:1.1: usb_probe_interface - got id
[   18.943449] input: ATEN International Co. Ltd CS1716A V1.0.098 as /devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1.1/5-1.1:1.1/input/input4
[   18.954131] usb usb6: suspend_rh (auto-stop)
[   18.960296] uhci_hcd 0000:00:1d.0: reserve dev 3 ep82-INT, period 8, phase 4, 118 us
[   18.969133] generic-usb 0003:0557:2261.0002: input: USB HID v1.00 Device [ATEN International Co. Ltd CS1716A V1.0.098] on usb-0000:00:1d.0-1.1/input1
[   18.983148] usb 5-1.1: adding 5-1.1:1.2 (config #1, interface 2)
[   18.990029] usbhid 5-1.1:1.2: usb_probe_interface
[   18.994861] usbhid 5-1.1:1.2: usb_probe_interface - got id
[   19.025408] input: ATEN International Co. Ltd CS1716A V1.0.098 as /devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1.1/5-1.1:1.2/input/input5
[   19.039538] generic-usb 0003:0557:2261.0003: input: USB HID v1.10 Mouse [ATEN International Co. Ltd CS1716A V1.0.098] on usb-0000:00:1d.0-1.1/input2
[   19.053502] /home/wfg/cc/linux-2.6/drivers/usb/core/inode.c: creating file '003'
[   19.061510] hub 5-1:1.0: state 7 ports 4 chg 0000 evt 0002
[   19.204140] usb usb7: suspend_rh (auto-stop)
[   79.840691] e100 0000:08:01.0: eth2: Failed to load firmware "e100/d101m_ucode.bin": -2
[   79.849434] IP-Config: Failed to open eth2
[   80.854214] Sending DHCP requests ., OK
[   80.865112] IP-Config: Got DHCP answer from 192.168.1.209, my address is 192.168.1.149
[   81.065823] IP-Config: Complete:
[   81.068929]      device=eth0, addr=192.168.1.149, mask=255.255.255.0, gw=192.168.1.1,
[   81.077074]      host=lkp-ws02, domain=tsp.org, nis-domain=(none),
[   81.083412]      bootserver=192.168.1.209, rootserver=10.239.51.240, rootpath=
[   81.151964] VFS: Mounted root (nfs filesystem) on device 0:14.
[   81.157993] debug: unmapping init memory ffffffff82449000..ffffffff826f1000
INIT: version 2.86 booting
