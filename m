Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934438Ab1JaMUw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 08:20:52 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:50879 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934423Ab1JaMUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 08:20:50 -0400
Date: Mon, 31 Oct 2011 05:19:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: linux-next 20111025: warnings in
 rcu_idle_exit_common()/rcu_idle_enter_common()
Message-ID: <20111031121951.GM6160@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111031082634.GA10348@localhost>
 <20111031095152.GL6160@linux.vnet.ibm.com>
 <20111031104325.GA25808@localhost>
 <20111031114142.GA32555@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111031114142.GA32555@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11103112-5806-0000-0000-00000078C902
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 07:41:42PM +0800, Wu Fengguang wrote:
> On Mon, Oct 31, 2011 at 06:43:25PM +0800, Wu Fengguang wrote:
> > On Mon, Oct 31, 2011 at 05:51:52PM +0800, Paul E. McKenney wrote:
> > > On Mon, Oct 31, 2011 at 04:26:34PM +0800, Wu Fengguang wrote:
> > > > Hi Paul,
> > > >
> > > > I got two warnings in rcutree.c. The last working kernels are
> > > > linux-next 20111014 and linux v3.1.
> > > 
> > > Interesting.  Could you please enable RCU event tracing at boot?
> > 
> > Sorry I cannot...possibly due to another ftrace bug.
> > 
> > > The RCU event tracing is at tracing/events/rcu/enable relative to
> > > the debugfs mount point at runtime, if that helps.
> > 
> > It's exactly that linux next 20111025 (comparing to 20111014) no
> > longer produces all the trace events that made me looking into the
> > dmesg and find the warning from RCU (rather than the expected warning
> > from ftrace).
> > 
> > The trace output is now:
> > 
> >         # tracer: nop
> >         #
> >         # WARNING: FUNCTION TRACING IS CORRUPTED
> >         #          MAY BE MISSING FUNCTION EVENTS
> >         #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> >         #              | |       |          |         |
> > (nothing more)
> 
> I checked the other test box and got the same warnings. Below is the
> full dmesg.
> 
> No single trace output again..

Hmmm...  I wonder if it is too early during boot for tracing to work
correctly.

Gah!  I have rcu/next set ahead to commits that are not supposed to go
upstream yet.  I reset it back to match the stuff that is targeted for
the current merge window.  Still need to find the bug, of course.

Anyone have any idea why the kworker thread might be trying to enter
the idle loop?  The idle_cpu(smp_processor_id()) call believes that
this is not the idle task.  Or does x86 allow non-idle tasks to enter
the idle loop?  Or to be migrated off-CPU?

							Thanx, Paul

> Thanks,
> Fengguang
> 
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.1.0-ioless-full-next-20111025+ (wfg@bee) (gcc version 4.5.0 (GCC) ) #881 SMP Mon Oct 31 01:03:49 CST 2011
> [    0.000000] Command line: nousb hpet=disable run=/home/wfg/ioless-balance_dirty_pages/test-each-fs.sh log_buf_len=8M debug sched_debug apic=debug dynamic_printk drm.debug=6 sysrq_always_enabled panic=10 unknown_nmi_panic=1 nmi_watchdog=panic,lapic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 netconsole=@:/eth0,6666@192.168.1.1/00:30:48:fe:19:95 ip=192.168.1.61:192.168.1.11:192.168.1.1:255.255.255.0:snb:eth0:none nfsroot=192.168.1.11:/nfsroot/wfg,tcp,v3,nocto,nolock,rsize=524288,wsize=524288 rw BOOT_IMAGE=x86_64/vmlinuz-3.1.0-ioless-full-next-20111025+ 
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   Intel GenuineIntel
> [    0.000000]   Centaur CentaurHauls
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009bc00 (usable)
> [    0.000000]  BIOS-e820: 000000000009bc00 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000ab664000 (usable)
> [    0.000000]  BIOS-e820: 00000000ab664000 - 00000000ab821000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000ab821000 - 00000000bea7d000 (usable)
> [    0.000000]  BIOS-e820: 00000000bea7d000 - 00000000beae9000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000beae9000 - 00000000beaf2000 (usable)
> [    0.000000]  BIOS-e820: 00000000beaf2000 - 00000000beb03000 (reserved)
> [    0.000000]  BIOS-e820: 00000000beb03000 - 00000000bed2e000 (usable)
> [    0.000000]  BIOS-e820: 00000000bed2e000 - 00000000bede7000 (reserved)
> [    0.000000]  BIOS-e820: 00000000bede7000 - 00000000bee2f000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000bee2f000 - 00000000bee30000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000bee30000 - 00000000bee9b000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000bee9b000 - 00000000bee9d000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000bee9d000 - 00000000bee9e000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000bee9e000 - 00000000beeb9000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000beeb9000 - 00000000befc1000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000befc1000 - 00000000bf000000 (usable)
> [    0.000000]  BIOS-e820: 00000000bf000000 - 00000000d0000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fed19000 - 00000000fed1a000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000ffa20000 - 0000000100000000 (reserved)
> [    0.000000]  BIOS-e820: 0000000100000000 - 0000000840000000 (usable)
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] DMI 2.6 present.
> [    0.000000] DMI: Intel Corporation SandyBridge Platform/To be filled by O.E.M., BIOS ROMLEYEP.86B.99.99.x020.022420111310 02/24/2011
> [    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
> [    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
> [    0.000000] last_pfn = 0x840000 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-CBFFF write-protect
> [    0.000000]   CC000-E7FFF uncachable
> [    0.000000]   E8000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 000000000000 mask 3FFF80000000 write-back
> [    0.000000]   1 base 000080000000 mask 3FFFC0000000 write-back
> [    0.000000]   2 base 000100000000 mask 3FFF00000000 write-back
> [    0.000000]   3 base 000200000000 mask 3FFE00000000 write-back
> [    0.000000]   4 base 000400000000 mask 3FFC00000000 write-back
> [    0.000000]   5 base 000800000000 mask 3FFFC0000000 write-back
> [    0.000000]   6 base 0000FF800000 mask 3FFFFF800000 write-protect
> [    0.000000]   7 disabled
> [    0.000000]   8 disabled
> [    0.000000]   9 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] last_pfn = 0xbf000 max_arch_pfn = 0x400000000
> [    0.000000] Scan SMP from ffff880000000000 for 1024 bytes.
> [    0.000000] Scan SMP from ffff88000009fc00 for 1024 bytes.
> [    0.000000] Scan SMP from ffff8800000f0000 for 65536 bytes.
> [    0.000000] found SMP MP-table at [ffff8800000fcda0] fcda0
> [    0.000000]   mpc: fc7d0-fcc7c
> [    0.000000] initial memory mapped : 0 - 20000000
> [    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 20480
> [    0.000000] Using GB pages for direct mapping
> [    0.000000] init_memory_mapping: 0000000000000000-00000000bf000000
> [    0.000000]  0000000000 - 00bf000000 page 4k
> [    0.000000] kernel direct mapping tables up to bf000000 @ 1fa06000-20000000
> [    0.000000] init_memory_mapping: 0000000100000000-0000000840000000
> [    0.000000]  0100000000 - 0840000000 page 4k
> [    0.000000] kernel direct mapping tables up to 840000000 @ bb060000-bea7d000
> [    0.000000] log_buf_len: 8388608
> [    0.000000] early log buf free: 256692(97%)
> [    0.000000] ACPI: RSDP 00000000000f0410 00024 (v02  INTEL)
> [    0.000000] ACPI: XSDT 00000000beeb7e18 000AC (v01  INTEL   ROMLEY 06222004 INTL 20090903)
> [    0.000000] ACPI: FACP 00000000beeb6918 000F4 (v04  INTEL   ROMLEY 06222004 INTL 20090903)
> [    0.000000] ACPI: DSDT 00000000bee9e018 16368 (v02  INTEL   ROMLEY 00000099 INTL 20100331)
> [    0.000000] ACPI: FACS 00000000beeb7d40 00040
> [    0.000000] ACPI: APIC 00000000beeb5018 0066A (v03  INTEL   ROMLEY 06222004 INTL 20090903)
> [    0.000000] ACPI: SPMI 00000000beeb8b18 00040 (v05  INTEL   ROMLEY 06222004 INTL 20090903)
> [    0.000000] ACPI: MCFG 00000000beeb8f18 0003C (v01 INTEL  ROMLEY   06222004 INTL 20090903)
> [    0.000000] ACPI: WDDT 00000000beeb8e98 00040 (v01 INTEL  ROMLEY   06222004 INTL 20090903)
> [    0.000000] ACPI: SRAT 00000000bee9c918 002A8 (v03  INTEL   ROMLEY 06222004 INTL 20090903)
> [    0.000000] ACPI: SLIT 00000000beeb8e18 00030 (v01  INTEL   ROMLEY 06222004 INTL 20090903)
> [    0.000000] ACPI: MSCT 00000000bee2ff18 00090 (v01  INTEL   ROMLEY 06222004 INTL 20090903)
> [    0.000000] ACPI: HPET 00000000beeb8d18 00038 (v01 INTL   ROMLEY   06222004 INTL 20090903)
> [    0.000000] ACPI: SSDT 00000000beeb8d98 0002B (v02  INTEL PtidDevc 00001000 INTL 20100331)
> [    0.000000] ACPI: BOOT 00000000beeb8c98 00028 (v01 INTEL  ROMLEY   06222004 INTL 20090903)
> [    0.000000] ACPI: SSDT 00000000bea7d018 6B356 (v02  INTEL    CpuPm 00004000 INTL 20100331)
> [    0.000000] ACPI: DMAR 00000000bee9be18 001B8 (v01 INTEL      RML  00000001 INTL 00000001)
> [    0.000000] ACPI: HEST 00000000bee9cf18 000A8 (v01  INTEL CNPASSDP 00000001 INTL 00000001)
> [    0.000000] ACPI: BERT 00000000beeb8c18 00030 (v01  INTEL CNPASSDP 00000001 INTL 00000001)
> [    0.000000] ACPI: ERST 00000000bee2fa18 00230 (v01  INTEL CNPASSDP 00000001 INTL 00000001)
> [    0.000000] ACPI: EINJ 00000000beeb6d98 00150 (v01  INTEL CNPASSDP 00000001 INTL 00000001)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
> [    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x06 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x07 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x08 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x09 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x0a -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x0b -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x0c -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x0d -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x0e -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x0f -> Node 0
> [    0.000000] SRAT: PXM 1 -> APIC 0x20 -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x21 -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x23 -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x24 -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x25 -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x26 -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x27 -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x28 -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x29 -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x2a -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x2b -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x2c -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x2d -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x2e -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x2f -> Node 1
> [    0.000000] SRAT: Node 0 PXM 0 0-c0000000
> [    0.000000] SRAT: Node 0 PXM 0 100000000-440000000
> [    0.000000] SRAT: Node 1 PXM 1 440000000-840000000
> [    0.000000] NUMA: Initialized distance table, cnt=2
> [    0.000000] NUMA: Node 0 [0,c0000000) + [100000000,440000000) -> [0,440000000)
> [    0.000000] Initmem setup node 0 0000000000000000-0000000440000000
> [    0.000000]   NODE_DATA [000000043fffb000 - 000000043fffffff]
> [    0.000000] Initmem setup node 1 0000000440000000-0000000840000000
> [    0.000000]   NODE_DATA [000000083f7fa000 - 000000083f7fefff]
> [    0.000000]  [ffffea0000000000-ffffea0010ffffff] PMD -> [ffff88042fe00000-ffff88043fdfffff] on node 0
> [    0.000000]  [ffffea0011000000-ffffea0020ffffff] PMD -> [ffff88082ee00000-ffff88083edfffff] on node 1
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA      0x00000010 -> 0x00001000
> [    0.000000]   DMA32    0x00001000 -> 0x00100000
> [    0.000000]   Normal   0x00100000 -> 0x00840000
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[8] active PFN ranges
> [    0.000000]     0: 0x00000010 -> 0x0000009b
> [    0.000000]     0: 0x00000100 -> 0x000ab664
> [    0.000000]     0: 0x000ab821 -> 0x000bea7d
> [    0.000000]     0: 0x000beae9 -> 0x000beaf2
> [    0.000000]     0: 0x000beb03 -> 0x000bed2e
> [    0.000000]     0: 0x000befc1 -> 0x000bf000
> [    0.000000]     0: 0x00100000 -> 0x00440000
> [    0.000000]     1: 0x00440000 -> 0x00840000
> [    0.000000] On node 0 totalpages: 4188862
> [    0.000000]   DMA zone: 64 pages used for memmap
> [    0.000000]   DMA zone: 5 pages reserved
> [    0.000000]   DMA zone: 3910 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 16320 pages used for memmap
> [    0.000000]   DMA32 zone: 760691 pages, LIFO batch:31
> [    0.000000]   Normal zone: 53248 pages used for memmap
> [    0.000000]   Normal zone: 3354624 pages, LIFO batch:31
> [    0.000000] On node 1 totalpages: 4194304
> [    0.000000]   Normal zone: 65536 pages used for memmap
> [    0.000000]   Normal zone: 4128768 pages, LIFO batch:31
> [    0.000000] ACPI: PM-Timer IO Port: 0x408
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
> [    0.000000] ACPI: X2APIC (apic_id[0x00] uid[0x00] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x01] uid[0x01] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x02] uid[0x02] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x03] uid[0x03] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x04] uid[0x04] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x05] uid[0x05] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x06] uid[0x06] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x07] uid[0x07] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x08] uid[0x08] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x09] uid[0x09] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x0a] uid[0x0a] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x0b] uid[0x0b] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x0c] uid[0x0c] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x0d] uid[0x0d] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x0e] uid[0x0e] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x0f] uid[0x0f] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x10] uid[0x10] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x11] uid[0x11] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x12] uid[0x12] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x13] uid[0x13] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x14] uid[0x14] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x15] uid[0x15] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x16] uid[0x16] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x17] uid[0x17] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x18] uid[0x18] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x19] uid[0x19] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x1a] uid[0x1a] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x1b] uid[0x1b] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x1c] uid[0x1c] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x1d] uid[0x1d] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x1e] uid[0x1e] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x1f] uid[0x1f] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x20] uid[0x20] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x21] uid[0x21] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x22] uid[0x22] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x23] uid[0x23] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x24] uid[0x24] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x25] uid[0x25] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x26] uid[0x26] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x27] uid[0x27] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x28] uid[0x28] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x29] uid[0x29] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x2a] uid[0x2a] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x2b] uid[0x2b] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x2c] uid[0x2c] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x2d] uid[0x2d] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x2e] uid[0x2e] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x2f] uid[0x2f] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x30] uid[0x30] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x31] uid[0x31] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x32] uid[0x32] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x33] uid[0x33] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x34] uid[0x34] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x35] uid[0x35] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x36] uid[0x36] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x37] uid[0x37] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x38] uid[0x38] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x39] uid[0x39] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x3a] uid[0x3a] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x3b] uid[0x3b] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x3c] uid[0x3c] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x3d] uid[0x3d] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x3e] uid[0x3e] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: X2APIC (apic_id[0x3f] uid[0x3f] disabled)
> [    0.000000] ACPI: x2apic entry ignored
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x06] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x08] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x0a] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x0c] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x0e] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x20] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x22] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x24] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x26] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x28] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x2a] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x2c] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x2e] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x03] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x05] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x07] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x09] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x0b] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x0d] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x0f] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x21] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x23] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x25] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x27] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x29] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x2b] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x2d] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x2f] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x20] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x21] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x22] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x23] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x24] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x25] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x26] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x27] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x28] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x29] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x2a] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x2b] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x2c] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x2d] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x2e] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x2f] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x30] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x31] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x32] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x33] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x34] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x35] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x36] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x37] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x38] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x39] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x3a] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x3b] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x3c] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x3d] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x3e] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x3f] lapic_id[0xff] disabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec3f000] gsi_base[24])
> [    0.000000] IOAPIC[1]: apic_id 1, version 32, address 0xfec3f000, GSI 24-47
> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec7f000] gsi_base[48])
> [    0.000000] IOAPIC[2]: apic_id 2, version 32, address 0xfec7f000, GSI 48-71
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 0, APIC INT 05
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
> [    0.000000] SMP: Allowing 64 CPUs, 32 hotplug CPUs
> [    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
> [    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec3f000)
> [    0.000000] mapped IOAPIC to ffffffffff5f8000 (fec7f000)
> [    0.000000] nr_irqs_gsi: 88
> [    0.000000] PM: Registered nosave memory: 000000000009b000 - 000000000009c000
> [    0.000000] PM: Registered nosave memory: 000000000009c000 - 00000000000a0000
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
> [    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
> [    0.000000] PM: Registered nosave memory: 00000000ab664000 - 00000000ab821000
> [    0.000000] PM: Registered nosave memory: 00000000bea7d000 - 00000000beae9000
> [    0.000000] PM: Registered nosave memory: 00000000beaf2000 - 00000000beb03000
> [    0.000000] PM: Registered nosave memory: 00000000bed2e000 - 00000000bede7000
> [    0.000000] PM: Registered nosave memory: 00000000bede7000 - 00000000bee2f000
> [    0.000000] PM: Registered nosave memory: 00000000bee2f000 - 00000000bee30000
> [    0.000000] PM: Registered nosave memory: 00000000bee30000 - 00000000bee9b000
> [    0.000000] PM: Registered nosave memory: 00000000bee9b000 - 00000000bee9d000
> [    0.000000] PM: Registered nosave memory: 00000000bee9d000 - 00000000bee9e000
> [    0.000000] PM: Registered nosave memory: 00000000bee9e000 - 00000000beeb9000
> [    0.000000] PM: Registered nosave memory: 00000000beeb9000 - 00000000befc1000
> [    0.000000] PM: Registered nosave memory: 00000000bf000000 - 00000000d0000000
> [    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000fec00000
> [    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
> [    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed19000
> [    0.000000] PM: Registered nosave memory: 00000000fed19000 - 00000000fed1a000
> [    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
> [    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
> [    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
> [    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
> [    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffa20000
> [    0.000000] PM: Registered nosave memory: 00000000ffa20000 - 0000000100000000
> [    0.000000] Allocating PCI resources starting at d0000000 (gap: d0000000:2ec00000)
> [    0.000000] Booting paravirtualized kernel on bare hardware
> [    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:64 nr_node_ids:2
> [    0.000000] PERCPU: Embedded 476 pages/cpu @ffff88042be00000 s1916992 r8192 d24512 u2097152
> [    0.000000] pcpu-alloc: s1916992 r8192 d24512 u2097152 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 00 [0] 01 [0] 02 [0] 03 [0] 04 [0] 05 [0] 06 [0] 07 
> [    0.000000] pcpu-alloc: [0] 16 [0] 17 [0] 18 [0] 19 [0] 20 [0] 21 [0] 22 [0] 23 
> [    0.000000] pcpu-alloc: [0] 32 [0] 34 [0] 36 [0] 38 [0] 40 [0] 42 [0] 44 [0] 46 
> [    0.000000] pcpu-alloc: [0] 48 [0] 50 [0] 52 [0] 54 [0] 56 [0] 58 [0] 60 [0] 62 
> [    0.000000] pcpu-alloc: [1] 08 [1] 09 [1] 10 [1] 11 [1] 12 [1] 13 [1] 14 [1] 15 
> [    0.000000] pcpu-alloc: [1] 24 [1] 25 [1] 26 [1] 27 [1] 28 [1] 29 [1] 30 [1] 31 
> [    0.000000] pcpu-alloc: [1] 33 [1] 35 [1] 37 [1] 39 [1] 41 [1] 43 [1] 45 [1] 47 
> [    0.000000] pcpu-alloc: [1] 49 [1] 51 [1] 53 [1] 55 [1] 57 [1] 59 [1] 61 [1] 63 
> [    0.000000] Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 8247993
> [    0.000000] Policy zone: Normal
> [    0.000000] Kernel command line: nousb hpet=disable run=/home/wfg/ioless-balance_dirty_pages/test-each-fs.sh log_buf_len=8M debug sched_debug apic=debug dynamic_printk drm.debug=6 sysrq_always_enabled panic=10 unknown_nmi_panic=1 nmi_watchdog=panic,lapic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 netconsole=@:/eth0,6666@192.168.1.1/00:30:48:fe:19:95 ip=192.168.1.61:192.168.1.11:192.168.1.1:255.255.255.0:snb:eth0:none nfsroot=192.168.1.11:/nfsroot/wfg,tcp,v3,nocto,nolock,rsize=524288,wsize=524288 rw BOOT_IMAGE=x86_64/vmlinuz-3.1.0-ioless-full-next-20111025+ 
> [    0.000000] sysrq: sysrq always enabled.
> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
> [    0.000000] Memory: 32718244k/34603008k available (9793k kernel code, 1070344k absent, 814420k reserved, 5791k data, 2768k init)
> [    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=64, Nodes=2
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] 	RCU debugfs-based tracing is enabled.
> [    0.000000] NR_IRQS:4352 nr_irqs:2008 16
> [    0.000000] Extended CMOS year: 2000
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] console [ttyS0] enabled
> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.000000] ... MAX_LOCK_DEPTH:          48
> [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
> [    0.000000] ... CLASSHASH_SIZE:          4096
> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
> [    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
> [    0.000000] ... CHAINHASH_SIZE:          16384
> [    0.000000]  memory used by lock dependency info: 6335 kB
> [    0.000000]  per task-struct memory footprint: 2688 bytes
> [    0.000000] allocated 268435456 bytes of page_cgroup
> [    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
> [    0.001000] Fast TSC calibration using PIT
> [    0.002000] Detected 2299.479 MHz processor.
> [    0.000030] Calibrating delay loop (skipped), value calculated using timer frequency.. 4598.95 BogoMIPS (lpj=2299479)
> [    0.012819] pid_max: default: 65536 minimum: 512
> [    0.028810] Dentry cache hash table entries: 4194304 (order: 13, 33554432 bytes)
> [    0.048866] Inode-cache hash table entries: 2097152 (order: 12, 16777216 bytes)
> [    0.070117] Mount-cache hash table entries: 256
> [    0.076447] Initializing cgroup subsys debug
> [    0.081678] Initializing cgroup subsys cpuacct
> [    0.087131] Initializing cgroup subsys memory
> [    0.092545] Initializing cgroup subsys devices
> [    0.097967] Initializing cgroup subsys freezer
> [    0.103563] Initializing cgroup subsys blkio
> [    0.108968] CPU: Physical Processor ID: 0
> [    0.113908] CPU: Processor Core ID: 0
> [    0.118458] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
> [    0.118459] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
> [    0.133955] mce: CPU supports 20 MCE banks
> [    0.139017] CPU0: Thermal monitoring enabled (TM1)
> [    0.144849] using mwait in idle threads.
> [    0.151142] ACPI: Core revision 20110623
> [    0.258874] ftrace: allocating 38070 entries in 150 pages
> [    0.280790] Getting VERSION: 1060015
> [    0.285244] Getting VERSION: 1060015
> [    0.289692] Getting ID: 0
> [    0.293071] Getting ID: 0
> [    0.296453] Switched APIC routing to physical flat.
> [    0.302363] enabled ExtINT on CPU#0
> [    0.307228] ENABLING IO-APIC IRQs
> [    0.311385] init IO_APIC IRQs
> [    0.315155]  apic 0 pin 0 not connected
> [    0.319905] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:0)
> [    0.329594] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:0)
> [    0.339284] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:0)
> [    0.348967] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:0)
> [    0.358651] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:0)
> [    0.368331] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:0)
> [    0.378014] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:0)
> [    0.387695] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:0)
> [    0.397375] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:0)
> [    0.407054] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:0)
> [    0.416930] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:0)
> [    0.426806] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:0)
> [    0.436680] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:0)
> [    0.446557] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:0)
> [    0.456432] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:0)
> [    0.466306]  apic 0 pin 16 not connected
> [    0.471139]  apic 0 pin 17 not connected
> [    0.475972]  apic 0 pin 18 not connected
> [    0.480803]  apic 0 pin 19 not connected
> [    0.485635]  apic 0 pin 20 not connected
> [    0.490468]  apic 0 pin 21 not connected
> [    0.495301]  apic 0 pin 22 not connected
> [    0.500134]  apic 0 pin 23 not connected
> [    0.504974]  apic 1 pin 0 not connected
> [    0.509709]  apic 1 pin 1 not connected
> [    0.514445]  apic 1 pin 2 not connected
> [    0.519179]  apic 1 pin 3 not connected
> [    0.523913]  apic 1 pin 4 not connected
> [    0.528648]  apic 1 pin 5 not connected
> [    0.533382]  apic 1 pin 6 not connected
> [    0.538117]  apic 1 pin 7 not connected
> [    0.542851]  apic 1 pin 8 not connected
> [    0.547587]  apic 1 pin 9 not connected
> [    0.552322]  apic 1 pin 10 not connected
> [    0.557152]  apic 1 pin 11 not connected
> [    0.561983]  apic 1 pin 12 not connected
> [    0.566817]  apic 1 pin 13 not connected
> [    0.571649]  apic 1 pin 14 not connected
> [    0.576480]  apic 1 pin 15 not connected
> [    0.581313]  apic 1 pin 16 not connected
> [    0.586144]  apic 1 pin 17 not connected
> [    0.590976]  apic 1 pin 18 not connected
> [    0.595807]  apic 1 pin 19 not connected
> [    0.600638]  apic 1 pin 20 not connected
> [    0.605471]  apic 1 pin 21 not connected
> [    0.610304]  apic 1 pin 22 not connected
> [    0.615136]  apic 1 pin 23 not connected
> [    0.619968]  apic 2 pin 0 not connected
> [    0.624703]  apic 2 pin 1 not connected
> [    0.629436]  apic 2 pin 2 not connected
> [    0.634170]  apic 2 pin 3 not connected
> [    0.638905]  apic 2 pin 4 not connected
> [    0.643638]  apic 2 pin 5 not connected
> [    0.648373]  apic 2 pin 6 not connected
> [    0.653109]  apic 2 pin 7 not connected
> [    0.657844]  apic 2 pin 8 not connected
> [    0.662580]  apic 2 pin 9 not connected
> [    0.667315]  apic 2 pin 10 not connected
> [    0.672146]  apic 2 pin 11 not connected
> [    0.676978]  apic 2 pin 12 not connected
> [    0.681811]  apic 2 pin 13 not connected
> [    0.686641]  apic 2 pin 14 not connected
> [    0.691471]  apic 2 pin 15 not connected
> [    0.696302]  apic 2 pin 16 not connected
> [    0.701133]  apic 2 pin 17 not connected
> [    0.705966]  apic 2 pin 18 not connected
> [    0.710798]  apic 2 pin 19 not connected
> [    0.715630]  apic 2 pin 20 not connected
> [    0.720461]  apic 2 pin 21 not connected
> [    0.725291]  apic 2 pin 22 not connected
> [    0.730122]  apic 2 pin 23 not connected
> [    0.735091] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.752250] CPU0: Genuine Intel(R) CPU  @ 2.30GHz stepping 02
> [    0.759284] Using local APIC timer interrupts.
> [    0.759285] calibrating APIC timer ...
> [    0.871108] ... lapic delta = 624906
> [    0.875547] ... PM-Timer delta = 357901
> [    0.880277] ... PM-Timer result ok
> [    0.884521] ..... delta 624906
> [    0.888377] ..... mult: 26843588
> [    0.892426] ..... calibration result: 99984
> [    0.897545] ..... CPU clock speed is 2299.0653 MHz.
> [    0.903442] ..... host bus clock speed is 99.0984 MHz.
> [    0.909650] Performance Events: PEBS fmt1+, SandyBridge events, Intel PMU driver.
> [    0.919102] ... version:                3
> [    0.924030] ... bit width:              48
> [    0.929052] ... generic registers:      4
> [    0.933981] ... value mask:             0000ffffffffffff
> [    0.940367] ... max period:             000000007fffffff
> [    0.946753] ... fixed-purpose events:   3
> [    0.951679] ... event mask:             000000070000000f
> [    0.958671] lockdep: fixing up alternatives.
> [    0.963974] Booting Node   0, Processors  #1
> [    0.968716] smpboot cpu 1: start_ip = 96000
> [    0.987235] masked ExtINT on CPU#1
> [    1.011150] ------------[ cut here ]------------
> [    1.011337] lockdep: fixing up alternatives.
> [    1.011373]  #2
> [    1.011374] smpboot cpu 2: start_ip = 96000
> [    1.022482] masked ExtINT on CPU#2
> [    1.033751] WARNING: at /c/wfg/linux-next/kernel/rcutree.c:444 rcu_idle_exit_common+0xd2/0x117()
> [    1.042597] ------------[ cut here ]------------
> [    1.042602] WARNING: at /c/wfg/linux-next/kernel/rcutree.c:359 rcu_idle_enter_common+0xb3/0x130()
> [    1.042604] Hardware name: SandyBridge Platform
> [    1.042605] Modules linked in:
> [    1.042608] Pid: 0, comm: kworker/0:1 Not tainted 3.1.0-ioless-full-next-20111025+ #881
> [    1.042610] Call Trace:
> [    1.042616]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
> [    1.042619]  [<ffffffff81074566>] warn_slowpath_null+0x1a/0x1c
> [    1.042621]  [<ffffffff810d5bf5>] rcu_idle_enter_common+0xb3/0x130
> [    1.042624]  [<ffffffff810d5e24>] rcu_idle_enter+0x40/0x69
> [    1.042629]  [<ffffffff810351ac>] cpu_idle+0x82/0xb8
> [    1.042634]  [<ffffffff81978bd5>] start_secondary+0x1de/0x1e2
> [    1.042664] ---[ end trace 4eaa2a86a8e2da22 ]---
> [    1.042677] Dumping ftrace buffer:
> [    1.042686]    (ftrace buffer empty)
> [    1.042690] ------------[ cut here ]------------
> [    1.042693] WARNING: at /c/wfg/linux-next/kernel/rcutree.c:444 rcu_idle_exit_common+0xd2/0x117()
> [    1.042695] Hardware name: SandyBridge Platform
> [    1.042696] Modules linked in:
> [    1.042698] Pid: 0, comm: kworker/0:1 Tainted: G        W   3.1.0-ioless-full-next-20111025+ #881
> [    1.042700] Call Trace:
> [    1.042701]  <IRQ>  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
> [    1.042706]  [<ffffffff81074566>] warn_slowpath_null+0x1a/0x1c
> [    1.042708]  [<ffffffff810d5afd>] rcu_idle_exit_common+0xd2/0x117
> [    1.042710]  [<ffffffff810d5fff>] rcu_irq_enter+0x75/0xa2
> [    1.042714]  [<ffffffff8107ac7f>] irq_enter+0x1b/0x74
> [    1.042719]  [<ffffffff81099334>] ? down_trylock+0x14/0x37
> [    1.042723]  [<ffffffff8106f29e>] scheduler_ipi+0x5e/0xd5
> [    1.042726]  [<ffffffff8104ce6b>] smp_reschedule_interrupt+0x2a/0x2c
> [    1.042730]  [<ffffffff8198bb73>] reschedule_interrupt+0x73/0x80
> [    1.042731]  <EOI>  [<ffffffff81099334>] ? down_trylock+0x14/0x37
> [    1.042737]  [<ffffffff8103ce2b>] ? mwait_idle+0xef/0x175
> [    1.042739]  [<ffffffff8103ce22>] ? mwait_idle+0xe6/0x175
> [    1.042742]  [<ffffffff810351bb>] cpu_idle+0x91/0xb8
> [    1.042744]  [<ffffffff81978bd5>] start_secondary+0x1de/0x1e2
> [    1.042746] ---[ end trace 4eaa2a86a8e2da23 ]---
> [    1.042776] lockdep: fixing up alternatives.
> [    1.042815]  #3
> [    1.042817] smpboot cpu 3: start_ip = 96000
> [    1.053923] masked ExtINT on CPU#3
> [    1.074206] lockdep: fixing up alternatives.
> [    1.074248]  #4
> [    1.074249] smpboot cpu 4: start_ip = 96000
> [    1.085356] masked ExtINT on CPU#4
> [    1.105637] lockdep: fixing up alternatives.
> [    1.105674]  #5
> [    1.105675] smpboot cpu 5: start_ip = 96000
> [    1.116781] masked ExtINT on CPU#5
> [    1.137066] lockdep: fixing up alternatives.
> [    1.137105]  #6
> [    1.137107] smpboot cpu 6: start_ip = 96000
> [    1.148212] masked ExtINT on CPU#6
> [    1.168492] lockdep: fixing up alternatives.
> [    1.168533]  #7
> [    1.168534] smpboot cpu 7: start_ip = 96000
> [    1.179639] masked ExtINT on CPU#7
> [    1.199933] lockdep: fixing up alternatives.
> [    1.199971]  Ok.
> [    1.199972] Booting Node   1, Processors  #8
> [    1.199974] smpboot cpu 8: start_ip = 96000
> [    1.211404] masked ExtINT on CPU#8
> [    1.291642] lockdep: fixing up alternatives.
> [    1.291674]  #9
> [    1.291675] smpboot cpu 9: start_ip = 96000
> [    1.303144] masked ExtINT on CPU#9
> [    1.323547] lockdep: fixing up alternatives.
> [    1.323576]  #10
> [    1.323577] smpboot cpu 10: start_ip = 96000
> [    1.335051] masked ExtINT on CPU#10
> [    1.355430] lockdep: fixing up alternatives.
> [    1.355459]  #11
> [    1.355461] smpboot cpu 11: start_ip = 96000
> [    1.366941] masked ExtINT on CPU#11
> [    1.387305] lockdep: fixing up alternatives.
> [    1.387336]  #12
> [    1.387337] smpboot cpu 12: start_ip = 96000
> [    1.398819] masked ExtINT on CPU#12
> [    1.419199] lockdep: fixing up alternatives.
> [    1.419228]  #13
> [    1.419229] smpboot cpu 13: start_ip = 96000
> [    1.430696] masked ExtINT on CPU#13
> [    1.451080] lockdep: fixing up alternatives.
> [    1.451120]  #14
> [    1.451121] smpboot cpu 14: start_ip = 96000
> [    1.462573] masked ExtINT on CPU#14
> [    1.482966] lockdep: fixing up alternatives.
> [    1.483002]  #15
> [    1.483003] smpboot cpu 15: start_ip = 96000
> [    1.494444] masked ExtINT on CPU#15
> [    1.514740] lockdep: fixing up alternatives.
> [    1.514768]  Ok.
> [    1.514769] Booting Node   0, Processors  #16
> [    1.514770] smpboot cpu 16: start_ip = 96000
> [    1.526324] masked ExtINT on CPU#16
> [    1.538292] Hardware name: SandyBridge Platform
> [    1.543802] Modules linked in:lockdep: fixing up alternatives.
> [    1.546651]  #17
> [    1.546652] smpboot cpu 17: start_ip = 96000
> [    1.557759] masked ExtINT on CPU#17
> [    1.562905] 
> [    1.565016] Pid: 0, comm: kworker/0:0 Tainted: G        W   3.1.0-ioless-full-next-20111025+ #881
> [    1.575758] Call Trace:
> [    1.578062] lockdep: fixing up alternatives.
> [    1.578101]  #18
> [    1.578103] smpboot cpu 18: start_ip = 96000
> [    1.589208] masked ExtINT on CPU#18
> [    1.596199]  <IRQ>  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
> [    1.604132]  [<ffffffff81074566>] warn_slowpath_null+0x1a/0x1c
> [    1.609481] lockdep: fixing up alternatives.
> [    1.609517]  #19
> [    1.609519] smpboot cpu 19: start_ip = 96000
> [    1.620622] masked ExtINT on CPU#19
> [    1.628375]  [<ffffffff810d5afd>] rcu_idle_exit_common+0xd2/0x117
> [    1.635635]  [<ffffffff810d5fff>] rcu_irq_enter+0x75/0xa2
> [    1.640907] lockdep: fixing up alternatives.
> [    1.640944]  #20
> [    1.640945] smpboot cpu 20: start_ip = 96000
> [    1.652050] masked ExtINT on CPU#20
> [    1.659394]  [<ffffffff8107ac7f>] irq_enter+0x1b/0x74
> [    1.665491]  [<ffffffff8106f29e>] scheduler_ipi+0x5e/0xd5
> [    1.671975]  [<ffffffff8104ce6b>] smp_reschedule_interrupt+0x2a/0x2c
> [    1.672342] lockdep: fixing up alternatives.
> [    1.672383]  #21
> [    1.672384] smpboot cpu 21: start_ip = 96000
> [    1.683502] masked ExtINT on CPU#21
> [    1.696805]  [<ffffffff8198bb73>] reschedule_interrupt+0x73/0x80
> [    1.703783] lockdep: fixing up alternatives.
> [    1.703820]  #22
> [    1.703821] smpboot cpu 22: start_ip = 96000
> [    1.714925] masked ExtINT on CPU#22
> [    1.721230]  <EOI>  [<ffffffff8198661f>] ? notifier_call_chain+0x63/0x63
> [    1.729261]  [<ffffffff8103ce2b>] ? mwait_idle+0xef/0x175
> [    1.735216] lockdep: fixing up alternatives.
> [    1.735254]  #23
> [    1.735255] smpboot cpu 23: start_ip = 96000
> [    1.746359] masked ExtINT on CPU#23
> [    1.753019]  [<ffffffff8103ce22>] ? mwait_idle+0xe6/0x175
> [    1.759503]  [<ffffffff810351bb>] cpu_idle+0x91/0xb8
> [    1.765500]  [<ffffffff81978bd5>] start_secondary+0x1de/0x1e2
> [    1.766662] lockdep: fixing up alternatives.
> [    1.766702]  Ok.
> [    1.766704] Booting Node   1, Processors  #24
> [    1.766706] smpboot cpu 24: start_ip = 96000
> [    1.778148] masked ExtINT on CPU#24
> [    1.794945] ---[ end trace 4eaa2a86a8e2da24 ]---
> [    1.798454] lockdep: fixing up alternatives.
> [    1.798483]  #25
> [    1.798484] smpboot cpu 25: start_ip = 96000
> [    1.809958] masked ExtINT on CPU#25
> [    1.830333] lockdep: fixing up alternatives.
> [    1.835589]  #26
> [    1.837523] smpboot cpu 26: start_ip = 96000
> [    1.854862] masked ExtINT on CPU#26
> [    1.879078] lockdep: fixing up alternatives.
> [    1.884329]  #27
> [    1.886264] smpboot cpu 27: start_ip = 96000
> [    1.903616] masked ExtINT on CPU#27
> [    1.927812] lockdep: fixing up alternatives.
> [    1.933062]  #28
> [    1.934997] smpboot cpu 28: start_ip = 96000
> [    1.952341] masked ExtINT on CPU#28
> [    1.976550] lockdep: fixing up alternatives.
> [    1.981802]  #29
> [    1.983735] smpboot cpu 29: start_ip = 96000
> [    2.001073] masked ExtINT on CPU#29
> [    2.025285] lockdep: fixing up alternatives.
> [    2.030537]  #30
> [    2.032473] smpboot cpu 30: start_ip = 96000
> [    2.049789] masked ExtINT on CPU#30
> [    2.074029] lockdep: fixing up alternatives.
> [    2.079270]  #31
> [    2.081204] smpboot cpu 31: start_ip = 96000
> [    2.098517] masked ExtINT on CPU#31
> [    2.122621] Brought up 32 CPUs
> [    2.126486] Total of 32 processors activated (147173.18 BogoMIPS).
> [    2.174403] CPU0 attaching sched-domain:
> [    2.179248]  domain 0: span 0,16 level SIBLING
> [    2.184752]   groups: 0 (cpu_power = 589) 16 (cpu_power = 589)
> [    2.192151]   domain 1: span 0-7,16-23 level MC
> [    2.197746]    groups: 0,16 (cpu_power = 1178) 1,17 (cpu_power = 1178) 2,18 (cpu_power = 1178) 3,19 (cpu_power = 1178) 4,20 (cpu_power = 1178) 5,21 (cpu_power = 1178) 6,22 (cpu_power = 1178) 7,23 (cpu_power = 1178)
> [    2.221680]    domain 2: span 0-31 level NODE
> [    2.227086]     groups: 0-7,16-23 (cpu_power = 9424) 8-15,24-31 (cpu_power = 9424)
> [    2.236812] CPU1 attaching sched-domain:
> [    2.241658]  domain 0: span 1,17 level SIBLING
> [    2.247161]   groups: 1 (cpu_power = 589) 17 (cpu_power = 589)
> [    2.254556]   domain 1: span 0-7,16-23 level MC
> [    2.260154]    groups: 1,17 (cpu_power = 1178) 2,18 (cpu_power = 1178) 3,19 (cpu_power = 1178) 4,20 (cpu_power = 1178) 5,21 (cpu_power = 1178) 6,22 (cpu_power = 1178) 7,23 (cpu_power = 1178) 0,16 (cpu_power = 1178)
> [    2.284091]    domain 2: span 0-31 level NODE
> [    2.289489]     groups: 0-7,16-23 (cpu_power = 9424) 8-15,24-31 (cpu_power = 9424)
> [    2.299194] CPU2 attaching sched-domain:
> [    2.304030]  domain 0: span 2,18 level SIBLING
> [    2.309531]   groups: 2 (cpu_power = 589) 18 (cpu_power = 589)
> [    2.316909]   domain 1: span 0-7,16-23 level MC
> [    2.322514]    groups: 2,18 (cpu_power = 1178) 3,19 (cpu_power = 1178) 4,20 (cpu_power = 1178) 5,21 (cpu_power = 1178) 6,22 (cpu_power = 1178) 7,23 (cpu_power = 1178) 0,16 (cpu_power = 1178) 1,17 (cpu_power = 1178)
> [    2.346454]    domain 2: span 0-31 level NODE
> [    2.351858]     groups: 0-7,16-23 (cpu_power = 9424) 8-15,24-31 (cpu_power = 9424)
> [    2.361579] CPU3 attaching sched-domain:
> [    2.366416]  domain 0: span 3,19 level SIBLING
> [    2.371908]   groups: 3 (cpu_power = 589) 19 (cpu_power = 589)
> [    2.379309]   domain 1: span 0-7,16-23 level MC
> [    2.384912]    groups: 3,19 (cpu_power = 1178) 4,20 (cpu_power = 1178) 5,21 (cpu_power = 1178) 6,22 (cpu_power = 1178) 7,23 (cpu_power = 1178) 0,16 (cpu_power = 1178) 1,17 (cpu_power = 1178) 2,18 (cpu_power = 1178)
> [    2.408861]    domain 2: span 0-31 level NODE
> [    2.414269]     groups: 0-7,16-23 (cpu_power = 9424) 8-15,24-31 (cpu_power = 9424)
> [    2.423994] CPU4 attaching sched-domain:
> [    2.428828]  domain 0: span 4,20 level SIBLING
> [    2.434324]   groups: 4 (cpu_power = 589) 20 (cpu_power = 589)
> [    2.450942]   domain 1: span 0-7,16-23 level MC
> [    2.456544]    groups: 4,20 (cpu_power = 1178) 5,21 (cpu_power = 1178) 6,22 (cpu_power = 1178) 7,23 (cpu_power = 1178) 0,16 (cpu_power = 1178) 1,17 (cpu_power = 1178) 2,18 (cpu_power = 1178) 3,19 (cpu_power = 1178)
> [    2.480470]    domain 2: span 0-31 level NODE
> [    2.485867]     groups: 0-7,16-23 (cpu_power = 9424) 8-15,24-31 (cpu_power = 9424)
> [    2.495587] CPU5 attaching sched-domain:
> [    2.500422]  domain 0: span 5,21 level SIBLING
> [    2.505927]   groups: 5 (cpu_power = 589) 21 (cpu_power = 589)
> [    2.513329]   domain 1: span 0-7,16-23 level MC
> [    2.518926]    groups: 5,21 (cpu_power = 1178) 6,22 (cpu_power = 1178) 7,23 (cpu_power = 1178) 0,16 (cpu_power = 1178) 1,17 (cpu_power = 1178) 2,18 (cpu_power = 1178) 3,19 (cpu_power = 1178) 4,20 (cpu_power = 1178)
> [    2.542878]    domain 2: span 0-31 level NODE
> [    2.548277]     groups: 0-7,16-23 (cpu_power = 9424) 8-15,24-31 (cpu_power = 9424)
> [    2.557994] CPU6 attaching sched-domain:
> [    2.562829]  domain 0: span 6,22 level SIBLING
> [    2.568334]   groups: 6 (cpu_power = 589) 22 (cpu_power = 589)
> [    2.575730]   domain 1: span 0-7,16-23 level MC
> [    2.581329]    groups: 6,22 (cpu_power = 1178) 7,23 (cpu_power = 1178) 0,16 (cpu_power = 1178) 1,17 (cpu_power = 1178) 2,18 (cpu_power = 1178) 3,19 (cpu_power = 1178) 4,20 (cpu_power = 1178) 5,21 (cpu_power = 1178)
> [    2.605259]    domain 2: span 0-31 level NODE
> [    2.610665]     groups: 0-7,16-23 (cpu_power = 9424) 8-15,24-31 (cpu_power = 9424)
> [    2.620386] CPU7 attaching sched-domain:
> [    2.625221]  domain 0: span 7,23 level SIBLING
> [    2.630728]   groups: 7 (cpu_power = 589) 23 (cpu_power = 589)
> [    2.638129]   domain 1: span 0-7,16-23 level MC
> [    2.643730]    groups: 7,23 (cpu_power = 1178) 0,16 (cpu_power = 1178) 1,17 (cpu_power = 1178) 2,18 (cpu_power = 1178) 3,19 (cpu_power = 1178) 4,20 (cpu_power = 1178) 5,21 (cpu_power = 1178) 6,22 (cpu_power = 1178)
> [    2.667680]    domain 2: span 0-31 level NODE
> [    2.673088]     groups: 0-7,16-23 (cpu_power = 9424) 8-15,24-31 (cpu_power = 9424)
> [    2.682809] CPU8 attaching sched-domain:
> [    2.687646]  domain 0: span 8,24 level SIBLING
> [    2.693140]   groups: 8 (cpu_power = 589) 24 (cpu_power = 589)
> [    2.700526]   domain 1: span 8-15,24-31 level MC
> [    2.706229]    groups: 8,24 (cpu_power = 1178) 9,25 (cpu_power = 1178) 10,26 (cpu_power = 1178) 11,27 (cpu_power = 1178) 12,28 (cpu_power = 1178) 13,29 (cpu_power = 1178) 14,30 (cpu_power = 1178) 15,31 (cpu_power = 1178)
> [    2.730753]    domain 2: span 0-31 level NODE
> [    2.736160]     groups: 8-15,24-31 (cpu_power = 9424) 0-7,16-23 (cpu_power = 9424)
> [    2.745882] CPU9 attaching sched-domain:
> [    2.750715]  domain 0: span 9,25 level SIBLING
> [    2.756220]   groups: 9 (cpu_power = 589) 25 (cpu_power = 589)
> [    2.763616]   domain 1: span 8-15,24-31 level MC
> [    2.769305]    groups: 9,25 (cpu_power = 1178) 10,26 (cpu_power = 1178) 11,27 (cpu_power = 1178) 12,28 (cpu_power = 1178) 13,29 (cpu_power = 1178) 14,30 (cpu_power = 1178) 15,31 (cpu_power = 1178) 8,24 (cpu_power = 1178)
> [    2.793844]    domain 2: span 0-31 level NODE
> [    2.799243]     groups: 8-15,24-31 (cpu_power = 9424) 0-7,16-23 (cpu_power = 9424)
> [    2.808956] CPU10 attaching sched-domain:
> [    2.813884]  domain 0: span 10,26 level SIBLING
> [    2.819488]   groups: 10 (cpu_power = 589) 26 (cpu_power = 589)
> [    2.826985]   domain 1: span 8-15,24-31 level MC
> [    2.832682]    groups: 10,26 (cpu_power = 1178) 11,27 (cpu_power = 1178) 12,28 (cpu_power = 1178) 13,29 (cpu_power = 1178) 14,30 (cpu_power = 1178) 15,31 (cpu_power = 1178) 8,24 (cpu_power = 1178) 9,25 (cpu_power = 1178)
> [    2.857206]    domain 2: span 0-31 level NODE
> [    2.862612]     groups: 8-15,24-31 (cpu_power = 9424) 0-7,16-23 (cpu_power = 9424)
> [    2.872338] CPU11 attaching sched-domain:
> [    2.877269]  domain 0: span 11,27 level SIBLING
> [    2.882869]   groups: 11 (cpu_power = 589) 27 (cpu_power = 589)
> [    2.890361]   domain 1: span 8-15,24-31 level MC
> [    2.896062]    groups: 11,27 (cpu_power = 1178) 12,28 (cpu_power = 1178) 13,29 (cpu_power = 1178) 14,30 (cpu_power = 1178) 15,31 (cpu_power = 1178) 8,24 (cpu_power = 1178) 9,25 (cpu_power = 1178) 10,26 (cpu_power = 1178)
> [    2.920598]    domain 2: span 0-31 level NODE
> [    2.926003]     groups: 8-15,24-31 (cpu_power = 9424) 0-7,16-23 (cpu_power = 9424)
> [    2.935730] CPU12 attaching sched-domain:
> [    2.940660]  domain 0: span 12,28 level SIBLING
> [    2.946254]   groups: 12 (cpu_power = 589) 28 (cpu_power = 589)
> [    2.953736]   domain 1: span 8-15,24-31 level MC
> [    2.959431]    groups: 12,28 (cpu_power = 1178) 13,29 (cpu_power = 1178) 14,30 (cpu_power = 1178) 15,31 (cpu_power = 1178) 8,24 (cpu_power = 1178) 9,25 (cpu_power = 1178) 10,26 (cpu_power = 1178) 11,27 (cpu_power = 1178)
> [    2.983957]    domain 2: span 0-31 level NODE
> [    2.989361]     groups: 8-15,24-31 (cpu_power = 9424) 0-7,16-23 (cpu_power = 9424)
> [    2.999086] CPU13 attaching sched-domain:
> [    3.004016]  domain 0: span 13,29 level SIBLING
> [    3.009615]   groups: 13 (cpu_power = 589) 29 (cpu_power = 589)
> [    3.017107]   domain 1: span 8-15,24-31 level MC
> [    3.022804]    groups: 13,29 (cpu_power = 1178) 14,30 (cpu_power = 1178) 15,31 (cpu_power = 1178) 8,24 (cpu_power = 1178) 9,25 (cpu_power = 1178) 10,26 (cpu_power = 1178) 11,27 (cpu_power = 1178) 12,28 (cpu_power = 1178)
> [    3.047337]    domain 2: span 0-31 level NODE
> [    3.052739]     groups: 8-15,24-31 (cpu_power = 9424) 0-7,16-23 (cpu_power = 9424)
> [    3.062469] CPU14 attaching sched-domain:
> [    3.067399]  domain 0: span 14,30 level SIBLING
> [    3.072998]   groups: 14 (cpu_power = 589) 30 (cpu_power = 589)
> [    3.080484]   domain 1: span 8-15,24-31 level MC
> [    3.086183]    groups: 14,30 (cpu_power = 1178) 15,31 (cpu_power = 1178) 8,24 (cpu_power = 1178) 9,25 (cpu_power = 1178) 10,26 (cpu_power = 1178) 11,27 (cpu_power = 1178) 12,28 (cpu_power = 1178) 13,29 (cpu_power = 1178)
> [    3.110715]    domain 2: span 0-31 level NODE
> [    3.116116]     groups: 8-15,24-31 (cpu_power = 9424) 0-7,16-23 (cpu_power = 9424)
> [    3.125835] CPU15 attaching sched-domain:
> [    3.130765]  domain 0: span 15,31 level SIBLING
> [    3.136363]   groups: 15 (cpu_power = 589) 31 (cpu_power = 589)
> [    3.143861]   domain 1: span 8-15,24-31 level MC
> [    3.149559]    groups: 15,31 (cpu_power = 1178) 8,24 (cpu_power = 1178) 9,25 (cpu_power = 1178) 10,26 (cpu_power = 1178) 11,27 (cpu_power = 1178) 12,28 (cpu_power = 1178) 13,29 (cpu_power = 1178) 14,30 (cpu_power = 1178)
> [    3.174095]    domain 2: span 0-31 level NODE
> [    3.179498]     groups: 8-15,24-31 (cpu_power = 9424) 0-7,16-23 (cpu_power = 9424)
> [    3.189224] CPU16 attaching sched-domain:
> [    3.194155]  domain 0: span 0,16 level SIBLING
> [    3.199648]   groups: 16 (cpu_power = 589) 0 (cpu_power = 589)
> [    3.207036]   domain 1: span 0-7,16-23 level MC
> [    3.212625]    groups: 0,16 (cpu_power = 1178) 1,17 (cpu_power = 1178) 2,18 (cpu_power = 1178) 3,19 (cpu_power = 1178) 4,20 (cpu_power = 1178) 5,21 (cpu_power = 1178) 6,22 (cpu_power = 1178) 7,23 (cpu_power = 1178)
> [    3.236564]    domain 2: span 0-31 level NODE
> [    3.241969]     groups: 0-7,16-23 (cpu_power = 9424) 8-15,24-31 (cpu_power = 9424)
> [    3.251693] CPU17 attaching sched-domain:
> [    3.256623]  domain 0: span 1,17 level SIBLING
> [    3.262132]   groups: 17 (cpu_power = 589) 1 (cpu_power = 589)
> [    3.269527]   domain 1: span 0-7,16-23 level MC
> [    3.275128]    groups: 1,17 (cpu_power = 1178) 2,18 (cpu_power = 1178) 3,19 (cpu_power = 1178) 4,20 (cpu_power = 1178) 5,21 (cpu_power = 1178) 6,22 (cpu_power = 1178) 7,23 (cpu_power = 1178) 0,16 (cpu_power = 1178)
> [    3.299059]    domain 2: span 0-31 level NODE
> [    3.304467]     groups: 0-7,16-23 (cpu_power = 9424) 8-15,24-31 (cpu_power = 9424)
> [    3.314187] CPU18 attaching sched-domain:
> [    3.319121]  domain 0: span 2,18 level SIBLING
> [    3.324624]   groups: 18 (cpu_power = 589) 2 (cpu_power = 589)
> [    3.332011]   domain 1: span 0-7,16-23 level MC
> [    3.337613]    groups: 2,18 (cpu_power = 1178) 3,19 (cpu_power = 1178) 4,20 (cpu_power = 1178) 5,21 (cpu_power = 1178) 6,22 (cpu_power = 1178) 7,23 (cpu_power = 1178) 0,16 (cpu_power = 1178) 1,17 (cpu_power = 1178)
> [    3.361560]    domain 2: span 0-31 level NODE
> [    3.366969]     groups: 0-7,16-23 (cpu_power = 9424) 8-15,24-31 (cpu_power = 9424)
> [    3.376682] CPU19 attaching sched-domain:
> [    3.381608]  domain 0: span 3,19 level SIBLING
> [    3.387108]   groups: 19 (cpu_power = 589) 3 (cpu_power = 589)
> [    3.394505]   domain 1: span 0-7,16-23 level MC
> [    3.400105]    groups: 3,19 (cpu_power = 1178) 4,20 (cpu_power = 1178) 5,21 (cpu_power = 1178) 6,22 (cpu_power = 1178) 7,23 (cpu_power = 1178) 0,16 (cpu_power = 1178) 1,17 (cpu_power = 1178) 2,18 (cpu_power = 1178)
> [    3.424042]    domain 2: span 0-31 level NODE
> [    3.429439]     groups: 0-7,16-23 (cpu_power = 9424) 8-15,24-31 (cpu_power = 9424)
> [    3.439168] CPU20 attaching sched-domain:
> [    3.444097]  domain 0: span 4,20 level SIBLING
> [    3.449598]   groups: 20 (cpu_power = 589) 4 (cpu_power = 589)
> [    3.456990]   domain 1: span 0-7,16-23 level MC
> [    3.462584]    groups: 4,20 (cpu_power = 1178) 5,21 (cpu_power = 1178) 6,22 (cpu_power = 1178) 7,23 (cpu_power = 1178) 0,16 (cpu_power = 1178) 1,17 (cpu_power = 1178) 2,18 (cpu_power = 1178) 3,19 (cpu_power = 1178)
> [    3.486522]    domain 2: span 0-31 level NODE
> [    3.491920]     groups: 0-7,16-23 (cpu_power = 9424) 8-15,24-31 (cpu_power = 9424)
> [    3.501639] CPU21 attaching sched-domain:
> [    3.506569]  domain 0: span 5,21 level SIBLING
> [    3.512061]   groups: 21 (cpu_power = 589) 5 (cpu_power = 589)
> [    3.519453]   domain 1: span 0-7,16-23 level MC
> [    3.525053]    groups: 5,21 (cpu_power = 1178) 6,22 (cpu_power = 1178) 7,23 (cpu_power = 1178) 0,16 (cpu_power = 1178) 1,17 (cpu_power = 1178) 2,18 (cpu_power = 1178) 3,19 (cpu_power = 1178) 4,20 (cpu_power = 1178)
> [    3.549009]    domain 2: span 0-31 level NODE
> [    3.554408]     groups: 0-7,16-23 (cpu_power = 9424) 8-15,24-31 (cpu_power = 9424)
> [    3.564125] CPU22 attaching sched-domain:
> [    3.569059]  domain 0: span 6,22 level SIBLING
> [    3.574562]   groups: 22 (cpu_power = 589) 6 (cpu_power = 589)
> [    3.591179]   domain 1: span 0-7,16-23 level MC
> [    3.596779]    groups: 6,22 (cpu_power = 1178) 7,23 (cpu_power = 1178) 0,16 (cpu_power = 1178) 1,17 (cpu_power = 1178) 2,18 (cpu_power = 1178) 3,19 (cpu_power = 1178) 4,20 (cpu_power = 1178) 5,21 (cpu_power = 1178)
> [    3.620710]    domain 2: span 0-31 level NODE
> [    3.626115]     groups: 0-7,16-23 (cpu_power = 9424) 8-15,24-31 (cpu_power = 9424)
> [    3.635824] CPU23 attaching sched-domain:
> [    3.640756]  domain 0: span 7,23 level SIBLING
> [    3.646258]   groups: 23 (cpu_power = 589) 7 (cpu_power = 589)
> [    3.653654]   domain 1: span 0-7,16-23 level MC
> [    3.659248]    groups: 7,23 (cpu_power = 1178) 0,16 (cpu_power = 1178) 1,17 (cpu_power = 1178) 2,18 (cpu_power = 1178) 3,19 (cpu_power = 1178) 4,20 (cpu_power = 1178) 5,21 (cpu_power = 1178) 6,22 (cpu_power = 1178)
> [    3.683197]    domain 2: span 0-31 level NODE
> [    3.688599]     groups: 0-7,16-23 (cpu_power = 9424) 8-15,24-31 (cpu_power = 9424)
> [    3.698328] CPU24 attaching sched-domain:
> [    3.703263]  domain 0: span 8,24 level SIBLING
> [    3.708765]   groups: 24 (cpu_power = 589) 8 (cpu_power = 589)
> [    3.716161]   domain 1: span 8-15,24-31 level MC
> [    3.721853]    groups: 8,24 (cpu_power = 1178) 9,25 (cpu_power = 1178) 10,26 (cpu_power = 1178) 11,27 (cpu_power = 1178) 12,28 (cpu_power = 1178) 13,29 (cpu_power = 1178) 14,30 (cpu_power = 1178) 15,31 (cpu_power = 1178)
> [    3.746373]    domain 2: span 0-31 level NODE
> [    3.751773]     groups: 8-15,24-31 (cpu_power = 9424) 0-7,16-23 (cpu_power = 9424)
> [    3.761486] CPU25 attaching sched-domain:
> [    3.766416]  domain 0: span 9,25 level SIBLING
> [    3.771914]   groups: 25 (cpu_power = 589) 9 (cpu_power = 589)
> [    3.779296]   domain 1: span 8-15,24-31 level MC
> [    3.784994]    groups: 9,25 (cpu_power = 1178) 10,26 (cpu_power = 1178) 11,27 (cpu_power = 1178) 12,28 (cpu_power = 1178) 13,29 (cpu_power = 1178) 14,30 (cpu_power = 1178) 15,31 (cpu_power = 1178) 8,24 (cpu_power = 1178)
> [    3.809530]    domain 2: span 0-31 level NODE
> [    3.814937]     groups: 8-15,24-31 (cpu_power = 9424) 0-7,16-23 (cpu_power = 9424)
> [    3.824654] CPU26 attaching sched-domain:
> [    3.829586]  domain 0: span 10,26 level SIBLING
> [    3.835190]   groups: 26 (cpu_power = 589) 10 (cpu_power = 589)
> [    3.842686]   domain 1: span 8-15,24-31 level MC
> [    3.848374]    groups: 10,26 (cpu_power = 1178) 11,27 (cpu_power = 1178) 12,28 (cpu_power = 1178) 13,29 (cpu_power = 1178) 14,30 (cpu_power = 1178) 15,31 (cpu_power = 1178) 8,24 (cpu_power = 1178) 9,25 (cpu_power = 1178)
> [    3.872901]    domain 2: span 0-31 level NODE
> [    3.878309]     groups: 8-15,24-31 (cpu_power = 9424) 0-7,16-23 (cpu_power = 9424)
> [    3.888030] CPU27 attaching sched-domain:
> [    3.892960]  domain 0: span 11,27 level SIBLING
> [    3.898565]   groups: 27 (cpu_power = 589) 11 (cpu_power = 589)
> [    3.906056]   domain 1: span 8-15,24-31 level MC
> [    3.911744]    groups: 11,27 (cpu_power = 1178) 12,28 (cpu_power = 1178) 13,29 (cpu_power = 1178) 14,30 (cpu_power = 1178) 15,31 (cpu_power = 1178) 8,24 (cpu_power = 1178) 9,25 (cpu_power = 1178) 10,26 (cpu_power = 1178)
> [    3.936290]    domain 2: span 0-31 level NODE
> [    3.941696]     groups: 8-15,24-31 (cpu_power = 9424) 0-7,16-23 (cpu_power = 9424)
> [    3.951418] CPU28 attaching sched-domain:
> [    3.956352]  domain 0: span 12,28 level SIBLING
> [    3.961942]   groups: 28 (cpu_power = 589) 12 (cpu_power = 589)
> [    3.969442]   domain 1: span 8-15,24-31 level MC
> [    3.975143]    groups: 12,28 (cpu_power = 1178) 13,29 (cpu_power = 1178) 14,30 (cpu_power = 1178) 15,31 (cpu_power = 1178) 8,24 (cpu_power = 1178) 9,25 (cpu_power = 1178) 10,26 (cpu_power = 1178) 11,27 (cpu_power = 1178)
> [    3.999678]    domain 2: span 0-31 level NODE
> [    4.005086]     groups: 8-15,24-31 (cpu_power = 9424) 0-7,16-23 (cpu_power = 9424)
> [    4.014804] CPU29 attaching sched-domain:
> [    4.019732]  domain 0: span 13,29 level SIBLING
> [    4.025316]   groups: 29 (cpu_power = 589) 13 (cpu_power = 589)
> [    4.032812]   domain 1: span 8-15,24-31 level MC
> [    4.038511]    groups: 13,29 (cpu_power = 1178) 14,30 (cpu_power = 1178) 15,31 (cpu_power = 1178) 8,24 (cpu_power = 1178) 9,25 (cpu_power = 1178) 10,26 (cpu_power = 1178) 11,27 (cpu_power = 1178) 12,28 (cpu_power = 1178)
> [    4.063041]    domain 2: span 0-31 level NODE
> [    4.068446]     groups: 8-15,24-31 (cpu_power = 9424) 0-7,16-23 (cpu_power = 9424)
> [    4.078179] CPU30 attaching sched-domain:
> [    4.083110]  domain 0: span 14,30 level SIBLING
> [    4.088709]   groups: 30 (cpu_power = 589) 14 (cpu_power = 589)
> [    4.096213]   domain 1: span 8-15,24-31 level MC
> [    4.101908]    groups: 14,30 (cpu_power = 1178) 15,31 (cpu_power = 1178) 8,24 (cpu_power = 1178) 9,25 (cpu_power = 1178) 10,26 (cpu_power = 1178) 11,27 (cpu_power = 1178) 12,28 (cpu_power = 1178) 13,29 (cpu_power = 1178)
> [    4.126438]    domain 2: span 0-31 level NODE
> [    4.131841]     groups: 8-15,24-31 (cpu_power = 9424) 0-7,16-23 (cpu_power = 9424)
> [    4.141572] CPU31 attaching sched-domain:
> [    4.146503]  domain 0: span 15,31 level SIBLING
> [    4.152104]   groups: 31 (cpu_power = 589) 15 (cpu_power = 589)
> [    4.159608]   domain 1: span 8-15,24-31 level MC
> [    4.165296]    groups: 15,31 (cpu_power = 1178) 8,24 (cpu_power = 1178) 9,25 (cpu_power = 1178) 10,26 (cpu_power = 1178) 11,27 (cpu_power = 1178) 12,28 (cpu_power = 1178) 13,29 (cpu_power = 1178) 14,30 (cpu_power = 1178)
> [    4.189824]    domain 2: span 0-31 level NODE
> [    4.195229]     groups: 8-15,24-31 (cpu_power = 9424) 0-7,16-23 (cpu_power = 9424)
> [    4.207054] devtmpfs: initialized
> [    4.216221] PM: Registering ACPI NVS region at ab664000 (1822720 bytes)
> [    4.224137] PM: Registering ACPI NVS region at bede7000 (294912 bytes)
> [    4.231899] PM: Registering ACPI NVS region at bee30000 (438272 bytes)
> [    4.239667] PM: Registering ACPI NVS region at bee9d000 (4096 bytes)
> [    4.247223] PM: Registering ACPI NVS region at beeb9000 (1081344 bytes)
> [    4.256027] xor: automatically using best checksumming function: generic_sse
> [    4.268475]    generic_sse: 10184.000 MB/sec
> [    4.273689] xor: using function: generic_sse (10184.000 MB/sec)
> [    4.281110] kworker/u:0 used greatest stack depth: 5608 bytes left
> [    4.281178] RTC time: 18:56:49, date: 10/31/11
> [    4.281375] NET: Registered protocol family 16
> [    4.284250] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
> [    4.284257] ACPI: bus type pci registered
> [    4.288038] dca service started, version 1.12.1
> [    4.288325] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xc0000000-0xcfffffff] (base 0xc0000000)
> [    4.288329] PCI: MMCONFIG at [mem 0xc0000000-0xcfffffff] reserved in E820
> [    4.338437] kworker/u:0 used greatest stack depth: 5192 bytes left
> [    4.404017] PCI: Using configuration type 1 for base access
> [    4.488155] bio: create slab <bio-0> at 0
> [    4.510363] raid6: int64x1   1257 MB/s
> [    4.531313] raid6: int64x2   1316 MB/s
> [    4.552306] raid6: int64x4   1160 MB/s
> [    4.573279] raid6: int64x8    902 MB/s
> [    4.594267] raid6: sse2x1    3171 MB/s
> [    4.615265] raid6: sse2x2    3910 MB/s
> [    4.636247] raid6: sse2x4    4433 MB/s
> [    4.640902] raid6: using algorithm sse2x4 (4433 MB/s)
> [    4.647318] ACPI: Added _OSI(Module Device)
> [    4.652465] ACPI: Added _OSI(Processor Device)
> [    4.657901] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    4.663615] ACPI: Added _OSI(Processor Aggregator Device)
> [    4.759319] ACPI: EC: Look up EC in DSDT
> [    4.855990] ACPI: Executed 1 blocks of module-level executable AML code
> [    5.370489] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
> [    5.450998] ACPI: Interpreter enabled
> [    5.455566] ACPI: (supports S0 S1 S5)
> [    5.460482] ACPI: Using IOAPIC for interrupt routing
> [    5.598234] ACPI: No dock devices found.
> [    5.603092] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    5.616516] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-7e])
> [    5.625846] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
> [    5.633715] pci_root PNP0A08:00: host bridge window [io  0x0000-0xbfff]
> [    5.641581] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
> [    5.650603] pci_root PNP0A08:00: host bridge window [mem 0x000c0000-0x000c3fff]
> [    5.659627] pci_root PNP0A08:00: host bridge window [mem 0x000c4000-0x000c7fff]
> [    5.668651] pci_root PNP0A08:00: host bridge window [mem 0x000c8000-0x000cbfff]
> [    5.677674] pci_root PNP0A08:00: host bridge window [mem 0x000cc000-0x000cffff]
> [    5.686686] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000d3fff]
> [    5.695705] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
> [    5.704724] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
> [    5.713746] pci_root PNP0A08:00: host bridge window [mem 0x000dc000-0x000dffff]
> [    5.722769] pci_root PNP0A08:00: host bridge window [mem 0x000e0000-0x000e3fff]
> [    5.731783] pci_root PNP0A08:00: host bridge window [mem 0x000e4000-0x000e7fff]
> [    5.740804] pci_root PNP0A08:00: host bridge window [mem 0x000e8000-0x000ebfff]
> [    5.749826] pci_root PNP0A08:00: host bridge window [mem 0x000ec000-0x000effff]
> [    5.758849] pci_root PNP0A08:00: host bridge window [mem 0x000f0000-0x000fffff]
> [    5.767873] pci_root PNP0A08:00: host bridge window [mem 0xd0000000-0xebffffff]
> [    5.776896] pci_root PNP0A08:00: host bridge window [mem 0x3f8000000000-0x3f807fffffff]
> [    5.786700] pci_root PNP0A08:00: host bridge window expanded to [io  0x0000-0xbfff]; [io  0x0000-0xbfff] ignored
> [    5.798993] pci 0000:00:00.0: [8086:3c00] type 0 class 0x000600
> [    5.806223] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
> [    5.813516] pci 0000:00:00.0: PME# disabled
> [    5.828114] pci 0000:00:01.0: [8086:3c02] type 1 class 0x000604
> [    5.835337] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
> [    5.842620] pci 0000:00:01.0: PME# disabled
> [    5.847816] pci 0000:00:01.1: [8086:3c03] type 1 class 0x000604
> [    5.855038] pci 0000:00:01.1: PME# supported from D0 D3hot D3cold
> [    5.862324] pci 0000:00:01.1: PME# disabled
> [    5.867538] pci 0000:00:02.0: [8086:3c04] type 1 class 0x000604
> [    5.874759] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
> [    5.882047] pci 0000:00:02.0: PME# disabled
> [    5.887243] pci 0000:00:02.2: [8086:3c06] type 1 class 0x000604
> [    5.894459] pci 0000:00:02.2: PME# supported from D0 D3hot D3cold
> [    5.901739] pci 0000:00:02.2: PME# disabled
> [    5.906945] pci 0000:00:03.0: [8086:3c08] type 1 class 0x000604
> [    5.914165] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
> [    5.921448] pci 0000:00:03.0: PME# disabled
> [    5.926646] pci 0000:00:03.2: [8086:3c0a] type 1 class 0x000604
> [    5.933860] pci 0000:00:03.2: PME# supported from D0 D3hot D3cold
> [    5.941146] pci 0000:00:03.2: PME# disabled
> [    5.946350] pci 0000:00:04.0: [8086:3c20] type 0 class 0x000880
> [    5.953469] pci 0000:00:04.0: reg 10: [mem 0xebfb0000-0xebfb3fff 64bit]
> [    5.961509] pci 0000:00:04.1: [8086:3c21] type 0 class 0x000880
> [    5.968625] pci 0000:00:04.1: reg 10: [mem 0xebfa0000-0xebfa3fff 64bit]
> [    5.976662] pci 0000:00:04.2: [8086:3c22] type 0 class 0x000880
> [    5.983778] pci 0000:00:04.2: reg 10: [mem 0xebf90000-0xebf93fff 64bit]
> [    5.991816] pci 0000:00:04.3: [8086:3c23] type 0 class 0x000880
> [    5.998934] pci 0000:00:04.3: reg 10: [mem 0xebf80000-0xebf83fff 64bit]
> [    6.006979] pci 0000:00:04.4: [8086:3c24] type 0 class 0x000880
> [    6.014095] pci 0000:00:04.4: reg 10: [mem 0xebf70000-0xebf73fff 64bit]
> [    6.022134] pci 0000:00:04.5: [8086:3c25] type 0 class 0x000880
> [    6.029247] pci 0000:00:04.5: reg 10: [mem 0xebf60000-0xebf63fff 64bit]
> [    6.037285] pci 0000:00:04.6: [8086:3c26] type 0 class 0x000880
> [    6.044397] pci 0000:00:04.6: reg 10: [mem 0xebf50000-0xebf53fff 64bit]
> [    6.052434] pci 0000:00:04.7: [8086:3c27] type 0 class 0x000880
> [    6.059548] pci 0000:00:04.7: reg 10: [mem 0xebf40000-0xebf43fff 64bit]
> [    6.067596] pci 0000:00:05.0: [8086:3c28] type 0 class 0x000880
> [    6.074865] pci 0000:00:05.2: [8086:3c2a] type 0 class 0x000880
> [    6.082129] pci 0000:00:05.4: [8086:3c2c] type 0 class 0x000800
> [    6.089244] pci 0000:00:05.4: reg 10: [mem 0xd3140000-0xd3140fff]
> [    6.096690] pci 0000:00:06.0: [8086:3c60] type 0 class 0x000880
> [    6.103976] pci 0000:00:07.0: [8086:3c68] type 0 class 0x000600
> [    6.111252] pci 0000:00:16.0: [8086:1d3a] type 0 class 0x000780
> [    6.118384] pci 0000:00:16.0: reg 10: [mem 0xebf30000-0xebf3000f 64bit]
> [    6.126378] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
> [    6.133663] pci 0000:00:16.0: PME# disabled
> [    6.138885] pci 0000:00:1a.0: [8086:1d2d] type 0 class 0x000c03
> [    6.146013] pci 0000:00:1a.0: reg 10: [mem 0xd3130000-0xd31303ff]
> [    6.153453] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
> [    6.160740] pci 0000:00:1a.0: PME# disabled
> [    6.165937] pci 0000:00:1b.0: [8086:1d20] type 0 class 0x000403
> [    6.173055] pci 0000:00:1b.0: reg 10: [mem 0xebf20000-0xebf23fff 64bit]
> [    6.181049] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> [    6.188333] pci 0000:00:1b.0: PME# disabled
> [    6.193515] pci 0000:00:1c.0: [8086:1d10] type 1 class 0x000604
> [    6.200742] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    6.208027] pci 0000:00:1c.0: PME# disabled
> [    6.213226] pci 0000:00:1c.4: [8086:1d18] type 1 class 0x000604
> [    6.220456] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
> [    6.227741] pci 0000:00:1c.4: PME# disabled
> [    6.232933] pci 0000:00:1c.6: [8086:1d1c] type 1 class 0x000604
> [    6.240161] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
> [    6.247444] pci 0000:00:1c.6: PME# disabled
> [    6.252636] pci 0000:00:1c.7: [8086:1d1e] type 1 class 0x000604
> [    6.259872] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
> [    6.267157] pci 0000:00:1c.7: PME# disabled
> [    6.272352] pci 0000:00:1d.0: [8086:1d26] type 0 class 0x000c03
> [    6.279480] pci 0000:00:1d.0: reg 10: [mem 0xd3120000-0xd31203ff]
> [    6.286924] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
> [    6.294208] pci 0000:00:1d.0: PME# disabled
> [    6.299391] pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
> [    6.306611] pci 0000:00:1f.0: [8086:1d40] type 0 class 0x000601
> [    6.313940] pci 0000:00:1f.2: [8086:1d02] type 0 class 0x000106
> [    6.321069] pci 0000:00:1f.2: reg 10: [io  0x4070-0x4077]
> [    6.327574] pci 0000:00:1f.2: reg 14: [io  0x4060-0x4063]
> [    6.334092] pci 0000:00:1f.2: reg 18: [io  0x4050-0x4057]
> [    6.340608] pci 0000:00:1f.2: reg 1c: [io  0x4040-0x4043]
> [    6.347126] pci 0000:00:1f.2: reg 20: [io  0x4020-0x403f]
> [    6.353647] pci 0000:00:1f.2: reg 24: [mem 0xd3110000-0xd31107ff]
> [    6.361011] pci 0000:00:1f.2: PME# supported from D3hot
> [    6.367323] pci 0000:00:1f.2: PME# disabled
> [    6.372510] pci 0000:00:1f.3: [8086:1d22] type 0 class 0x000c05
> [    6.379629] pci 0000:00:1f.3: reg 10: [mem 0xebf10000-0xebf100ff 64bit]
> [    6.387539] pci 0000:00:1f.3: reg 20: [io  0x4000-0x401f]
> [    6.394111] pci 0000:00:1f.4: [8086:1d23] type 0 class 0x001101
> [    6.401222] pci 0000:00:1f.4: reg 10: [mem 0xd3100000-0xd3100fff]
> [    6.408778] pci 0000:01:00.0: [8086:1d74] type 1 class 0x000604
> [    6.415884] pci 0000:01:00.0: reg 10: [mem 0xd3000000-0xd3003fff]
> [    6.423252] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
> [    6.430535] pci 0000:01:00.0: PME# disabled
> [    6.435697] pci 0000:00:01.0: PCI bridge to [bus 01-03]
> [    6.442015] pci 0000:00:01.0:   bridge window [mem 0xd3000000-0xd30fffff]
> [    6.450195] pci 0000:02:08.0: [8086:1d3f] type 1 class 0x000604
> [    6.457398] pci 0000:02:08.0: PME# supported from D0 D3hot D3cold
> [    6.464673] pci 0000:02:08.0: PME# disabled
> [    6.469899] pci 0000:01:00.0: PCI bridge to [bus 02-03]
> [    6.476312] pci 0000:02:08.0: PCI bridge to [bus 03-03]
> [    6.482766] pci 0000:00:01.1: PCI bridge to [bus 04-04]
> [    6.489192] pci 0000:00:02.0: PCI bridge to [bus 05-05]
> [    6.495623] pci 0000:00:02.2: PCI bridge to [bus 06-06]
> [    6.502052] pci 0000:00:03.0: PCI bridge to [bus 07-07]
> [    6.508478] pci 0000:00:03.2: PCI bridge to [bus 08-08]
> [    6.514940] pci 0000:09:00.0: [8086:150e] type 0 class 0x000200
> [    6.522057] pci 0000:09:00.0: reg 10: [mem 0xd2e80000-0xd2efffff]
> [    6.529378] pci 0000:09:00.0: reg 18: [io  0x3060-0x307f]
> [    6.535903] pci 0000:09:00.0: reg 1c: [mem 0xd2f30000-0xd2f33fff]
> [    6.543317] pci 0000:09:00.0: PME# supported from D0 D3hot D3cold
> [    6.550605] pci 0000:09:00.0: PME# disabled
> [    6.555832] pci 0000:09:00.1: [8086:150e] type 0 class 0x000200
> [    6.562946] pci 0000:09:00.1: reg 10: [mem 0xd2e00000-0xd2e7ffff]
> [    6.570267] pci 0000:09:00.1: reg 18: [io  0x3040-0x305f]
> [    6.576790] pci 0000:09:00.1: reg 1c: [mem 0xd2f20000-0xd2f23fff]
> [    6.584210] pci 0000:09:00.1: PME# supported from D0 D3hot D3cold
> [    6.591493] pci 0000:09:00.1: PME# disabled
> [    6.596712] pci 0000:09:00.2: [8086:150e] type 0 class 0x000200
> [    6.603827] pci 0000:09:00.2: reg 10: [mem 0xd2d80000-0xd2dfffff]
> [    6.611153] pci 0000:09:00.2: reg 18: [io  0x3020-0x303f]
> [    6.617678] pci 0000:09:00.2: reg 1c: [mem 0xd2f10000-0xd2f13fff]
> [    6.625099] pci 0000:09:00.2: PME# supported from D0 D3hot D3cold
> [    6.632384] pci 0000:09:00.2: PME# disabled
> [    6.637605] pci 0000:09:00.3: [8086:150e] type 0 class 0x000200
> [    6.644721] pci 0000:09:00.3: reg 10: [mem 0xd2d00000-0xd2d7ffff]
> [    6.652043] pci 0000:09:00.3: reg 18: [io  0x3000-0x301f]
> [    6.658568] pci 0000:09:00.3: reg 1c: [mem 0xd2f00000-0xd2f03fff]
> [    6.665993] pci 0000:09:00.3: PME# supported from D0 D3hot D3cold
> [    6.673278] pci 0000:09:00.3: PME# disabled
> [    6.678469] pci 0000:00:1c.0: PCI bridge to [bus 09-09]
> [    6.684773] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
> [    6.692058] pci 0000:00:1c.0:   bridge window [mem 0xd2d00000-0xd2ffffff]
> [    6.700227] pci 0000:00:1c.4: PCI bridge to [bus 0a-0a]
> [    6.706532] pci 0000:00:1c.4:   bridge window [io  0x2000-0x2fff]
> [    6.713815] pci 0000:00:1c.4:   bridge window [mem 0xd2300000-0xd2cfffff]
> [    6.721883] pci 0000:00:1c.4:   bridge window [mem 0xeb500000-0xebefffff 64bit pref]
> [    6.731509] pci 0000:00:1c.6: PCI bridge to [bus 0b-0b]
> [    6.737823] pci 0000:00:1c.6:   bridge window [io  0x1000-0x1fff]
> [    6.745111] pci 0000:00:1c.6:   bridge window [mem 0xd1900000-0xd22fffff]
> [    6.753179] pci 0000:00:1c.6:   bridge window [mem 0xeab00000-0xeb4fffff 64bit pref]
> [    6.762825] pci 0000:0c:00.0: [102b:0522] type 0 class 0x000300
> [    6.769947] pci 0000:0c:00.0: reg 10: [mem 0xd0000000-0xd0ffffff]
> [    6.777251] pci 0000:0c:00.0: reg 14: [mem 0xd1810000-0xd1813fff]
> [    6.784557] pci 0000:0c:00.0: reg 18: [mem 0xd1000000-0xd17fffff]
> [    6.791936] pci 0000:0c:00.0: reg 30: [mem 0xd1800000-0xd180ffff pref]
> [    6.799806] pci 0000:00:1c.7: PCI bridge to [bus 0c-0c]
> [    6.806124] pci 0000:00:1c.7:   bridge window [mem 0xd0000000-0xd18fffff]
> [    6.814332] pci 0000:00:1e.0: PCI bridge to [bus 0d-0d] (subtractive decode)
> [    6.822700] pci 0000:00:1e.0:   bridge window [io  0x0000-0xbfff] (subtractive decode)
> [    6.832404] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
> [    6.842880] pci 0000:00:1e.0:   bridge window [mem 0x000c0000-0x000c3fff] (subtractive decode)
> [    6.853362] pci 0000:00:1e.0:   bridge window [mem 0x000c4000-0x000c7fff] (subtractive decode)
> [    6.863842] pci 0000:00:1e.0:   bridge window [mem 0x000c8000-0x000cbfff] (subtractive decode)
> [    6.874324] pci 0000:00:1e.0:   bridge window [mem 0x000cc000-0x000cffff] (subtractive decode)
> [    6.884800] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
> [    6.895282] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
> [    6.905762] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
> [    6.916243] pci 0000:00:1e.0:   bridge window [mem 0x000dc000-0x000dffff] (subtractive decode)
> [    6.926724] pci 0000:00:1e.0:   bridge window [mem 0x000e0000-0x000e3fff] (subtractive decode)
> [    6.937202] pci 0000:00:1e.0:   bridge window [mem 0x000e4000-0x000e7fff] (subtractive decode)
> [    6.947679] pci 0000:00:1e.0:   bridge window [mem 0x000e8000-0x000ebfff] (subtractive decode)
> [    6.958159] pci 0000:00:1e.0:   bridge window [mem 0x000ec000-0x000effff] (subtractive decode)
> [    6.968638] pci 0000:00:1e.0:   bridge window [mem 0x000f0000-0x000fffff] (subtractive decode)
> [    6.979117] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xebffffff] (subtractive decode)
> [    6.989601] pci 0000:00:1e.0:   bridge window [mem 0x3f8000000000-0x3f807fffffff] (subtractive decode)
> [    7.000965] pci_bus 0000:00: on NUMA node 0 (pxm 0)
> [    7.016290] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    7.024368] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
> [    7.032203] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
> [    7.039965] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP07._PRT]
> [    7.047709] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP08._PRT]
> [    7.055468] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
> [    7.063198] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10.EPCU._PRT]
> [    7.071436] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10.EPCU.EVSP._PRT]
> [    7.080785] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
> [    7.088740] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
> [    7.096708] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR14._PRT]
> [    7.104698] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR18._PRT]
> [    7.112681] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR16._PRT]
> [    7.121581]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x19)
> [    7.206580] ACPI: PCI Root Bridge [PCI1] (domain 0000 [bus 80-fe])
> [    7.215844] pci_root PNP0A08:01: host bridge window [io  0xc000-0xffff]
> [    7.223715] pci_root PNP0A08:01: host bridge window [mem 0xec000000-0xfbffffff]
> [    7.232740] pci_root PNP0A08:01: host bridge window [mem 0x3f8080000000-0x3f80ffffffff]
> [    7.242589] pci 0000:80:02.0: [8086:3c04] type 1 class 0x000604
> [    7.249821] pci 0000:80:02.0: PME# supported from D0 D3hot D3cold
> [    7.257109] pci 0000:80:02.0: PME# disabled
> [    7.262324] pci 0000:80:04.0: [8086:3c20] type 0 class 0x000880
> [    7.269441] pci 0000:80:04.0: reg 10: [mem 0xfbf70000-0xfbf73fff 64bit]
> [    7.277492] pci 0000:80:04.1: [8086:3c21] type 0 class 0x000880
> [    7.284607] pci 0000:80:04.1: reg 10: [mem 0xfbf60000-0xfbf63fff 64bit]
> [    7.292653] pci 0000:80:04.2: [8086:3c22] type 0 class 0x000880
> [    7.299771] pci 0000:80:04.2: reg 10: [mem 0xfbf50000-0xfbf53fff 64bit]
> [    7.307820] pci 0000:80:04.3: [8086:3c23] type 0 class 0x000880
> [    7.314942] pci 0000:80:04.3: reg 10: [mem 0xfbf40000-0xfbf43fff 64bit]
> [    7.322986] pci 0000:80:04.4: [8086:3c24] type 0 class 0x000880
> [    7.330107] pci 0000:80:04.4: reg 10: [mem 0xfbf30000-0xfbf33fff 64bit]
> [    7.338157] pci 0000:80:04.5: [8086:3c25] type 0 class 0x000880
> [    7.345266] pci 0000:80:04.5: reg 10: [mem 0xfbf20000-0xfbf23fff 64bit]
> [    7.353326] pci 0000:80:04.6: [8086:3c26] type 0 class 0x000880
> [    7.360436] pci 0000:80:04.6: reg 10: [mem 0xfbf10000-0xfbf13fff 64bit]
> [    7.368482] pci 0000:80:04.7: [8086:3c27] type 0 class 0x000880
> [    7.375601] pci 0000:80:04.7: reg 10: [mem 0xfbf00000-0xfbf03fff 64bit]
> [    7.383644] pci 0000:80:05.0: [8086:3c28] type 0 class 0x000880
> [    7.390921] pci 0000:80:05.2: [8086:3c2a] type 0 class 0x000880
> [    7.398191] pci 0000:80:05.4: [8086:3c2c] type 0 class 0x000800
> [    7.405307] pci 0000:80:05.4: reg 10: [mem 0xec000000-0xec000fff]
> [    7.412749] pci 0000:80:06.0: [8086:3c60] type 0 class 0x000880
> [    7.420037] pci 0000:80:07.0: [8086:3c68] type 0 class 0x000600
> [    7.427419] pci 0000:80:02.0: PCI bridge to [bus 81-81]
> [    7.433766] pci_bus 0000:80: on NUMA node 1 (pxm 1)
> [    7.439694] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1._PRT]
> [    7.447224] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.BR44._PRT]
> [    7.455582]  pci0000:80: Unable to request _OSC control (_OSC support mask: 0x19)
> [    7.476858] ACPI: PCI Root Bridge [UCR0] (domain 0000 [bus 7f])
> [    7.484398] pci 0000:7f:08.0: [8086:3c80] type 0 class 0x000880
> [    7.491628] pci 0000:7f:08.3: [8086:3c83] type 0 class 0x000880
> [    7.498865] pci 0000:7f:08.4: [8086:3c84] type 0 class 0x000880
> [    7.506112] pci 0000:7f:09.0: [8086:3c90] type 0 class 0x000880
> [    7.513331] pci 0000:7f:09.3: [8086:3c93] type 0 class 0x000880
> [    7.520562] pci 0000:7f:09.4: [8086:3c94] type 0 class 0x000880
> [    7.527806] pci 0000:7f:0a.0: [8086:3cc0] type 0 class 0x000880
> [    7.535028] pci 0000:7f:0a.1: [8086:3cc1] type 0 class 0x000880
> [    7.542231] pci 0000:7f:0a.2: [8086:3cc2] type 0 class 0x000880
> [    7.549444] pci 0000:7f:0a.3: [8086:3cd0] type 0 class 0x000880
> [    7.556656] pci 0000:7f:0b.0: [8086:3ce0] type 0 class 0x000880
> [    7.563859] pci 0000:7f:0b.3: [8086:3ce3] type 0 class 0x000880
> [    7.571075] pci 0000:7f:0c.0: [8086:3ce8] type 0 class 0x000880
> [    7.578281] pci 0000:7f:0c.1: [8086:3ce8] type 0 class 0x000880
> [    7.585482] pci 0000:7f:0c.2: [8086:3ce8] type 0 class 0x000880
> [    7.592682] pci 0000:7f:0c.3: [8086:3ce8] type 0 class 0x000880
> [    7.599895] pci 0000:7f:0c.6: [8086:3cf4] type 0 class 0x000880
> [    7.607095] pci 0000:7f:0c.7: [8086:3cf6] type 0 class 0x000880
> [    7.614300] pci 0000:7f:0d.0: [8086:3ce8] type 0 class 0x000880
> [    7.621511] pci 0000:7f:0d.1: [8086:3ce8] type 0 class 0x000880
> [    7.628714] pci 0000:7f:0d.2: [8086:3ce8] type 0 class 0x000880
> [    7.635922] pci 0000:7f:0d.3: [8086:3ce8] type 0 class 0x000880
> [    7.643128] pci 0000:7f:0d.6: [8086:3cf5] type 0 class 0x000880
> [    7.650332] pci 0000:7f:0e.0: [8086:3ca0] type 0 class 0x000880
> [    7.657538] pci 0000:7f:0e.1: [8086:3c46] type 0 class 0x001101
> [    7.664789] pci 0000:7f:0f.0: [8086:3ca8] type 0 class 0x000880
> [    7.672037] pci 0000:7f:0f.1: [8086:3c71] type 0 class 0x000880
> [    7.679274] pci 0000:7f:0f.2: [8086:3caa] type 0 class 0x000880
> [    7.686511] pci 0000:7f:0f.3: [8086:3cab] type 0 class 0x000880
> [    7.693741] pci 0000:7f:0f.4: [8086:3cac] type 0 class 0x000880
> [    7.700973] pci 0000:7f:0f.5: [8086:3cad] type 0 class 0x000880
> [    7.708202] pci 0000:7f:0f.6: [8086:3cae] type 0 class 0x000880
> [    7.715427] pci 0000:7f:10.0: [8086:3cb0] type 0 class 0x000880
> [    7.722665] pci 0000:7f:10.1: [8086:3cb1] type 0 class 0x000880
> [    7.729908] pci 0000:7f:10.2: [8086:3cb2] type 0 class 0x000880
> [    7.737143] pci 0000:7f:10.3: [8086:3cb3] type 0 class 0x000880
> [    7.744380] pci 0000:7f:10.4: [8086:3cb4] type 0 class 0x000880
> [    7.751615] pci 0000:7f:10.5: [8086:3cb5] type 0 class 0x000880
> [    7.758857] pci 0000:7f:10.6: [8086:3cb6] type 0 class 0x000880
> [    7.766095] pci 0000:7f:10.7: [8086:3cb7] type 0 class 0x000880
> [    7.773322] pci 0000:7f:11.0: [8086:3cb8] type 0 class 0x000880
> [    7.780561] pci 0000:7f:13.0: [8086:3ce4] type 0 class 0x000880
> [    7.787770] pci 0000:7f:13.1: [8086:3c43] type 0 class 0x001101
> [    7.794981] pci 0000:7f:13.4: [8086:3ce6] type 0 class 0x001101
> [    7.802182] pci 0000:7f:13.5: [8086:3c44] type 0 class 0x001101
> [    7.809383] pci 0000:7f:13.6: [8086:3c45] type 0 class 0x000880
> [    7.816624]  pci0000:7f: Unable to request _OSC control (_OSC support mask: 0x19)
> [    7.835928] ACPI: PCI Root Bridge [UCR1] (domain 0000 [bus ff])
> [    7.843459] pci 0000:ff:08.0: [8086:3c80] type 0 class 0x000880
> [    7.850693] pci 0000:ff:08.3: [8086:3c83] type 0 class 0x000880
> [    7.857941] pci 0000:ff:08.4: [8086:3c84] type 0 class 0x000880
> [    7.865179] pci 0000:ff:09.0: [8086:3c90] type 0 class 0x000880
> [    7.872403] pci 0000:ff:09.3: [8086:3c93] type 0 class 0x000880
> [    7.879649] pci 0000:ff:09.4: [8086:3c94] type 0 class 0x000880
> [    7.886919] pci 0000:ff:0a.0: [8086:3cc0] type 0 class 0x000880
> [    7.894128] pci 0000:ff:0a.1: [8086:3cc1] type 0 class 0x000880
> [    7.901334] pci 0000:ff:0a.2: [8086:3cc2] type 0 class 0x000880
> [    7.908543] pci 0000:ff:0a.3: [8086:3cd0] type 0 class 0x000880
> [    7.915768] pci 0000:ff:0b.0: [8086:3ce0] type 0 class 0x000880
> [    7.922992] pci 0000:ff:0b.3: [8086:3ce3] type 0 class 0x000880
> [    7.930215] pci 0000:ff:0c.0: [8086:3ce8] type 0 class 0x000880
> [    7.937412] pci 0000:ff:0c.1: [8086:3ce8] type 0 class 0x000880
> [    7.944618] pci 0000:ff:0c.2: [8086:3ce8] type 0 class 0x000880
> [    7.951829] pci 0000:ff:0c.3: [8086:3ce8] type 0 class 0x000880
> [    7.959039] pci 0000:ff:0c.6: [8086:3cf4] type 0 class 0x000880
> [    7.966243] pci 0000:ff:0c.7: [8086:3cf6] type 0 class 0x000880
> [    7.973451] pci 0000:ff:0d.0: [8086:3ce8] type 0 class 0x000880
> [    7.980670] pci 0000:ff:0d.1: [8086:3ce8] type 0 class 0x000880
> [    7.987877] pci 0000:ff:0d.2: [8086:3ce8] type 0 class 0x000880
> [    7.995084] pci 0000:ff:0d.3: [8086:3ce8] type 0 class 0x000880
> [    8.002293] pci 0000:ff:0d.6: [8086:3cf5] type 0 class 0x000880
> [    8.009503] pci 0000:ff:0e.0: [8086:3ca0] type 0 class 0x000880
> [    8.016725] pci 0000:ff:0e.1: [8086:3c46] type 0 class 0x001101
> [    8.023971] pci 0000:ff:0f.0: [8086:3ca8] type 0 class 0x000880
> [    8.031208] pci 0000:ff:0f.1: [8086:3c71] type 0 class 0x000880
> [    8.038459] pci 0000:ff:0f.2: [8086:3caa] type 0 class 0x000880
> [    8.045709] pci 0000:ff:0f.3: [8086:3cab] type 0 class 0x000880
> [    8.052952] pci 0000:ff:0f.4: [8086:3cac] type 0 class 0x000880
> [    8.060192] pci 0000:ff:0f.5: [8086:3cad] type 0 class 0x000880
> [    8.067429] pci 0000:ff:0f.6: [8086:3cae] type 0 class 0x000880
> [    8.074669] pci 0000:ff:10.0: [8086:3cb0] type 0 class 0x000880
> [    8.081912] pci 0000:ff:10.1: [8086:3cb1] type 0 class 0x000880
> [    8.089151] pci 0000:ff:10.2: [8086:3cb2] type 0 class 0x000880
> [    8.096389] pci 0000:ff:10.3: [8086:3cb3] type 0 class 0x000880
> [    8.103632] pci 0000:ff:10.4: [8086:3cb4] type 0 class 0x000880
> [    8.110876] pci 0000:ff:10.5: [8086:3cb5] type 0 class 0x000880
> [    8.118112] pci 0000:ff:10.6: [8086:3cb6] type 0 class 0x000880
> [    8.125343] pci 0000:ff:10.7: [8086:3cb7] type 0 class 0x000880
> [    8.132580] pci 0000:ff:11.0: [8086:3cb8] type 0 class 0x000880
> [    8.139815] pci 0000:ff:13.0: [8086:3ce4] type 0 class 0x000880
> [    8.147020] pci 0000:ff:13.1: [8086:3c43] type 0 class 0x001101
> [    8.154241] pci 0000:ff:13.4: [8086:3ce6] type 0 class 0x001101
> [    8.161449] pci 0000:ff:13.5: [8086:3c44] type 0 class 0x001101
> [    8.168661] pci 0000:ff:13.6: [8086:3c45] type 0 class 0x000880
> [    8.175909]  pci0000:ff: Unable to request _OSC control (_OSC support mask: 0x19)
> [    8.195602] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
> [    8.204994] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 15)
> [    8.214377] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 10 11 12 14 15)
> [    8.223774] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 *11 12 14 15)
> [    8.233154] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 10 11 12 14 15)
> [    8.242547] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 *11 12 14 15)
> [    8.251933] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *10 11 12 14 15)
> [    8.261300] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *10 11 12 14 15)
> [    8.271443] vgaarb: device added: PCI:0000:0c:00.0,decodes=io+mem,owns=io+mem,locks=none
> [    8.281679] vgaarb: loaded
> [    8.285168] vgaarb: bridge control possible 0000:0c:00.0
> [    8.292235] SCSI subsystem initialized
> [    8.297438] libata version 3.00 loaded.
> [    8.302618] usbcore: USB support disabled
> [    8.309130] wmi: Mapper loaded
> [    8.313201] Advanced Linux Sound Architecture Driver Version 1.0.24.
> [    8.320776] PCI: Using ACPI for IRQ routing
> [    8.337277] PCI: pci_cache_line_size set to 64 bytes
> [    8.344866] reserve RAM buffer: 000000000009bc00 - 000000000009ffff 
> [    8.351865] reserve RAM buffer: 00000000ab664000 - 00000000abffffff 
> [    8.359521] reserve RAM buffer: 00000000bea7d000 - 00000000bfffffff 
> [    8.367186] reserve RAM buffer: 00000000beaf2000 - 00000000bfffffff 
> [    8.374850] reserve RAM buffer: 00000000bed2e000 - 00000000bfffffff 
> [    8.382514] reserve RAM buffer: 00000000bf000000 - 00000000bfffffff 
> [    8.471360] pnp: PnP ACPI init
> [    8.475950] ACPI: bus type pnp registered
> [    8.481893] pnp 00:00: [bus 00-7e]
> [    8.486164] pnp 00:00: [io  0x0000-0x0cf7 window]
> [    8.501282] pnp 00:00: [io  0x0cf8-0x0cff]
> [    8.506337] pnp 00:00: [io  0x0000-0xbfff window]
> [    8.512063] pnp 00:00: [mem 0x000a0000-0x000bffff window]
> [    8.518567] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
> [    8.525071] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
> [    8.531577] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
> [    8.538088] pnp 00:00: [mem 0x000cc000-0x000cffff window]
> [    8.544593] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
> [    8.551096] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
> [    8.557604] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
> [    8.564098] pnp 00:00: [mem 0x000dc000-0x000dffff window]
> [    8.570605] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
> [    8.577113] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
> [    8.583618] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
> [    8.590118] pnp 00:00: [mem 0x000ec000-0x000effff window]
> [    8.596620] pnp 00:00: [mem 0x000f0000-0x000fffff window]
> [    8.603121] pnp 00:00: [mem 0xd0000000-0xebffffff window]
> [    8.609625] pnp 00:00: [mem 0x3f8000000000-0x3f807fffffff window]
> [    8.616903] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
> [    8.624092] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
> [    8.633086] pnp 00:01: [io  0x0000-0x001f]
> [    8.638132] pnp 00:01: [io  0x0081-0x0091]
> [    8.643176] pnp 00:01: [io  0x0093-0x009f]
> [    8.648229] pnp 00:01: [io  0x00c0-0x00df]
> [    8.653284] pnp 00:01: [dma 4]
> [    8.657370] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
> [    8.665190] pnp 00:02: [mem 0xff000000-0xffffffff]
> [    8.671201] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
> [    8.679324] pnp 00:03: [mem 0xfed00000-0xfed003ff]
> [    8.685364] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
> [    8.693190] pnp 00:04: [io  0x00f0]
> [    8.697569] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:0)
> [    8.707483] pnp 00:04: [irq 13]
> [    8.711689] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
> [    8.719577] pnp 00:05: [io  0x002e-0x002f]
> [    8.724624] pnp 00:05: [io  0x004e-0x004f]
> [    8.729674] pnp 00:05: [io  0x0061]
> [    8.734037] pnp 00:05: [io  0x0063]
> [    8.738403] pnp 00:05: [io  0x0065]
> [    8.742765] pnp 00:05: [io  0x0067]
> [    8.747129] pnp 00:05: [io  0x0070]
> [    8.751493] pnp 00:05: [io  0x0080]
> [    8.755853] pnp 00:05: [io  0x0092]
> [    8.760220] pnp 00:05: [io  0x00b2-0x00b3]
> [    8.765267] pnp 00:05: [io  0x0680-0x069f]
> [    8.770317] pnp 00:05: [io  0xffff]
> [    8.774681] pnp 00:05: [io  0xffff]
> [    8.779053] pnp 00:05: [io  0xffff]
> [    8.783420] pnp 00:05: [io  0x0400-0x0453]
> [    8.788463] pnp 00:05: [io  0x0458-0x047f]
> [    8.793506] pnp 00:05: [io  0x0500-0x057f]
> [    8.798554] pnp 00:05: [io  0x164e-0x164f]
> [    8.803691] pnp 00:05: disabling [io  0x164e-0x164f] because it overlaps 0000:00:1c.6 BAR 7 [io  0x1000-0x1fff]
> [    8.816442] system 00:05: [io  0x0680-0x069f] has been reserved
> [    8.823531] system 00:05: [io  0xffff] has been reserved
> [    8.829939] system 00:05: [io  0xffff] has been reserved
> [    8.836359] system 00:05: [io  0xffff] has been reserved
> [    8.842768] system 00:05: [io  0x0400-0x0453] has been reserved
> [    8.849854] system 00:05: [io  0x0458-0x047f] has been reserved
> [    8.856942] system 00:05: [io  0x0500-0x057f] has been reserved
> [    8.864034] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    8.872133] pnp 00:06: [io  0x0070-0x0077]
> [    8.877193] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:0)
> [    8.886902] pnp 00:06: [irq 8]
> [    8.890993] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    8.898908] pnp 00:07: [io  0x0454-0x0457]
> [    8.904672] system 00:07: [io  0x0454-0x0457] has been reserved
> [    8.911767] system 00:07: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
> [    8.922321] pnp 00:08: [io  0x03f8-0x03ff]
> [    8.927376] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:0)
> [    8.937093] pnp 00:08: [irq 4]
> [    8.940980] pnp 00:08: [dma 0 disabled]
> [    8.946061] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
> [    8.954831] pnp 00:09: [io  0x02f8-0x02ff]
> [    8.959896] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:0)
> [    8.969613] pnp 00:09: [irq 3]
> [    8.973494] pnp 00:09: [dma 0 disabled]
> [    8.978584] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
> [    8.988794] pnp 00:0a: [mem 0xfed1c000-0xfed1ffff]
> [    8.994629] pnp 00:0a: [mem 0xc0000000-0xcfffffff]
> [    9.000453] pnp 00:0a: [mem 0xfed20000-0xfed3ffff]
> [    9.006277] pnp 00:0a: [mem 0xebffc000-0xebffdfff]
> [    9.012093] pnp 00:0a: [mem 0xfbffe000-0xfbffffff]
> [    9.017923] pnp 00:0a: [mem 0x00000000-0xffffffffffffffff disabled]
> [    9.025401] pnp 00:0a: [mem 0x00000000-0xffffffffffffffff disabled]
> [    9.032873] pnp 00:0a: [mem 0xfed45000-0xfed8ffff]
> [    9.038690] pnp 00:0a: [mem 0xff000000-0xffffffff]
> [    9.044518] pnp 00:0a: [mem 0xfee00000-0xfeefffff]
> [    9.050340] pnp 00:0a: [mem 0xfec00000-0xfecfffff]
> [    9.056166] pnp 00:0a: [mem 0x00000000-0xffffffffffffffff disabled]
> [    9.064358] system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserved
> [    9.072227] system 00:0a: [mem 0xc0000000-0xcfffffff] has been reserved
> [    9.080096] system 00:0a: [mem 0xfed20000-0xfed3ffff] has been reserved
> [    9.087966] system 00:0a: [mem 0xebffc000-0xebffdfff] has been reserved
> [    9.095834] system 00:0a: [mem 0xfbffe000-0xfbffffff] has been reserved
> [    9.103705] system 00:0a: [mem 0xfed45000-0xfed8ffff] has been reserved
> [    9.111572] system 00:0a: [mem 0xff000000-0xffffffff] could not be reserved
> [    9.119827] system 00:0a: [mem 0xfee00000-0xfeefffff] could not be reserved
> [    9.128082] system 00:0a: [mem 0xfec00000-0xfecfffff] could not be reserved
> [    9.136339] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    9.146148] pnp 00:0b: [bus 80-fe]
> [    9.150421] pnp 00:0b: [io  0xc000-0xffff window]
> [    9.156146] pnp 00:0b: [mem 0xec000000-0xfbffffff window]
> [    9.162650] pnp 00:0b: [mem 0x3f8080000000-0x3f80ffffffff window]
> [    9.170610] pnp 00:0b: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
> [    9.179921] pnp 00:0c: [mem 0x00000000-0x0009cfff]
> [    9.186809] system 00:0c: [mem 0x00000000-0x0009cfff] could not be reserved
> [    9.195071] system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
> [    9.204254] pnp 00:0d: [bus 7f]
> [    9.208876] pnp 00:0d: Plug and Play ACPI device, IDs PNP0a03 (active)
> [    9.216880] pnp 00:0e: [bus ff]
> [    9.221511] pnp 00:0e: Plug and Play ACPI device, IDs PNP0a03 (active)
> [    9.229553] pnp: PnP ACPI: found 15 devices
> [    9.234704] ACPI: ACPI bus type pnp unregistered
> [    9.263328] Switching to clocksource acpi_pm
> [    9.269368] PCI: max bus depth: 3 pci_try_num: 4
> [    9.275330] pci 0000:02:08.0: PCI bridge to [bus 03-03]
> [    9.281665] pci 0000:01:00.0: PCI bridge to [bus 02-03]
> [    9.287999] pci 0000:00:01.0: PCI bridge to [bus 01-03]
> [    9.294319] pci 0000:00:01.0:   bridge window [mem 0xd3000000-0xd30fffff]
> [    9.302395] pci 0000:00:01.1: PCI bridge to [bus 04-04]
> [    9.308728] pci 0000:00:02.0: PCI bridge to [bus 05-05]
> [    9.315063] pci 0000:00:02.2: PCI bridge to [bus 06-06]
> [    9.321397] pci 0000:00:03.0: PCI bridge to [bus 07-07]
> [    9.327731] pci 0000:00:03.2: PCI bridge to [bus 08-08]
> [    9.334066] pci 0000:00:1c.0: PCI bridge to [bus 09-09]
> [    9.340382] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
> [    9.347677] pci 0000:00:1c.0:   bridge window [mem 0xd2d00000-0xd2ffffff]
> [    9.355756] pci 0000:00:1c.4: PCI bridge to [bus 0a-0a]
> [    9.362072] pci 0000:00:1c.4:   bridge window [io  0x2000-0x2fff]
> [    9.369366] pci 0000:00:1c.4:   bridge window [mem 0xd2300000-0xd2cfffff]
> [    9.377437] pci 0000:00:1c.4:   bridge window [mem 0xeb500000-0xebefffff 64bit pref]
> [    9.386960] pci 0000:00:1c.6: PCI bridge to [bus 0b-0b]
> [    9.393274] pci 0000:00:1c.6:   bridge window [io  0x1000-0x1fff]
> [    9.400568] pci 0000:00:1c.6:   bridge window [mem 0xd1900000-0xd22fffff]
> [    9.408637] pci 0000:00:1c.6:   bridge window [mem 0xeab00000-0xeb4fffff 64bit pref]
> [    9.418161] pci 0000:00:1c.7: PCI bridge to [bus 0c-0c]
> [    9.424479] pci 0000:00:1c.7:   bridge window [mem 0xd0000000-0xd18fffff]
> [    9.432557] pci 0000:00:1e.0: PCI bridge to [bus 0d-0d]
> [    9.438898] pci 0000:80:02.0: PCI bridge to [bus 81-81]
> [    9.445326] IOAPIC[1]: Set routing entry (1-23 -> 0x29 -> IRQ 47 Mode:1 Active:1 Dest:0)
> [    9.455246] pci 0000:00:01.0: PCI INT A -> GSI 47 (level, low) -> IRQ 47
> [    9.463249] IOAPIC[1]: Set routing entry (1-2 -> 0x41 -> IRQ 26 Mode:1 Active:1 Dest:0)
> [    9.473060] pci 0000:01:00.0: PCI INT A -> GSI 26 (level, low) -> IRQ 26
> [    9.481036] pci 0000:02:08.0: PCI INT A -> GSI 26 (level, low) -> IRQ 26
> [    9.489013] pci 0000:00:01.1: PCI INT A -> GSI 47 (level, low) -> IRQ 47
> [    9.496993] pci 0000:00:02.0: PCI INT A -> GSI 47 (level, low) -> IRQ 47
> [    9.504968] pci 0000:00:02.2: PCI INT A -> GSI 47 (level, low) -> IRQ 47
> [    9.512945] pci 0000:00:03.0: PCI INT A -> GSI 47 (level, low) -> IRQ 47
> [    9.520922] pci 0000:00:03.2: PCI INT A -> GSI 47 (level, low) -> IRQ 47
> [    9.528921] IOAPIC[0]: Set routing entry (0-16 -> 0x49 -> IRQ 16 Mode:1 Active:1 Dest:0)
> [    9.538834] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    9.546819] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    9.554817] IOAPIC[0]: Set routing entry (0-18 -> 0x51 -> IRQ 18 Mode:1 Active:1 Dest:0)
> [    9.564724] pci 0000:00:1c.6: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [    9.572723] IOAPIC[0]: Set routing entry (0-19 -> 0x59 -> IRQ 19 Mode:1 Active:1 Dest:0)
> [    9.582627] pci 0000:00:1c.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
> [    9.590619] pci 0000:00:1e.0: setting latency timer to 64
> [    9.597221] IOAPIC[2]: Set routing entry (2-23 -> 0x61 -> IRQ 71 Mode:1 Active:1 Dest:0)
> [    9.607137] pci 0000:80:02.0: PCI INT A -> GSI 71 (level, low) -> IRQ 71
> [    9.615121] pci_bus 0000:00: resource 4 [io  0x0000-0xbfff]
> [    9.621827] pci_bus 0000:00: resource 5 [mem 0x000a0000-0x000bffff]
> [    9.629309] pci_bus 0000:00: resource 6 [mem 0x000c0000-0x000c3fff]
> [    9.636791] pci_bus 0000:00: resource 7 [mem 0x000c4000-0x000c7fff]
> [    9.653669] pci_bus 0000:00: resource 8 [mem 0x000c8000-0x000cbfff]
> [    9.661147] pci_bus 0000:00: resource 9 [mem 0x000cc000-0x000cffff]
> [    9.668626] pci_bus 0000:00: resource 10 [mem 0x000d0000-0x000d3fff]
> [    9.676208] pci_bus 0000:00: resource 11 [mem 0x000d4000-0x000d7fff]
> [    9.683786] pci_bus 0000:00: resource 12 [mem 0x000d8000-0x000dbfff]
> [    9.691352] pci_bus 0000:00: resource 13 [mem 0x000dc000-0x000dffff]
> [    9.698931] pci_bus 0000:00: resource 14 [mem 0x000e0000-0x000e3fff]
> [    9.706497] pci_bus 0000:00: resource 15 [mem 0x000e4000-0x000e7fff]
> [    9.714076] pci_bus 0000:00: resource 16 [mem 0x000e8000-0x000ebfff]
> [    9.721653] pci_bus 0000:00: resource 17 [mem 0x000ec000-0x000effff]
> [    9.729229] pci_bus 0000:00: resource 18 [mem 0x000f0000-0x000fffff]
> [    9.736805] pci_bus 0000:00: resource 19 [mem 0xd0000000-0xebffffff]
> [    9.744381] pci_bus 0000:00: resource 20 [mem 0x3f8000000000-0x3f807fffffff]
> [    9.752734] pci_bus 0000:01: resource 1 [mem 0xd3000000-0xd30fffff]
> [    9.760215] pci_bus 0000:09: resource 0 [io  0x3000-0x3fff]
> [    9.766919] pci_bus 0000:09: resource 1 [mem 0xd2d00000-0xd2ffffff]
> [    9.774397] pci_bus 0000:0a: resource 0 [io  0x2000-0x2fff]
> [    9.781102] pci_bus 0000:0a: resource 1 [mem 0xd2300000-0xd2cfffff]
> [    9.788580] pci_bus 0000:0a: resource 2 [mem 0xeb500000-0xebefffff 64bit pref]
> [    9.797518] pci_bus 0000:0b: resource 0 [io  0x1000-0x1fff]
> [    9.804217] pci_bus 0000:0b: resource 1 [mem 0xd1900000-0xd22fffff]
> [    9.811697] pci_bus 0000:0b: resource 2 [mem 0xeab00000-0xeb4fffff 64bit pref]
> [    9.820625] pci_bus 0000:0c: resource 1 [mem 0xd0000000-0xd18fffff]
> [    9.828107] pci_bus 0000:0d: resource 4 [io  0x0000-0xbfff]
> [    9.834811] pci_bus 0000:0d: resource 5 [mem 0x000a0000-0x000bffff]
> [    9.842291] pci_bus 0000:0d: resource 6 [mem 0x000c0000-0x000c3fff]
> [    9.849772] pci_bus 0000:0d: resource 7 [mem 0x000c4000-0x000c7fff]
> [    9.857248] pci_bus 0000:0d: resource 8 [mem 0x000c8000-0x000cbfff]
> [    9.864727] pci_bus 0000:0d: resource 9 [mem 0x000cc000-0x000cffff]
> [    9.872207] pci_bus 0000:0d: resource 10 [mem 0x000d0000-0x000d3fff]
> [    9.879782] pci_bus 0000:0d: resource 11 [mem 0x000d4000-0x000d7fff]
> [    9.887356] pci_bus 0000:0d: resource 12 [mem 0x000d8000-0x000dbfff]
> [    9.894939] pci_bus 0000:0d: resource 13 [mem 0x000dc000-0x000dffff]
> [    9.902514] pci_bus 0000:0d: resource 14 [mem 0x000e0000-0x000e3fff]
> [    9.910088] pci_bus 0000:0d: resource 15 [mem 0x000e4000-0x000e7fff]
> [    9.917667] pci_bus 0000:0d: resource 16 [mem 0x000e8000-0x000ebfff]
> [    9.925241] pci_bus 0000:0d: resource 17 [mem 0x000ec000-0x000effff]
> [    9.932819] pci_bus 0000:0d: resource 18 [mem 0x000f0000-0x000fffff]
> [    9.940395] pci_bus 0000:0d: resource 19 [mem 0xd0000000-0xebffffff]
> [    9.947971] pci_bus 0000:0d: resource 20 [mem 0x3f8000000000-0x3f807fffffff]
> [    9.956325] pci_bus 0000:80: resource 4 [io  0xc000-0xffff]
> [    9.963027] pci_bus 0000:80: resource 5 [mem 0xec000000-0xfbffffff]
> [    9.970509] pci_bus 0000:80: resource 6 [mem 0x3f8080000000-0x3f80ffffffff]
> [    9.979065] NET: Registered protocol family 2
> [    9.987231] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
> [   10.003175] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
> [   10.018117] TCP bind hash table entries: 65536 (order: 10, 5242880 bytes)
> [   10.033313] TCP: Hash tables configured (established 524288 bind 65536)
> [   10.041211] TCP reno registered
> [   10.046914] UDP hash table entries: 16384 (order: 9, 3145728 bytes)
> [   10.059843] UDP-Lite hash table entries: 16384 (order: 9, 3145728 bytes)
> [   10.072696] NET: Registered protocol family 1
> [   10.078670] RPC: Registered named UNIX socket transport module.
> [   10.085788] RPC: Registered udp transport module.
> [   10.091520] RPC: Registered tcp transport module.
> [   10.097249] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [   10.105246] pci 0000:00:1a.0: EHCI: BIOS handoff
> [   10.121607] pci 0000:00:1d.0: EHCI: BIOS handoff
> [   10.138510] pci 0000:0c:00.0: Boot video device
> [   10.144758] PCI: CLS 64 bytes, default 64
> [   10.149960] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> [   10.157645] Placing 64MB software IO TLB between ffff8800b7060000 - ffff8800bb060000
> [   10.167173] software IO TLB at phys 0xb7060000 - 0xbb060000
> [   10.175529] Simple Boot Flag at 0x4f set to 0x1
> [   10.215053] Machine check injector initialized
> [   10.238139] microcode: CPU0 sig=0x206d2, pf=0x1, revision=0x80000206
> [   10.245721] microcode: CPU1 sig=0x206d2, pf=0x1, revision=0x80000206
> [   10.253288] microcode: CPU2 sig=0x206d2, pf=0x1, revision=0x80000206
> [   10.260858] microcode: CPU3 sig=0x206d2, pf=0x1, revision=0x80000206
> [   10.268427] microcode: CPU4 sig=0x206d2, pf=0x1, revision=0x80000206
> [   10.275993] microcode: CPU5 sig=0x206d2, pf=0x1, revision=0x80000206
> [   10.283576] microcode: CPU6 sig=0x206d2, pf=0x1, revision=0x80000206
> [   10.291133] microcode: CPU7 sig=0x206d2, pf=0x1, revision=0x80000206
> [   10.298704] microcode: CPU8 sig=0x206d2, pf=0x1, revision=0x80000206
> [   10.306300] microcode: CPU9 sig=0x206d2, pf=0x1, revision=0x80000206
> [   10.313906] microcode: CPU10 sig=0x206d2, pf=0x1, revision=0x80000206
> [   10.321596] microcode: CPU11 sig=0x206d2, pf=0x1, revision=0x80000206
> [   10.329288] microcode: CPU12 sig=0x206d2, pf=0x1, revision=0x80000206
> [   10.336987] microcode: CPU13 sig=0x206d2, pf=0x1, revision=0x80000206
> [   10.344687] microcode: CPU14 sig=0x206d2, pf=0x1, revision=0x80000206
> [   10.352384] microcode: CPU15 sig=0x206d2, pf=0x1, revision=0x80000206
> [   10.360079] microcode: CPU16 sig=0x206d2, pf=0x1, revision=0x80000206
> [   10.367756] microcode: CPU17 sig=0x206d2, pf=0x1, revision=0x80000206
> [   10.375408] microcode: CPU18 sig=0x206d2, pf=0x1, revision=0x80000206
> [   10.383069] microcode: CPU19 sig=0x206d2, pf=0x1, revision=0x80000206
> [   10.390728] microcode: CPU20 sig=0x206d2, pf=0x1, revision=0x80000206
> [   10.398387] microcode: CPU21 sig=0x206d2, pf=0x1, revision=0x80000206
> [   10.406047] microcode: CPU22 sig=0x206d2, pf=0x1, revision=0x80000206
> [   10.413710] microcode: CPU23 sig=0x206d2, pf=0x1, revision=0x80000206
> [   10.421373] microcode: CPU24 sig=0x206d2, pf=0x1, revision=0x80000206
> [   10.429068] microcode: CPU25 sig=0x206d2, pf=0x1, revision=0x80000206
> [   10.436762] microcode: CPU26 sig=0x206d2, pf=0x1, revision=0x80000206
> [   10.444465] microcode: CPU27 sig=0x206d2, pf=0x1, revision=0x80000206
> [   10.452158] microcode: CPU28 sig=0x206d2, pf=0x1, revision=0x80000206
> [   10.459853] microcode: CPU29 sig=0x206d2, pf=0x1, revision=0x80000206
> [   10.467548] microcode: CPU30 sig=0x206d2, pf=0x1, revision=0x80000206
> [   10.475240] microcode: CPU31 sig=0x206d2, pf=0x1, revision=0x80000206
> [   10.483235] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [   10.495050] audit: initializing netlink socket (disabled)
> [   10.501593] type=2000 audit(1320087409.028:1): initialized
> [   10.607787] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [   10.647797] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> [   10.658085] fuse init (API version 7.17)
> [   10.664673] JFS: nTxBlock = 8192, nTxLock = 65536
> [   10.680613] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
> [   10.696805] NILFS version 2 loaded
> [   10.703797] Btrfs loaded
> [   10.707128] msgmni has been set to 32768
> [   10.714980] async_tx: api initialized (async)
> [   10.720833] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
> [   10.730146] io scheduler noop registered
> [   10.735007] io scheduler deadline registered
> [   10.740636] io scheduler cfq registered (default)
> [   10.751131] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [   10.759686] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> [   10.768873] ACPI: Power Button [PWRF]
> [   10.778999] ACPI: acpi_idle registered with cpuidle
> [   10.790752] Monitor-Mwait will be used to enter C-1 state
> [   10.797380] Monitor-Mwait will be used to enter C-2 state
> [   10.803983] Monitor-Mwait will be used to enter C-3 state
> [   11.030353] ioatdma: Intel(R) QuickData Technology Driver 4.00
> [   11.037609] IOAPIC[1]: Set routing entry (1-7 -> 0x69 -> IRQ 31 Mode:1 Active:1 Dest:0)
> [   11.047419] ioatdma 0000:00:04.0: PCI INT A -> GSI 31 (level, low) -> IRQ 31
> [   11.056270] ioatdma 0000:00:04.0: irq 88 for MSI/MSI-X
> [   11.063418] work_for_cpu used greatest stack depth: 5176 bytes left
> [   11.070937] IOAPIC[1]: Set routing entry (1-15 -> 0x79 -> IRQ 39 Mode:1 Active:1 Dest:0)
> [   11.080825] ioatdma 0000:00:04.1: PCI INT B -> GSI 39 (level, low) -> IRQ 39
> [   11.089565] ioatdma 0000:00:04.1: irq 89 for MSI/MSI-X
> [   11.096606] ioatdma 0000:00:04.2: PCI INT C -> GSI 31 (level, low) -> IRQ 31
> [   11.105366] ioatdma 0000:00:04.2: irq 90 for MSI/MSI-X
> [   11.112431] ioatdma 0000:00:04.3: PCI INT D -> GSI 39 (level, low) -> IRQ 39
> [   11.121196] ioatdma 0000:00:04.3: irq 91 for MSI/MSI-X
> [   11.128255] ioatdma 0000:00:04.4: PCI INT A -> GSI 31 (level, low) -> IRQ 31
> [   11.137005] ioatdma 0000:00:04.4: irq 92 for MSI/MSI-X
> [   11.144047] ioatdma 0000:00:04.5: PCI INT B -> GSI 39 (level, low) -> IRQ 39
> [   11.152796] ioatdma 0000:00:04.5: irq 93 for MSI/MSI-X
> [   11.159800] ioatdma 0000:00:04.6: PCI INT C -> GSI 31 (level, low) -> IRQ 31
> [   11.168534] ioatdma 0000:00:04.6: irq 94 for MSI/MSI-X
> [   11.175546] ioatdma 0000:00:04.7: PCI INT D -> GSI 39 (level, low) -> IRQ 39
> [   11.181876] Refined TSC clocksource calibration: 2300.002 MHz.
> [   11.181882] Switching to clocksource tsc
> [   11.196214] ioatdma 0000:00:04.7: irq 95 for MSI/MSI-X
> [   11.203131] work_for_cpu used greatest stack depth: 5144 bytes left
> [   11.203354] IOAPIC[2]: Set routing entry (2-7 -> 0xb9 -> IRQ 55 Mode:1 Active:1 Dest:0)
> [   11.203364] ioatdma 0000:80:04.0: PCI INT A -> GSI 55 (level, low) -> IRQ 55
> [   11.203862] ioatdma 0000:80:04.0: irq 96 for MSI/MSI-X
> [   11.235793] IOAPIC[2]: Set routing entry (2-15 -> 0xc9 -> IRQ 63 Mode:1 Active:1 Dest:0)
> [   11.245708] ioatdma 0000:80:04.1: PCI INT B -> GSI 63 (level, low) -> IRQ 63
> [   11.254438] ioatdma 0000:80:04.1: irq 97 for MSI/MSI-X
> [   11.261512] ioatdma 0000:80:04.2: PCI INT C -> GSI 55 (level, low) -> IRQ 55
> [   11.270254] ioatdma 0000:80:04.2: irq 98 for MSI/MSI-X
> [   11.277317] ioatdma 0000:80:04.3: PCI INT D -> GSI 63 (level, low) -> IRQ 63
> [   11.286066] ioatdma 0000:80:04.3: irq 99 for MSI/MSI-X
> [   11.293109] ioatdma 0000:80:04.4: PCI INT A -> GSI 55 (level, low) -> IRQ 55
> [   11.301845] ioatdma 0000:80:04.4: irq 100 for MSI/MSI-X
> [   11.309021] ioatdma 0000:80:04.5: PCI INT B -> GSI 63 (level, low) -> IRQ 63
> [   11.317775] ioatdma 0000:80:04.5: irq 101 for MSI/MSI-X
> [   11.324874] ioatdma 0000:80:04.6: PCI INT C -> GSI 55 (level, low) -> IRQ 55
> [   11.333622] ioatdma 0000:80:04.6: irq 102 for MSI/MSI-X
> [   11.340677] ioatdma 0000:80:04.7: PCI INT D -> GSI 63 (level, low) -> IRQ 63
> [   11.349407] ioatdma 0000:80:04.7: irq 103 for MSI/MSI-X
> [   11.461244] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [   11.489680] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [   11.527414] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> [   11.598553] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [   11.636974] 00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> [   11.655293] Initializing Nozomi driver 2.1d
> [   11.671520] hpet_acpi_add: no address or irqs in _CRS
> [   11.678184] Non-volatile memory driver v1.3
> [   11.686659] Linux agpgart interface v0.103
> [   11.692091] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
> [   11.702991] Hangcheck: Using getrawmonotonic().
> [   11.708709] [drm] Initialized drm 1.1.0 20060810
> [   11.714361] [drm:i915_init] *ERROR* drm/i915 can't work without intel_agp module!
> [   14.742225] floppy0: no floppy controllers found
> [   14.748362] ------------[ cut here ]------------
> [   14.754012] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
> [   14.764600] Hardware name: SandyBridge Platform
> [   14.770140] VFS: do_fd_request called on non-open device
> [   14.776553] Modules linked in:
> [   14.780528] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #881
> [   14.790931] Call Trace:
> [   14.794141]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
> [   14.801335]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
> [   14.808239]  [<ffffffff813ea19a>] ? blk_throtl_drain+0xf6/0x105
> [   14.815336]  [<ffffffff819830be>] ? _raw_spin_unlock_irq+0x30/0x3c
> [   14.822720]  [<ffffffff81519bcd>] do_fd_request+0x37/0xaa
> [   14.829235]  [<ffffffff813d78a6>] __blk_run_queue+0x1e/0x20
> [   14.835941]  [<ffffffff813dcdae>] blk_drain_queue+0x41/0x7a
> [   14.842642]  [<ffffffff813dcf0c>] blk_cleanup_queue+0x125/0x184
> [   14.849741]  [<ffffffff8213eb69>] floppy_init+0xd9c/0xdc2
> [   14.856253]  [<ffffffff8213ddcd>] ? daring+0x65/0x65
> [   14.862285]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
> [   14.869087]  [<ffffffff8210fc16>] kernel_init+0xcb/0x14f
> [   14.875509]  [<ffffffff8198bf04>] kernel_thread_helper+0x4/0x10
> [   14.882606]  [<ffffffff81983334>] ? retint_restore_args+0x13/0x13
> [   14.889893]  [<ffffffff8210fb4b>] ? start_kernel+0x390/0x390
> [   14.896695]  [<ffffffff8198bf00>] ? gs_change+0x13/0x13
> [   14.903012] ---[ end trace 4eaa2a86a8e2da25 ]---
> [   14.909113] ------------[ cut here ]------------
> [   14.914744] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
> [   14.925337] Hardware name: SandyBridge Platform
> [   14.930872] VFS: do_fd_request called on non-open device
> [   14.937284] Modules linked in:
> [   14.941260] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #881
> [   14.951658] Call Trace:
> [   14.954868]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
> [   14.962060]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
> [   14.968959]  [<ffffffff813ea19a>] ? blk_throtl_drain+0xf6/0x105
> [   14.976054]  [<ffffffff819830be>] ? _raw_spin_unlock_irq+0x30/0x3c
> [   14.983441]  [<ffffffff81519bcd>] do_fd_request+0x37/0xaa
> [   14.989950]  [<ffffffff813d78a6>] __blk_run_queue+0x1e/0x20
> [   14.996657]  [<ffffffff813dcdae>] blk_drain_queue+0x41/0x7a
> [   15.003364]  [<ffffffff813dcf0c>] blk_cleanup_queue+0x125/0x184
> [   15.010456]  [<ffffffff8213eb69>] floppy_init+0xd9c/0xdc2
> [   15.016967]  [<ffffffff8213ddcd>] ? daring+0x65/0x65
> [   15.022994]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
> [   15.029793]  [<ffffffff8210fc16>] kernel_init+0xcb/0x14f
> [   15.036208]  [<ffffffff8198bf04>] kernel_thread_helper+0x4/0x10
> [   15.043302]  [<ffffffff81983334>] ? retint_restore_args+0x13/0x13
> [   15.050590]  [<ffffffff8210fb4b>] ? start_kernel+0x390/0x390
> [   15.057392]  [<ffffffff8198bf00>] ? gs_change+0x13/0x13
> [   15.063710] ---[ end trace 4eaa2a86a8e2da26 ]---
> [   15.069687] ------------[ cut here ]------------
> [   15.075323] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
> [   15.085920] Hardware name: SandyBridge Platform
> [   15.091457] VFS: do_fd_request called on non-open device
> [   15.097868] Modules linked in:
> [   15.101842] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #881
> [   15.112248] Call Trace:
> [   15.115454]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
> [   15.122649]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
> [   15.129550]  [<ffffffff813ea19a>] ? blk_throtl_drain+0xf6/0x105
> [   15.136641]  [<ffffffff819830be>] ? _raw_spin_unlock_irq+0x30/0x3c
> [   15.144026]  [<ffffffff81519bcd>] do_fd_request+0x37/0xaa
> [   15.150538]  [<ffffffff813d78a6>] __blk_run_queue+0x1e/0x20
> [   15.157243]  [<ffffffff813dcdae>] blk_drain_queue+0x41/0x7a
> [   15.163950]  [<ffffffff813dcf0c>] blk_cleanup_queue+0x125/0x184
> [   15.171046]  [<ffffffff8213eb69>] floppy_init+0xd9c/0xdc2
> [   15.177553]  [<ffffffff8213ddcd>] ? daring+0x65/0x65
> [   15.183579]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
> [   15.190380]  [<ffffffff8210fc16>] kernel_init+0xcb/0x14f
> [   15.196791]  [<ffffffff8198bf04>] kernel_thread_helper+0x4/0x10
> [   15.203884]  [<ffffffff81983334>] ? retint_restore_args+0x13/0x13
> [   15.211173]  [<ffffffff8210fb4b>] ? start_kernel+0x390/0x390
> [   15.217973]  [<ffffffff8198bf00>] ? gs_change+0x13/0x13
> [   15.224287] ---[ end trace 4eaa2a86a8e2da27 ]---
> [   15.230251] ------------[ cut here ]------------
> [   15.235888] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
> [   15.246479] Hardware name: SandyBridge Platform
> [   15.252011] VFS: do_fd_request called on non-open device
> [   15.258423] Modules linked in:
> [   15.262391] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #881
> [   15.272792] Call Trace:
> [   15.276000]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
> [   15.283191]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
> [   15.290089]  [<ffffffff813ea19a>] ? blk_throtl_drain+0xf6/0x105
> [   15.297184]  [<ffffffff819830be>] ? _raw_spin_unlock_irq+0x30/0x3c
> [   15.304567]  [<ffffffff81519bcd>] do_fd_request+0x37/0xaa
> [   15.311074]  [<ffffffff813d78a6>] __blk_run_queue+0x1e/0x20
> [   15.317778]  [<ffffffff813dcdae>] blk_drain_queue+0x41/0x7a
> [   15.324486]  [<ffffffff813dcf0c>] blk_cleanup_queue+0x125/0x184
> [   15.331577]  [<ffffffff8213eb69>] floppy_init+0xd9c/0xdc2
> [   15.338087]  [<ffffffff8213ddcd>] ? daring+0x65/0x65
> [   15.344114]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
> [   15.350913]  [<ffffffff8210fc16>] kernel_init+0xcb/0x14f
> [   15.357327]  [<ffffffff8198bf04>] kernel_thread_helper+0x4/0x10
> [   15.364422]  [<ffffffff81983334>] ? retint_restore_args+0x13/0x13
> [   15.371710]  [<ffffffff8210fb4b>] ? start_kernel+0x390/0x390
> [   15.378511]  [<ffffffff8198bf00>] ? gs_change+0x13/0x13
> [   15.384827] ---[ end trace 4eaa2a86a8e2da28 ]---
> [   15.390794] ------------[ cut here ]------------
> [   15.396430] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
> [   15.407020] Hardware name: SandyBridge Platform
> [   15.412555] VFS: do_fd_request called on non-open device
> [   15.418964] Modules linked in:
> [   15.422943] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #881
> [   15.433343] Call Trace:
> [   15.436555]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
> [   15.443747]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
> [   15.450644]  [<ffffffff813ea19a>] ? blk_throtl_drain+0xf6/0x105
> [   15.457737]  [<ffffffff819830be>] ? _raw_spin_unlock_irq+0x30/0x3c
> [   15.465126]  [<ffffffff81519bcd>] do_fd_request+0x37/0xaa
> [   15.471633]  [<ffffffff813d78a6>] __blk_run_queue+0x1e/0x20
> [   15.478336]  [<ffffffff813dcdae>] blk_drain_queue+0x41/0x7a
> [   15.485043]  [<ffffffff813dcf0c>] blk_cleanup_queue+0x125/0x184
> [   15.492138]  [<ffffffff8213eb69>] floppy_init+0xd9c/0xdc2
> [   15.498646]  [<ffffffff8213ddcd>] ? daring+0x65/0x65
> [   15.504673]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
> [   15.511475]  [<ffffffff8210fc16>] kernel_init+0xcb/0x14f
> [   15.517886]  [<ffffffff8198bf04>] kernel_thread_helper+0x4/0x10
> [   15.524979]  [<ffffffff81983334>] ? retint_restore_args+0x13/0x13
> [   15.532266]  [<ffffffff8210fb4b>] ? start_kernel+0x390/0x390
> [   15.539066]  [<ffffffff8198bf00>] ? gs_change+0x13/0x13
> [   15.545377] ---[ end trace 4eaa2a86a8e2da29 ]---
> [   15.551339] ------------[ cut here ]------------
> [   15.556976] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
> [   15.567568] Hardware name: SandyBridge Platform
> [   15.573104] VFS: do_fd_request called on non-open device
> [   15.579508] Modules linked in:
> [   15.583480] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #881
> [   15.593883] Call Trace:
> [   15.597089]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
> [   15.604282]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
> [   15.611183]  [<ffffffff813ea19a>] ? blk_throtl_drain+0xf6/0x105
> [   15.618273]  [<ffffffff819830be>] ? _raw_spin_unlock_irq+0x30/0x3c
> [   15.625658]  [<ffffffff81519bcd>] do_fd_request+0x37/0xaa
> [   15.632168]  [<ffffffff813d78a6>] __blk_run_queue+0x1e/0x20
> [   15.638871]  [<ffffffff813dcdae>] blk_drain_queue+0x41/0x7a
> [   15.645575]  [<ffffffff813dcf0c>] blk_cleanup_queue+0x125/0x184
> [   15.652669]  [<ffffffff8213eb69>] floppy_init+0xd9c/0xdc2
> [   15.659178]  [<ffffffff8213ddcd>] ? daring+0x65/0x65
> [   15.665203]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
> [   15.672006]  [<ffffffff8210fc16>] kernel_init+0xcb/0x14f
> [   15.678419]  [<ffffffff8198bf04>] kernel_thread_helper+0x4/0x10
> [   15.685509]  [<ffffffff81983334>] ? retint_restore_args+0x13/0x13
> [   15.692799]  [<ffffffff8210fb4b>] ? start_kernel+0x390/0x390
> [   15.699600]  [<ffffffff8198bf00>] ? gs_change+0x13/0x13
> [   15.705911] ---[ end trace 4eaa2a86a8e2da2a ]---
> [   15.711878] ------------[ cut here ]------------
> [   15.717514] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
> [   15.728109] Hardware name: SandyBridge Platform
> [   15.733644] VFS: do_fd_request called on non-open device
> [   15.740055] Modules linked in:
> [   15.744035] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #881
> [   15.754433] Call Trace:
> [   15.757640]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
> [   15.764834]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
> [   15.771730]  [<ffffffff813ea19a>] ? blk_throtl_drain+0xf6/0x105
> [   15.778826]  [<ffffffff819830be>] ? _raw_spin_unlock_irq+0x30/0x3c
> [   15.786214]  [<ffffffff81519bcd>] do_fd_request+0x37/0xaa
> [   15.802386]  [<ffffffff813d78a6>] __blk_run_queue+0x1e/0x20
> [   15.809093]  [<ffffffff813dcdae>] blk_drain_queue+0x41/0x7a
> [   15.815795]  [<ffffffff813dcf0c>] blk_cleanup_queue+0x125/0x184
> [   15.822887]  [<ffffffff8213eb69>] floppy_init+0xd9c/0xdc2
> [   15.829398]  [<ffffffff8213ddcd>] ? daring+0x65/0x65
> [   15.835414]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
> [   15.842214]  [<ffffffff8210fc16>] kernel_init+0xcb/0x14f
> [   15.848620]  [<ffffffff8198bf04>] kernel_thread_helper+0x4/0x10
> [   15.855715]  [<ffffffff81983334>] ? retint_restore_args+0x13/0x13
> [   15.863001]  [<ffffffff8210fb4b>] ? start_kernel+0x390/0x390
> [   15.869802]  [<ffffffff8198bf00>] ? gs_change+0x13/0x13
> [   15.876108] ---[ end trace 4eaa2a86a8e2da2b ]---
> [   15.882068] ------------[ cut here ]------------
> [   15.887707] WARNING: at /c/wfg/linux-next/drivers/block/floppy.c:2929 do_fd_request+0x37/0xaa()
> [   15.898305] Hardware name: SandyBridge Platform
> [   15.903838] VFS: do_fd_request called on non-open device
> [   15.910252] Modules linked in:
> [   15.914227] Pid: 1, comm: swapper Tainted: G        W   3.1.0-ioless-full-next-20111025+ #881
> [   15.924625] Call Trace:
> [   15.927833]  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
> [   15.935022]  [<ffffffff810745ef>] warn_slowpath_fmt+0x46/0x48
> [   15.941922]  [<ffffffff813ea19a>] ? blk_throtl_drain+0xf6/0x105
> [   15.949015]  [<ffffffff819830be>] ? _raw_spin_unlock_irq+0x30/0x3c
> [   15.956399]  [<ffffffff81519bcd>] do_fd_request+0x37/0xaa
> [   15.962905]  [<ffffffff813d78a6>] __blk_run_queue+0x1e/0x20
> [   15.969609]  [<ffffffff813dcdae>] blk_drain_queue+0x41/0x7a
> [   15.976316]  [<ffffffff813dcf0c>] blk_cleanup_queue+0x125/0x184
> [   15.983409]  [<ffffffff8213eb69>] floppy_init+0xd9c/0xdc2
> [   15.989917]  [<ffffffff8213ddcd>] ? daring+0x65/0x65
> [   15.995936]  [<ffffffff810002f7>] do_one_initcall+0x7f/0x140
> [   16.002738]  [<ffffffff8210fc16>] kernel_init+0xcb/0x14f
> [   16.009148]  [<ffffffff8198bf04>] kernel_thread_helper+0x4/0x10
> [   16.016241]  [<ffffffff81983334>] ? retint_restore_args+0x13/0x13
> [   16.023530]  [<ffffffff8210fb4b>] ? start_kernel+0x390/0x390
> [   16.030329]  [<ffffffff8198bf00>] ? gs_change+0x13/0x13
> [   16.036645] ---[ end trace 4eaa2a86a8e2da2c ]---
> [   16.052353] brd: module loaded
> [   16.061308] loop: module loaded
> [   16.066656] Loading iSCSI transport class v2.0-870.
> [   16.074429] Loading Adaptec I2O RAID: Version 2.4 Build 5go
> [   16.081152] Detecting Adaptec I2O RAID controllers...
> [   16.088191] Adaptec aacraid driver 1.1-7[28000]-ms
> [   16.098300] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
> [   16.107101] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.03.07.07-k.
> [   16.117675] iscsi: registered transport (qla4xxx)
> [   16.123757] QLogic iSCSI HBA Driver
> [   16.128519] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
> [   16.137779] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
> [   16.146389] megasas: 00.00.06.12-rc1 Wed. Oct. 5 17:00:00 PDT 2011
> [   16.154141] mpt2sas version 09.100.00.01 loaded
> [   16.161415] ahci 0000:00:1f.2: version 3.0
> [   16.166508] IOAPIC[0]: Set routing entry (0-21 -> 0x6a -> IRQ 21 Mode:1 Active:1 Dest:0)
> [   16.202405] ahci 0000:00:1f.2: PCI INT B -> GSI 21 (level, low) -> IRQ 21
> [   16.210614] ahci 0000:00:1f.2: irq 104 for MSI/MSI-X
> [   16.229491] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x3 impl SATA mode
> [   16.239385] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems apst 
> [   16.249176] ahci 0000:00:1f.2: setting latency timer to 64
> [   16.286010] scsi0 : ahci
> [   16.289722] scsi1 : ahci
> [   16.293354] scsi2 : ahci
> [   16.307557] scsi3 : ahci
> [   16.311192] scsi4 : ahci
> [   16.314807] scsi5 : ahci
> [   16.328514] ata1: SATA max UDMA/133 abar m2048@0xd3110000 port 0xd3110100 irq 104
> [   16.337735] ata2: SATA max UDMA/133 abar m2048@0xd3110000 port 0xd3110180 irq 104
> [   16.346944] ata3: DUMMY
> [   16.350131] ata4: DUMMY
> [   16.353327] ata5: DUMMY
> [   16.356517] ata6: DUMMY
> [   16.359740] work_for_cpu used greatest stack depth: 4984 bytes left
> [   16.367860] tun: Universal TUN/TAP device driver, 1.6
> [   16.373995] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
> [   16.382079] Atheros(R) L2 Ethernet Driver - version 2.2.3
> [   16.388601] Copyright (c) 2007 Atheros Corporation.
> [   16.395859] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.7 (July 20, 2011)
> [   16.405425] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
> [   16.412720] e100: Copyright(c) 1999-2006 Intel Corporation
> [   16.419681] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
> [   16.428048] e1000: Copyright (c) 1999-2006 Intel Corporation.
> [   16.435321] e1000e: Intel(R) PRO/1000 Network Driver - 1.5.1-k
> [   16.442324] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
> [   16.449810] Intel(R) Gigabit Ethernet Network Driver - version 3.2.10-k
> [   16.457688] Copyright (c) 2007-2011 Intel Corporation.
> [   16.464278] igb 0000:09:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [   16.472842] igb 0000:09:00.0: irq 105 for MSI/MSI-X
> [   16.504263] igb 0000:09:00.0: irq 106 for MSI/MSI-X
> [   16.510200] igb 0000:09:00.0: irq 107 for MSI/MSI-X
> [   16.516138] igb 0000:09:00.0: irq 108 for MSI/MSI-X
> [   16.534243] igb 0000:09:00.0: irq 109 for MSI/MSI-X
> [   16.540171] igb 0000:09:00.0: irq 110 for MSI/MSI-X
> [   16.546094] igb 0000:09:00.0: irq 111 for MSI/MSI-X
> [   16.564229] igb 0000:09:00.0: irq 112 for MSI/MSI-X
> [   16.570151] igb 0000:09:00.0: irq 113 for MSI/MSI-X
> [   16.639197] igb 0000:09:00.0: DCA enabled
> [   16.644242] igb 0000:09:00.0: Intel(R) Gigabit Ethernet Network Connection
> [   16.652386] igb 0000:09:00.0: eth0: (PCIe:5.0Gb/s:Width x4) 00:1e:67:0d:ba:3a
> [   16.660898] igb 0000:09:00.0: eth0: PBA No: 0050FF-0FF
> [   16.664217] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [   16.664260] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [   16.681831] igb 0000:09:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
> [   16.681938] ata2.00: ATAPI: ATAPI   iHAS124   B, AL0L, max UDMA/100
> [   16.698797] ata1.00: ATA-8: WDC WD1002FAEX-00Z3A0, 05.01D05, max UDMA/133
> [   16.706877] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
> [   16.707176] IOAPIC[0]: Set routing entry (0-17 -> 0xc2 -> IRQ 17 Mode:1 Active:1 Dest:0)
> [   16.707185] igb 0000:09:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> [   16.707874] igb 0000:09:00.1: irq 114 for MSI/MSI-X
> [   16.707888] igb 0000:09:00.1: irq 115 for MSI/MSI-X
> [   16.707902] igb 0000:09:00.1: irq 116 for MSI/MSI-X
> [   16.707915] igb 0000:09:00.1: irq 117 for MSI/MSI-X
> [   16.707929] igb 0000:09:00.1: irq 118 for MSI/MSI-X
> [   16.707942] igb 0000:09:00.1: irq 119 for MSI/MSI-X
> [   16.707961] igb 0000:09:00.1: irq 120 for MSI/MSI-X
> [   16.707974] igb 0000:09:00.1: irq 121 for MSI/MSI-X
> [   16.707987] igb 0000:09:00.1: irq 122 for MSI/MSI-X
> [   16.761252] igb 0000:09:00.1: DCA enabled
> [   16.761408] igb 0000:09:00.1: Intel(R) Gigabit Ethernet Network Connection
> [   16.761410] igb 0000:09:00.1: eth1: (PCIe:5.0Gb/s:Width x4) 00:1e:67:0d:ba:3b
> [   16.761489] igb 0000:09:00.1: eth1: PBA No: 0050FF-0FF
> [   16.761491] igb 0000:09:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
> [   16.770125] igb 0000:09:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [   16.770779] igb 0000:09:00.2: irq 123 for MSI/MSI-X
> [   16.770793] igb 0000:09:00.2: irq 124 for MSI/MSI-X
> [   16.770807] igb 0000:09:00.2: irq 125 for MSI/MSI-X
> [   16.770820] igb 0000:09:00.2: irq 126 for MSI/MSI-X
> [   16.770838] igb 0000:09:00.2: irq 127 for MSI/MSI-X
> [   16.770852] igb 0000:09:00.2: irq 128 for MSI/MSI-X
> [   16.770866] igb 0000:09:00.2: irq 129 for MSI/MSI-X
> [   16.770879] igb 0000:09:00.2: irq 130 for MSI/MSI-X
> [   16.770897] igb 0000:09:00.2: irq 131 for MSI/MSI-X
> [   16.824529] igb 0000:09:00.2: DCA enabled
> [   16.824712] igb 0000:09:00.2: Intel(R) Gigabit Ethernet Network Connection
> [   16.824714] igb 0000:09:00.2: eth2: (PCIe:5.0Gb/s:Width x4) 00:1e:67:0d:ba:3c
> [   16.824794] igb 0000:09:00.2: eth2: PBA No: 0050FF-0FF
> [   16.824796] igb 0000:09:00.2: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
> [   16.837091] igb 0000:09:00.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
> [   16.837737] igb 0000:09:00.3: irq 132 for MSI/MSI-X
> [   16.837756] igb 0000:09:00.3: irq 133 for MSI/MSI-X
> [   16.837771] igb 0000:09:00.3: irq 134 for MSI/MSI-X
> [   16.837784] igb 0000:09:00.3: irq 135 for MSI/MSI-X
> [   16.837798] igb 0000:09:00.3: irq 136 for MSI/MSI-X
> [   16.837811] igb 0000:09:00.3: irq 137 for MSI/MSI-X
> [   16.837825] igb 0000:09:00.3: irq 138 for MSI/MSI-X
> [   16.837838] igb 0000:09:00.3: irq 139 for MSI/MSI-X
> [   16.837852] igb 0000:09:00.3: irq 140 for MSI/MSI-X
> [   16.891524] igb 0000:09:00.3: DCA enabled
> [   16.891680] igb 0000:09:00.3: Intel(R) Gigabit Ethernet Network Connection
> [   16.891683] igb 0000:09:00.3: eth3: (PCIe:5.0Gb/s:Width x4) 00:1e:67:0d:ba:3d
> [   16.891761] igb 0000:09:00.3: eth3: PBA No: 0050FF-0FF
> [   16.891763] igb 0000:09:00.3: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
> [   16.891952] Intel(R) Gigabit Virtual Function Network Driver - version 2.0.1-k
> [   16.891954] Copyright (c) 2009 - 2011 Intel Corporation.
> [   16.892163] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.6.7-k
> [   16.892165] ixgbe: Copyright (c) 1999-2011 Intel Corporation.
> [   16.892363] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
> [   16.892365] ixgb: Copyright (c) 1999-2008 Intel Corporation.
> [   16.892749] jme: JMicron JMC2XX ethernet driver version 1.0.8
> [   16.893142] sky2: driver version 1.29
> [   16.894105] pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
> [   16.894107] rtl8150: v0.6.2 (2004/08/27):rtl8150 based usb-ethernet driver
> [   16.894114] cdc_ncm: 04-Aug-2011
> [   16.894115] Fusion MPT base driver 3.04.20
> [   16.894116] Copyright (c) 1999-2008 LSI Corporation
> [   16.894129] Fusion MPT SPI Host driver 3.04.20
> [   16.894339] Fusion MPT FC Host driver 3.04.20
> [   16.894532] Fusion MPT SAS Host driver 3.04.20
> [   16.894730] Fusion MPT misc device (ioctl) driver 3.04.20
> [   16.894900] mptctl: Registered with Fusion MPT base driver
> [   16.894902] mptctl: /dev/mptctl @ (major,minor=10,220)
> [   16.895088] Initializing USB Mass Storage driver...
> [   16.895200] usb-serial: usb_serial_init - usb_register failed
> [   16.895327] usb-serial: usb_serial_init - returning with error -19
> [   16.895711] i8042: PNP: No PS/2 controller found. Probing ports directly.
> [   17.185333] ata2.00: configured for UDMA/100
> [   17.192825] ata1.00: configured for UDMA/133
> [   17.198427] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1002FAEX-0 05.0 PQ: 0 ANSI: 5
> [   17.209141] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
> [   17.210939] scsi 1:0:0:0: CD-ROM            ATAPI    iHAS124   B      AL0L PQ: 0 ANSI: 5
> [   17.228715] sd 0:0:0:0: [sda] Write Protect is off
> [   17.234557] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [   17.240770] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [   17.292277]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
> [   17.411499] i8042: Can't read CTR while initializing i8042
> [   17.412772] sd 0:0:0:0: [sda] Attached SCSI disk
> [   17.423782] i8042: probe of i8042 failed with error -5
> [   17.430837] mousedev: PS/2 mouse device common for all mice
> [   17.438692] rtc_cmos 00:06: RTC can wake from S4
> [   17.444734] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
> [   17.452087] rtc0: alarms up to one year, y3k, 242 bytes nvram
> [   17.459123] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
> [   17.466305] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled by hardware/BIOS
> [   17.476512] iTCO_vendor_support: vendor-support=0
> [   17.482469] Software Watchdog Timer: 0.07 initialized. soft_noboot=0 soft_margin=60 sec soft_panic=0 (nowayout= 0)
> [   17.494945] md: linear personality registered for level -1
> [   17.501566] md: raid0 personality registered for level 0
> [   17.507990] md: raid1 personality registered for level 1
> [   17.514410] md: raid10 personality registered for level 10
> [   17.521025] md: raid6 personality registered for level 6
> [   17.527448] md: raid5 personality registered for level 5
> [   17.533865] md: raid4 personality registered for level 4
> [   17.540291] md: multipath personality registered for level -4
> [   17.547198] md: faulty personality registered for level -5
> [   17.554816] device-mapper: uevent: version 1.0.3
> [   17.561043] device-mapper: ioctl: 4.21.0-ioctl (2011-07-06) initialised: dm-devel@redhat.com
> [   17.571661] device-mapper: multipath: version 1.3.0 loaded
> [   17.578300] device-mapper: multipath round-robin: version 1.0.0 loaded
> [   17.586088] device-mapper: multipath queue-length: version 0.1.0 loaded
> [   17.593962] device-mapper: multipath service-time: version 0.2.0 loaded
> [   17.602266] device-mapper: dm-log-userspace: version 1.1.0 loaded
> [   17.615003] cpuidle: using governor ladder
> [   17.630146] cpuidle: using governor menu
> [   17.636147] dell_wmi: No known WMI GUID found
> [   17.641513] acer_wmi: Acer Laptop ACPI-WMI Extras
> [   17.647255] acer_wmi: No or unsupported WMI interface, unable to load
> [   17.656765] IOAPIC[0]: Set routing entry (0-22 -> 0x64 -> IRQ 22 Mode:1 Active:1 Dest:0)
> [   17.666683] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
> [   17.701816] snd_hda_intel 0000:00:1b.0: irq 141 for MSI/MSI-X
> [   17.708772] ALSA hda_intel.c:2733 chipset global capabilities = 0x4401
> [   17.728682] ALSA hda_intel.c:1163 Clearing TCSEL
> [   17.734313] ALSA hda_intel.c:1206 SCH snoop: Enabled
> [   17.756632] ALSA hda_intel.c:1009 codec_mask = 0x0
> [   17.762462] ALSA hda_intel.c:2834 no codecs found!
> [   17.768397] snd_hda_intel 0000:00:1b.0: PCI INT A disabled
> [   17.788001] ALSA device list:
> [   17.791806]   No soundcards found.
> [   17.796093] oprofile: using NMI interrupt.
> [   17.801358] netem: version 1.3
> [   17.805258] Netfilter messages via NETLINK v0.30.
> [   17.811082] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
> [   17.820455] ctnetlink v0.93: registering with nfnetlink.
> [   17.826972] NF_TPROXY: Transparent proxy support initialized, version 4.1.0
> [   17.835244] NF_TPROXY: Copyright (c) 2006-2007 BalaBit IT Ltd.
> [   17.843176] xt_time: kernel timezone is -0000
> [   17.852571] ip_tables: (C) 2000-2006 Netfilter Core Team
> [   17.861031] ipt_CLUSTERIP: ClusterIP Version 0.8 loaded successfully
> [   17.868670] arp_tables: (C) 2002 David S. Miller
> [   17.874713] TCP bic registered
> [   17.878611] TCP cubic registered
> [   17.882702] TCP westwood registered
> [   17.887081] TCP highspeed registered
> [   17.891567] TCP hybla registered
> [   17.895657] TCP htcp registered
> [   17.899646] TCP vegas registered
> [   17.903733] TCP veno registered
> [   17.907724] TCP scalable registered
> [   17.912100] TCP lp registered
> [   17.915903] TCP yeah registered
> [   17.919893] TCP illinois registered
> [   17.924271] Initializing XFRM netlink socket
> [   17.930786] NET: Registered protocol family 10
> [   17.950609] IPv6 over IPv4 tunneling driver
> [   17.960481] NET: Registered protocol family 17
> [   17.965950] NET: Registered protocol family 15
> [   17.971761] Bridge firewalling registered
> [   17.976758] Ebtables v2.0 registered
> [   17.981499] Registering the dns_resolver key type
> [   17.987413] 
> [   17.987415] printing PIC contents
> [   17.993738] ... PIC  IMR: ffff
> [   17.997627] ... PIC  IRR: 0c21
> [   18.001530] ... PIC  ISR: 0000
> [   18.005423] ... PIC ELCR: 0c20
> [   18.009324] printing local APIC contents on CPU#0/0:
> [   18.015325] ... APIC ID:      00000000 (0)
> [   18.020350] ... APIC VERSION: 01060015
> [   18.024976] ... APIC TASKPRI: 00000000 (00)
> [   18.030099] ... APIC PROCPRI: 00000000
> [   18.034734] ... APIC LDR: 01000000
> [   18.038979] ... APIC DFR: ffffffff
> [   18.043224] ... APIC SPIV: 000001ff
> [   18.047558] ... APIC ISR field:
> [   18.051504] 0000000000000000000000000000000000000000000000000000000000000000
> [   18.060475] ... APIC TMR field:
> [   18.064429] 0000000000000000000000000000000000000000000000000000000000000000
> [   18.073390] ... APIC IRR field:
> [   18.077345] 0000000000000000000000000000000000000000000000000000000000008000
> [   18.086320] ... APIC ESR: 00000000
> [   18.090565] ... APIC ICR: 000000fd
> [   18.094809] ... APIC ICR2: 2f000000
> [   18.099151] ... APIC LVTT: 000000ef
> [   18.103483] ... APIC LVTPC: 00000400
> [   18.107921] ... APIC LVT0: 00010700
> [   18.112262] ... APIC LVT1: 00000400
> [   18.116604] ... APIC LVTERR: 000000fe
> [   18.121141] ... APIC TMICT: 00001846
> [   18.125580] ... APIC TMCCT: 00000000
> [   18.130009] ... APIC TDCR: 00000003
> [   18.134350] 
> [   18.136460] number of MP IRQ sources: 15.
> [   18.141429] number of IO-APIC #0 registers: 24.
> [   18.146975] number of IO-APIC #1 registers: 24.
> [   18.152519] number of IO-APIC #2 registers: 24.
> [   18.158063] testing the IO APIC.......................
> [   18.164297] 
> [   18.166441] IO APIC #0......
> [   18.170136] .... register #00: 00000000
> [   18.174904] .......    : physical APIC id: 00
> [   18.180254] .......    : Delivery Type: 0
> [   18.185216] .......    : LTS          : 0
> [   18.190177] .... register #01: 00170020
> [   18.194947] .......     : max redirection entries: 17
> [   18.201076] .......     : PRQ implemented: 0
> [   18.206324] .......     : IO APIC version: 20
> [   18.211676] .... IRQ redirection table:
> [   18.216444]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
> [   18.223061]  00 A5  1    0    0   0   0    0    2    34
> [   18.229497]  01 00  0    0    0   0   0    0    0    31
> [   18.235924]  02 00  0    0    0   0   0    0    0    30
> [   18.242345]  03 00  0    0    0   0   0    0    0    33
> [   18.248769]  04 00  0    0    0   0   0    0    0    34
> [   18.255191]  05 00  0    0    0   0   0    0    0    35
> [   18.261616]  06 00  1    0    0   0   0    0    0    36
> [   18.268041]  07 00  0    0    0   0   0    0    0    37
> [   18.274476]  08 00  0    0    0   0   0    0    0    38
> [   18.280892]  09 00  0    1    0   0   0    0    0    39
> [   18.287317]  0a 00  0    0    0   0   0    0    0    3A
> [   18.293742]  0b 00  0    0    0   0   0    0    0    3B
> [   18.300168]  0c 00  0    0    0   0   0    0    0    3C
> [   18.306589]  0d 00  0    0    0   0   0    0    0    3D
> [   18.313014]  0e 00  0    0    0   0   0    0    0    3E
> [   18.319437]  0f 00  0    0    0   0   0    0    0    3F
> [   18.325864]  10 00  1    1    0   1   0    0    0    49
> [   18.332290]  11 00  1    1    0   1   0    0    0    C2
> [   18.338715]  12 00  1    1    0   1   0    0    0    51
> [   18.345132]  13 00  1    1    0   1   0    0    0    59
> [   18.351559]  14 00  1    0    0   0   0    0    0    00
> [   18.357984]  15 00  1    1    0   1   0    0    0    6A
> [   18.364406]  16 00  1    1    0   1   0    0    0    64
> [   18.370830]  17 00  1    0    0   0   0    0    0    00
> [   18.377257] 
> [   18.379397] IO APIC #1......
> [   18.383093] .... register #00: 01000000
> [   18.387861] .......    : physical APIC id: 01
> [   18.402867] .......    : Delivery Type: 0
> [   18.407827] .......    : LTS          : 0
> [   18.412786] .... register #01: 00170020
> [   18.417554] .......     : max redirection entries: 17
> [   18.423684] .......     : PRQ implemented: 0
> [   18.428939] .......     : IO APIC version: 20
> [   18.434287] .... register #02: 00000000
> [   18.439055] .......     : arbitration: 00
> [   18.444017] .... register #03: 00000001
> [   18.448773] .......     : Boot DT    : 1
> [   18.453640] .... IRQ redirection table:
> [   18.458408]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
> [   18.465022]  00 00  1    0    0   0   0    0    0    00
> [   18.471448]  01 00  1    0    0   0   0    0    0    00
> [   18.477874]  02 00  1    1    0   1   0    0    0    41
> [   18.484298]  03 00  1    0    0   0   0    0    0    00
> [   18.490719]  04 00  1    0    0   0   0    0    0    00
> [   18.497134]  05 00  1    0    0   0   0    0    0    00
> [   18.503560]  06 00  1    0    0   0   0    0    0    00
> [   18.509983]  07 00  1    1    0   1   0    0    0    69
> [   18.516407]  08 00  1    0    0   0   0    0    0    00
> [   18.522830]  09 00  1    0    0   0   0    0    0    00
> [   18.529258]  0a 00  1    0    0   0   0    0    0    00
> [   18.535680]  0b 00  1    0    0   0   0    0    0    00
> [   18.542105]  0c 00  1    0    0   0   0    0    0    00
> [   18.548529]  0d 00  1    0    0   0   0    0    0    00
> [   18.554948]  0e 00  1    0    0   0   0    0    0    00
> [   18.561371]  0f 00  1    1    0   1   0    0    0    79
> [   18.567794]  10 00  1    0    0   0   0    0    0    00
> [   18.574218]  11 00  1    0    0   0   0    0    0    00
> [   18.580638]  12 00  1    0    0   0   0    0    0    00
> [   18.587060]  13 00  1    0    0   0   0    0    0    00
> [   18.593485]  14 00  1    0    0   0   0    0    0    00
> [   18.599905]  15 00  1    0    0   0   0    0    0    00
> [   18.606329]  16 00  1    0    0   0   0    0    0    00
> [   18.612753]  17 00  1    1    0   1   0    0    0    29
> [   18.619173] 
> [   18.621316] IO APIC #2......
> [   18.625012] .... register #00: 02000000
> [   18.629779] .......    : physical APIC id: 02
> [   18.635127] .......    : Delivery Type: 0
> [   18.640089] .......    : LTS          : 0
> [   18.645053] .... register #01: 00170020
> [   18.649818] .......     : max redirection entries: 17
> [   18.655946] .......     : PRQ implemented: 0
> [   18.661203] .......     : IO APIC version: 20
> [   18.666551] .... register #02: 00000000
> [   18.671318] .......     : arbitration: 00
> [   18.676281] .... register #03: 00000001
> [   18.681050] .......     : Boot DT    : 1
> [   18.685911] .... IRQ redirection table:
> [   18.690679]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
> [   18.697295]  00 00  1    0    0   0   0    0    0    00
> [   18.703717]  01 00  1    0    0   0   0    0    0    00
> [   18.710138]  02 00  1    0    0   0   0    0    0    00
> [   18.716564]  03 00  1    0    0   0   0    0    0    00
> [   18.722984]  04 00  1    0    0   0   0    0    0    00
> [   18.729410]  05 00  1    0    0   0   0    0    0    00
> [   18.735835]  06 00  1    0    0   0   0    0    0    00
> [   18.742258]  07 00  1    1    0   1   0    0    0    B9
> [   18.748683]  08 00  1    0    0   0   0    0    0    00
> [   18.755110]  09 00  1    0    0   0   0    0    0    00
> [   18.761533]  0a 00  1    0    0   0   0    0    0    00
> [   18.767955]  0b 00  1    0    0   0   0    0    0    00
> [   18.774381]  0c 00  1    0    0   0   0    0    0    00
> [   18.780801]  0d 00  1    0    0   0   0    0    0    00
> [   18.787225]  0e 00  1    0    0   0   0    0    0    00
> [   18.793651]  0f 00  1    1    0   1   0    0    0    C9
> [   18.800072]  10 00  1    0    0   0   0    0    0    00
> [   18.806504]  11 00  1    0    0   0   0    0    0    00
> [   18.812929]  12 00  1    0    0   0   0    0    0    00
> [   18.819351]  13 00  1    0    0   0   0    0    0    00
> [   18.825773]  14 00  1    0    0   0   0    0    0    00
> [   18.832198]  15 00  1    0    0   0   0    0    0    00
> [   18.838617]  16 00  1    0    0   0   0    0    0    00
> [   18.845041]  17 00  1    1    0   1   0    0    0    61
> [   18.851461] IRQ to pin mappings:
> [   18.855551] IRQ0 -> 0:2
> [   18.858952] IRQ1 -> 0:1
> [   18.862355] IRQ3 -> 0:3
> [   18.865748] IRQ4 -> 0:4
> [   18.869152] IRQ5 -> 0:5
> [   18.872551] IRQ6 -> 0:6
> [   18.875947] IRQ7 -> 0:7
> [   18.879350] IRQ8 -> 0:8
> [   18.882750] IRQ9 -> 0:9
> [   18.886155] IRQ10 -> 0:10
> [   18.889746] IRQ11 -> 0:11
> [   18.893349] IRQ12 -> 0:12
> [   18.896945] IRQ13 -> 0:13
> [   18.900537] IRQ14 -> 0:14
> [   18.904137] IRQ15 -> 0:15
> [   18.907726] IRQ16 -> 0:16
> [   18.911327] IRQ17 -> 0:17
> [   18.914921] IRQ18 -> 0:18
> [   18.918520] IRQ19 -> 0:19
> [   18.922120] IRQ21 -> 0:21
> [   18.925712] IRQ22 -> 0:22
> [   18.929313] IRQ26 -> 1:2
> [   18.932807] IRQ31 -> 1:7
> [   18.936311] IRQ39 -> 1:15
> [   18.939903] IRQ47 -> 1:23
> [   18.943499] IRQ55 -> 2:7
> [   18.946995] IRQ63 -> 2:15
> [   18.950590] IRQ71 -> 2:23
> [   18.954194] .................................... done.
> [   18.961004] PM: Hibernation image not present or could not be loaded.
> [   18.968750] registered taskstats version 1
> [   18.977767]   Magic number: 15:156:950
> [   18.982484] tty ttya5: hash matches
> [   18.986924] cpuid cpu5: hash matches
> [   18.991418] tty tty7: hash matches
> [   18.995846] netconsole: local port 6665
> [   19.000623] netconsole: local IP 10.0.0.0
> [   19.005587] netconsole: interface 'eth0'
> [   19.010451] netconsole: remote port 6666
> [   19.015318] netconsole: remote IP 192.168.1.1
> [   19.020670] netconsole: remote ethernet address 00:30:48:fe:19:95
> [   19.027966] netconsole: device eth0 not up yet, forcing it
> [   19.124399] ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   20.335815] igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
> [   20.346269] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [   20.375024] console [netcon0] enabled
> [   20.379608] netconsole: network logging started
> [   20.385242] rtc_cmos 00:06: setting system clock to 2011-10-31 18:57:05 UTC (1320087425)
> [   20.433441] IP-Config: Complete:
> [   20.437542]      device=eth0, addr=192.168.1.61, mask=255.255.255.0, gw=192.168.1.1,
> [   20.446701]      host=snb, domain=, nis-domain=(none),
> [   20.453021]      bootserver=192.168.1.11, rootserver=192.168.1.11, rootpath=
> [   20.462814] md: Waiting for all devices to be available before autodetect
> [   20.470908] md: If you don't use raid, use raid=noautodetect
> [   20.478401] md: Autodetecting RAID arrays.
> [   20.483453] md: Scanned 0 and added 0 devices.
> [   20.488886] md: autorun ...
> [   20.492474] md: ... autorun DONE.
> [   20.503368] VFS: Mounted root (nfs filesystem) on device 0:15.
> [   20.510442] debug: unmapping init memory ffffffff81f3a000..ffffffff821ee000
> [   20.619457] stty used greatest stack depth: 4192 bytes left
> [   20.639198] startpar used greatest stack depth: 3904 bytes left
> [   20.665613] uname used greatest stack depth: 3680 bytes left
> [   20.722252] S02hostname.sh used greatest stack depth: 3648 bytes left
> [   20.752254] mountpoint used greatest stack depth: 3552 bytes left
> [   22.459605] S04ssh used greatest stack depth: 3504 bytes left
> [   22.967174] EXT4-fs (sda3): warning: maximal mount count reached, running e2fsck is recommended
> [   22.982371] EXT4-fs (sda3): recovery complete
> [   22.987772] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: (null)
> [   23.525484] cat used greatest stack depth: 3328 bytes left
> [   23.598088] mount.nfs used greatest stack depth: 3168 bytes left
> [   25.083927] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
> [   25.094437] NFSD: starting 90-second grace period
> [   27.589492] mount.nfs used greatest stack depth: 2640 bytes left
> [   28.526478] XFS (sda7): Mounting Filesystem
> [   28.653258] XFS (sda7): Ending clean mount
> [   31.208071] eth0: no IPv6 routers present
> 

