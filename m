Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab0KNRgM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 12:36:12 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:4008 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756434Ab0KNRgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 12:36:09 -0500
Subject: Re: divide error in select_task_rq_fair()
From: Myron Stowe <myron.stowe@hp.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>, Nikhil Rao <ncrao@google.com>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
        linux-kernel@vger.kernel.org, rjenties@google.com
In-Reply-To: <201011121152.30204.knikanth@suse.de>
References: <20101104041236.GA9389@helgaas.com>
	 <1288937844.3234.1.camel@edumazet-laptop> <1289500084.2698.12.camel@zim>
	 <201011121152.30204.knikanth@suse.de>
Content-Type: multipart/mixed; boundary="=-sj+oWlayMRwjpdkeCdmq"
Date: Sun, 14 Nov 2010 10:36:01 -0700
Message-ID: <1289756161.2814.29.camel@zim>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-sj+oWlayMRwjpdkeCdmq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

On Fri, 2010-11-12 at 11:52 +0530, Nikanth Karthikesan wrote:
> On Thursday 11 November 2010 23:58:04 Myron Stowe wrote:
> > On Fri, 2010-11-05 at 07:17 +0100, Eric Dumazet wrote:
> > > Le jeudi 04 novembre 2010 Ã  20:00 -0600, Bjorn Helgaas a Ã©crit :
> > > > Is that going to help you debug the problem?  The solution is not going
> > > > to be something like "set NR_CPUS=x".  If NR_CPUS is too small, the
> > > > machine should still *boot*, even if we can't use all the CPUs in the
> > > > box.
> > >
> > > Yes, it will help to understand the layout of cpu / domains and make
> > > appropriate changes.
> > >
> > > Alternative is you send me such a machine :=)
> > 
> > I opened a BZ on this issue as it seems to be a regression -
> > https://bugzilla.kernel.org/show_bug.cgi?id=22662
> > 
> > I also, as indicated in the BZ, bisected the kernel which gave the
> > following results and reverting 50f2d7f682f9c0ed58191d0982fe77888d59d162
> > did re-enable booting on the box in question (an HP dl980g7).  Let me
> > know what further info you need or patches to test for debugging this.
> > 
> > Thanks,
> > 
> > commit 50f2d7f682f9c0ed58191d0982fe77888d59d162
> > Author: Nikanth Karthikesan <knikanth@suse.de>
> > Date:   Thu Sep 30 17:34:10 2010 +0530
> > 
> >     x86, numa: Assign CPUs to nodes in round-robin manner on fake NUMA
> > 
> >     commit d9c2d5ac6af87b4491bff107113aaf16f6c2b2d9 "x86, numa: Use
> >  near(er) online node instead of roundrobin for NUMA" changed NUMA
> >  initialization on Intel to choose the nearest online node or first node. 
> >  Fake NUMA would be better of with round-robin initialization, instead of
> >  the all CPUS on first node.  Change the choice of first node, back to
> >  round-robin.
> > 
> >     For testing NUMA kernel behaviour without cpusets and NUMA aware
> >     applications, it would be better to have cpus in different nodes,
> >  rather than all in a single node.  With cpusets migration of tasks
> >  scenarios cannot not be tested.
> > 
> >     I guess having it round-robin shouldn't affect the use cases for all
> >  cpus on the first node.
> > 
> >     The code comments in arch/x86/mm/numa_64.c:759 indicate that this used
> >  to be the case, which was changed by commit d9c2d5ac6.  It changed from
> >  roundrobin to nearer or first node.  And I couldn't find any reason for
> >  this change in its changelog.
> > 
> >     Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> >     Cc: David Rientjes <rientjes@google.com>
> >     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > 
> > > Thanks
> > 
> 
> Can you try with this patch?

I got the same divide error with this latest patch (see attachment).  If
I revert commit 50f2d7f682f9, the platform boots successfully.

Thanks,

Myron

> 
> Thanks
> Nikanth
> 
> Fallback to first node, if the node is not online.
> 
> Fixes regression of commit 50f2d7f682f9c0ed58191d0982fe77888d59d162
> x86, numa: Assign CPUs to nodes in round-robin manner on fake NUMA
> 
> When some of the NUMA nodes are disabled, and the CPUs are assigned
> in round-robin fashion, CPUs might be assigned to disabled nodes
> resulting in the crash. While using round-robin assignment, check if the
> node is online. If the node is not online, use the first online node.
> 
> Reported-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> 
> ---
> 
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index d16c2c5..f31237c 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -287,6 +287,8 @@ static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
>  	if (node == NUMA_NO_NODE || !node_online(node)) {
>  		/* reuse the value from init_cpu_to_node() */
>  		node = cpu_to_node(cpu);
> +		if (!node_online(node))
> +			node = first_node(node_online_map);
>  	}
>  	numa_set_node(cpu, node);
>  #endif
> 


-- 
Myron Stowe                             Linux Kernel Developer
Fort Collins, CO                        Office of Corporate Strategy and Technology

--=-sj+oWlayMRwjpdkeCdmq
Content-Disposition: attachment; filename="mfs"
Content-Type: text/plain; name="mfs"; charset="UTF-8"
Content-Transfer-Encoding: 8bit

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.37-rc1-00171-g3712c6c (stowe@bob) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #153 SMP Sat Nov 13 18:46:18 MST 2010
[    0.000000] Command line: console=ttyS0,115200n8 debug ignore_loglevel root=/dev/sdb1 BOOT_IMAGE=kernel 
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000095400 (usable)
[    0.000000]  BIOS-e820: 0000000000095400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007f600000 (usable)
[    0.000000]  BIOS-e820: 000000007f600000 - 000000007f62c000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007f62c000 - 000000007f62d000 (usable)
[    0.000000]  BIOS-e820: 000000007f62d000 - 000000007f79d000 (reserved)
[    0.000000]  BIOS-e820: 000000007f79d000 - 000000007f7a0000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007f7a0000 - 0000000090000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000480000000 (usable)
[    0.000000]  BIOS-e820: 0000002000000000 - 0000002400000000 (usable)
[    0.000000]  BIOS-e820: 0000004000000000 - 0000004400000000 (usable)
[    0.000000]  BIOS-e820: 0000006000000000 - 0000006400000000 (usable)
[    0.000000]  BIOS-e820: 0000008000000000 - 0000008200000000 (usable)
[    0.000000]  BIOS-e820: 000000a000000000 - 000000a200000000 (usable)
[    0.000000]  BIOS-e820: 000000c000000000 - 000000c200000000 (usable)
[    0.000000]  BIOS-e820: 000000e000000000 - 000000e200000000 (usable)
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: /ProLiant DL980 G7, BIOS P66 07/07/2010
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0xe200000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00080000000 mask FFF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0x7f62d max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000f4f80] f4f80
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-000000007f62d000
[    0.000000]  0000000000 - 007f600000 page 2M
[    0.000000]  007f600000 - 007f62d000 page 4k
[    0.000000] kernel direct mapping tables up to 7f62d000 @ 1fffc000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-000000e200000000
[    0.000000]  0100000000 - e200000000 page 2M
[    0.000000] kernel direct mapping tables up to e200000000 @ 7f276000-7f600000
[    0.000000] ACPI: RSDP 00000000000f4f00 00024 (v02 HP    )
[    0.000000] ACPI: XSDT 000000007f6022c0 000C4 (v01 HP     ProLiant 00000002   Ò? 0000162E)
[    0.000000] ACPI: FACP 000000007f6023c0 000F4 (v03 HP     ProLiant 00000002   Ò? 0000162E)
[    0.000000] ACPI Warning: Invalid length for Pm1aControlBlock: 32, using default 16 (20101013/tbfadt-607)
[    0.000000] ACPI: DSDT 000000007f6024c0 029E0 (v01 HP         DSDT 00000001 INTL 20030228)
[    0.000000] ACPI: FACS 000000007f600140 00040
[    0.000000] ACPI: SPCR 000000007f600180 00050 (v01 HP     SPCRRBSU 00000001   Ò? 0000162E)
[    0.000000] ACPI: MCFG 000000007f600200 0003C (v01 HP     ProLiant 00000001      00000000)
[    0.000000] ACPI: HPET 000000007f600240 00038 (v01 HP     ProLiant 00000002   Ò? 0000162E)
[    0.000000] ACPI: FFFF 000000007f600280 00064 (v02 HP     ProLiant 00000002   Ò? 0000162E)
[    0.000000] ACPI: SPMI 000000007f600300 00040 (v05 HP     ProLiant 00000001   Ò? 0000162E)
[    0.000000] ACPI: ERST 000000007f600340 001D0 (v01 HP     ProLiant 00000001   Ò? 0000162E)
[    0.000000] ACPI: APIC 000000007f600540 00476 (v01 HP     ProLiant 00000002      00000000)
[    0.000000] ACPI: SRAT 000000007f6009c0 012B0 (v01 HP     Proliant 00000001   Ò? 0000162E)
[    0.000000] ACPI: FFFF 000000007f601c80 00176 (v01 HP     ProLiant 00000001   Ò? 0000162E)
[    0.000000] ACPI: BERT 000000007f601e00 00030 (v01 HP     ProLiant 00000001   Ò? 0000162E)
[    0.000000] ACPI: HEST 000000007f601e40 000BC (v01 HP     ProLiant 00000001   Ò? 0000162E)
[    0.000000] ACPI: DMAR 000000007f601f00 00224 (v01 HP     ProLiant 00000001   Ò? 0000162E)
[    0.000000] ACPI: SLIT 000000007f602240 0006C (v01 HP     ProLiant 00000001      00000000)
[    0.000000] ACPI: SSDT 000000007f604ea0 00CD4 (v01 HP        SSDT1 00000001 INTL 20090625)
[    0.000000] ACPI: SSDT 000000007f605b80 00125 (v03     HP  CRSPCI0 00000002   HP 00000001)
[    0.000000] ACPI: SSDT 000000007f605cc0 00076 (v03     HP  CRSPCI1 00000002   HP 00000001)
[    0.000000] ACPI: SSDT 000000007f605d40 00D7B (v01     HP      pcc 00000001 INTL 20090625)
[    0.000000] ACPI: SSDT 000000007f606ac0 00377 (v01     HP     pmab 00000001 INTL 20090625)
[    0.000000] ACPI: SSDT 000000007f606e40 13824 (v01  INTEL PPM RCM  80000001 INTL 20061109)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x06 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x07 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x10 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x11 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x12 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x13 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x14 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x15 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x16 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x17 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x20 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x21 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x23 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x24 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x25 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x26 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x27 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x30 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x31 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x32 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x33 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x34 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x35 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x36 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x37 -> Node 1
[    0.000000] ACPI: [SRAT:0x00] ignored 192 entries of 256 found
[    0.000000] SRAT: Node 0 PXM 0 0-80000000
[    0.000000] SRAT: Node 0 PXM 0 100000000-480000000
[    0.000000] SRAT: Node 1 PXM 1 2000000000-2400000000
[    0.000000] SRAT: Node 2 PXM 2 4000000000-4400000000
[    0.000000] SRAT: Node 3 PXM 3 6000000000-6400000000
[    0.000000] SRAT: Node 4 PXM 4 8000000000-8200000000
[    0.000000] SRAT: Node 5 PXM 5 a000000000-a200000000
[    0.000000] SRAT: Node 6 PXM 6 c000000000-c200000000
[    0.000000] SRAT: Node 7 PXM 7 e000000000-e200000000
[    0.000000] SRAT: Node 0 [0,80000000) + [100000000,480000000) -> [0,480000000)
[    0.000000] NUMA: Using 37 for the hash shift.
[    0.000000] Initmem setup node 0 0000000000000000-0000000480000000
[    0.000000]   NODE_DATA [000000047fffb000 - 000000047fffffff]
[    0.000000] Initmem setup node 1 0000002000000000-0000002400000000
[    0.000000]   NODE_DATA [00000023ffffb000 - 00000023ffffffff]
[    0.000000] Initmem setup node 2 0000004000000000-0000004400000000
[    0.000000]   NODE_DATA [00000043ffffb000 - 00000043ffffffff]
[    0.000000] Initmem setup node 3 0000006000000000-0000006400000000
[    0.000000]   NODE_DATA [00000063ffffb000 - 00000063ffffffff]
[    0.000000] Initmem setup node 4 0000008000000000-0000008200000000
[    0.000000]   NODE_DATA [00000081ffffb000 - 00000081ffffffff]
[    0.000000] Initmem setup node 5 000000a000000000-000000a200000000
[    0.000000]   NODE_DATA [000000a1ffffb000 - 000000a1ffffffff]
[    0.000000] Initmem setup node 6 000000c000000000-000000c200000000
[    0.000000]   NODE_DATA [000000c1ffffb000 - 000000c1ffffffff]
[    0.000000] Initmem setup node 7 000000e000000000-000000e200000000
[    0.000000]   NODE_DATA [000000e1ffffa000 - 000000e1ffffefff]
[    0.000000]  [ffffea0000000000-ffffea000fbfffff] PMD -> [ffff88046fe00000-ffff88047ddfffff] on node 0
[    0.000000]  [ffffea0070000000-ffffea007dffffff] PMD -> [ffff8823efe00000-ffff8823fddfffff] on node 1
[    0.000000]  [ffffea00e0000000-ffffea00edffffff] PMD -> [ffff8843efe00000-ffff8843fddfffff] on node 2
[    0.000000]  [ffffea0150000000-ffffea015dffffff] PMD -> [ffff8863efe00000-ffff8863fddfffff] on node 3
[    0.000000]  [ffffea01c0000000-ffffea01c6ffffff] PMD -> [ffff8881f7e00000-ffff8881fedfffff] on node 4
[    0.000000]  [ffffea0230000000-ffffea0236ffffff] PMD -> [ffff88a1f7e00000-ffff88a1fedfffff] on node 5
[    0.000000]  [ffffea02a0000000-ffffea02a6ffffff] PMD -> [ffff88c1f7e00000-ffff88c1fedfffff] on node 6
[    0.000000]  [ffffea0310000000-ffffea0316ffffff] PMD -> [ffff88e1f7e00000-ffff88e1fedfffff] on node 7
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0e200000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[11] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x00000095
[    0.000000]     0: 0x00000100 -> 0x0007f600
[    0.000000]     0: 0x0007f62c -> 0x0007f62d
[    0.000000]     0: 0x00100000 -> 0x00480000
[    0.000000]     1: 0x02000000 -> 0x02400000
[    0.000000]     2: 0x04000000 -> 0x04400000
[    0.000000]     3: 0x06000000 -> 0x06400000
[    0.000000]     4: 0x08000000 -> 0x08200000
[    0.000000]     5: 0x0a000000 -> 0x0a200000
[    0.000000]     6: 0x0c000000 -> 0x0c200000
[    0.000000]     7: 0x0e000000 -> 0x0e200000
[    0.000000] On node 0 totalpages: 4191622
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3911 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 503353 pages, LIFO batch:31
[    0.000000]   Normal zone: 50176 pages used for memmap
[    0.000000]   Normal zone: 3619840 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 4194304
[    0.000000]   Normal zone: 57344 pages used for memmap
[    0.000000]   Normal zone: 4136960 pages, LIFO batch:31
[    0.000000] On node 2 totalpages: 4194304
[    0.000000]   Normal zone: 57344 pages used for memmap
[    0.000000]   Normal zone: 4136960 pages, LIFO batch:31
[    0.000000] On node 3 totalpages: 4194304
[    0.000000]   Normal zone: 57344 pages used for memmap
[    0.000000]   Normal zone: 4136960 pages, LIFO batch:31
[    0.000000] On node 4 totalpages: 2097152
[    0.000000]   Normal zone: 28672 pages used for memmap
[    0.000000]   Normal zone: 2068480 pages, LIFO batch:31
[    0.000000] On node 5 totalpages: 2097152
[    0.000000]   Normal zone: 28672 pages used for memmap
[    0.000000]   Normal zone: 2068480 pages, LIFO batch:31
[    0.000000] On node 6 totalpages: 2097152
[    0.000000]   Normal zone: 28672 pages used for memmap
[    0.000000]   Normal zone: 2068480 pages, LIFO batch:31
[    0.000000] On node 7 totalpages: 2097152
[    0.000000]   Normal zone: 28672 pages used for memmap
[    0.000000]   Normal zone: 2068480 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x908
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x16] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x24] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x26] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x30] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x32] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x34] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x36] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x20] lapic_id[0x40] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x22] lapic_id[0x42] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x24] lapic_id[0x44] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x26] lapic_id[0x46] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x28] lapic_id[0x50] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2a] lapic_id[0x52] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2c] lapic_id[0x54] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2e] lapic_id[0x56] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x30] lapic_id[0x60] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x32] lapic_id[0x62] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x34] lapic_id[0x64] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x36] lapic_id[0x66] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x38] lapic_id[0x70] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3a] lapic_id[0x72] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3c] lapic_id[0x74] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3e] lapic_id[0x76] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x40] lapic_id[0x80] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x42] lapic_id[0x82] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x44] lapic_id[0x84] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x46] lapic_id[0x86] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x48] lapic_id[0x90] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4a] lapic_id[0x92] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4c] lapic_id[0x94] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4e] lapic_id[0x96] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x50] lapic_id[0xa0] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x52] lapic_id[0xa2] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x54] lapic_id[0xa4] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x56] lapic_id[0xa6] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x58] lapic_id[0xb0] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5a] lapic_id[0xb2] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5c] lapic_id[0xb4] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5e] lapic_id[0xb6] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x60] lapic_id[0xc0] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x62] lapic_id[0xc2] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x64] lapic_id[0xc4] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x66] lapic_id[0xc6] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x68] lapic_id[0xd0] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x6a] lapic_id[0xd2] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x6c] lapic_id[0xd4] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x6e] lapic_id[0xd6] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x70] lapic_id[0xe0] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x72] lapic_id[0xe2] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x74] lapic_id[0xe4] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x76] lapic_id[0xe6] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x78] lapic_id[0xf0] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x7a] lapic_id[0xf2] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x7c] lapic_id[0xf4] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x7e] lapic_id[0xf6] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 64/0x1 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 65/0x3 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 66/0x5 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 67/0x7 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x11] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 68/0x11 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x13] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 69/0x13 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x15] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 70/0x15 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x17] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 71/0x17 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x21] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 72/0x21 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x23] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 73/0x23 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x25] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 74/0x25 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x27] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 75/0x27 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x31] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 76/0x31 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x33] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 77/0x33 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x35] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 78/0x35 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x37] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 79/0x37 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x21] lapic_id[0x41] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 80/0x41 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x23] lapic_id[0x43] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 81/0x43 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x25] lapic_id[0x45] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 82/0x45 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x27] lapic_id[0x47] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 83/0x47 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x29] lapic_id[0x51] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 84/0x51 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x2b] lapic_id[0x53] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 85/0x53 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x2d] lapic_id[0x55] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 86/0x55 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x2f] lapic_id[0x57] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 87/0x57 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x31] lapic_id[0x61] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 88/0x61 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x33] lapic_id[0x63] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 89/0x63 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x35] lapic_id[0x65] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 90/0x65 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x37] lapic_id[0x67] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 91/0x67 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x39] lapic_id[0x71] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 92/0x71 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x3b] lapic_id[0x73] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 93/0x73 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x3d] lapic_id[0x75] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 94/0x75 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x3f] lapic_id[0x77] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 95/0x77 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x41] lapic_id[0x81] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 96/0x81 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x43] lapic_id[0x83] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 97/0x83 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x45] lapic_id[0x85] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 98/0x85 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x47] lapic_id[0x87] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 99/0x87 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x49] lapic_id[0x91] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 100/0x91 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x4b] lapic_id[0x93] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 101/0x93 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x4d] lapic_id[0x95] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 102/0x95 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x4f] lapic_id[0x97] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 103/0x97 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x51] lapic_id[0xa1] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 104/0xa1 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x53] lapic_id[0xa3] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 105/0xa3 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x55] lapic_id[0xa5] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 106/0xa5 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x57] lapic_id[0xa7] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 107/0xa7 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x59] lapic_id[0xb1] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 108/0xb1 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x5b] lapic_id[0xb3] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 109/0xb3 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x5d] lapic_id[0xb5] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 110/0xb5 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x5f] lapic_id[0xb7] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 111/0xb7 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x61] lapic_id[0xc1] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 112/0xc1 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x63] lapic_id[0xc3] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 113/0xc3 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x65] lapic_id[0xc5] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 114/0xc5 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x67] lapic_id[0xc7] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 115/0xc7 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x69] lapic_id[0xd1] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 116/0xd1 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x6b] lapic_id[0xd3] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 117/0xd3 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x6d] lapic_id[0xd5] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 118/0xd5 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x6f] lapic_id[0xd7] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 119/0xd7 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x71] lapic_id[0xe1] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 120/0xe1 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x73] lapic_id[0xe3] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 121/0xe3 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x75] lapic_id[0xe5] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 122/0xe5 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x77] lapic_id[0xe7] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 123/0xe7 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x79] lapic_id[0xf1] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 124/0xf1 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x7b] lapic_id[0xf3] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 125/0xf3 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x7d] lapic_id[0xf5] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 126/0xf5 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x7f] lapic_id[0xf7] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 64 reached.  Processor 127/0xf7 ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec08000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 0, version 32, address 0xfec08000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x0a] address[0xfec10000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 10, version 32, address 0xfec10000, GSI 48-71
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] 128 Processors exceeds NR_CPUS limit of 64
[    0.000000] SMP: Allowing 64 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 88
[    0.000000] PM: Registered nosave memory: 0000000000095000 - 0000000000096000
[    0.000000] PM: Registered nosave memory: 0000000000096000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 000000007f600000 - 000000007f62c000
[    0.000000] PM: Registered nosave memory: 000000007f62d000 - 000000007f79d000
[    0.000000] PM: Registered nosave memory: 000000007f79d000 - 000000007f7a0000
[    0.000000] PM: Registered nosave memory: 000000007f7a0000 - 0000000090000000
[    0.000000] PM: Registered nosave memory: 0000000090000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fee10000
[    0.000000] PM: Registered nosave memory: 00000000fee10000 - 00000000ff800000
[    0.000000] PM: Registered nosave memory: 00000000ff800000 - 0000000100000000
[    0.000000] PM: Registered nosave memory: 0000000480000000 - 0000002000000000
[    0.000000] PM: Registered nosave memory: 0000002400000000 - 0000004000000000
[    0.000000] PM: Registered nosave memory: 0000004400000000 - 0000006000000000
[    0.000000] PM: Registered nosave memory: 0000006400000000 - 0000008000000000
[    0.000000] PM: Registered nosave memory: 0000008200000000 - 000000a000000000
[    0.000000] PM: Registered nosave memory: 000000a200000000 - 000000c000000000
[    0.000000] PM: Registered nosave memory: 000000c200000000 - 000000e000000000
[    0.000000] Allocating PCI resources starting at 90000000 (gap: 90000000:6ec00000)
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:64 nr_node_ids:8
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff88007ee00000 s75520 r8192 d22784 u262144
[    0.000000] pcpu-alloc: s75520 r8192 d22784 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 [0] 16 24 32 40 48 56 -- -- 
[    0.000000] pcpu-alloc: [1] 08 09 10 11 12 13 14 15 [1] 17 25 33 41 49 57 -- -- 
[    0.000000] pcpu-alloc: [2] 18 26 34 42 50 58 -- -- [3] 19 27 35 43 51 59 -- -- 
[    0.000000] pcpu-alloc: [4] 20 28 36 44 52 60 -- -- [5] 21 29 37 45 53 61 -- -- 
[    0.000000] pcpu-alloc: [6] 22 30 38 46 54 62 -- -- [7] 23 31 39 47 55 63 -- -- 
[    0.000000] Built 8 zonelists in Zone order, mobility grouping on.  Total pages: 24811904
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: console=ttyS0,115200n8 debug ignore_loglevel root=/dev/sdb1 BOOT_IMAGE=kernel 
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 99187376k/947912704k available (6314k kernel code, 847260136k absent, 1465192k reserved, 6923k data, 628k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=64, Nodes=8
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:2008 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.001000] Fast TSC calibration using PIT
[    0.002000] Detected 2260.690 MHz processor.
[    0.000039] Calibrating delay loop (skipped), value calculated using timer frequency.. 4521.38 BogoMIPS (lpj=2260690)
[    0.011699] pid_max: default: 65536 minimum: 512
[    0.016868] Security Framework initialized
[    0.021367] SELinux:  Initializing.
[    0.025209] SELinux:  Starting in permissive mode
[    0.042856] Dentry cache hash table entries: 16777216 (order: 15, 134217728 bytes)
[    0.106425] Inode-cache hash table entries: 8388608 (order: 14, 67108864 bytes)
[    0.138924] Mount-cache hash table entries: 256
[    0.144463] Initializing cgroup subsys ns
[    0.148868] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.158606] Initializing cgroup subsys cpuacct
[    0.163492] Initializing cgroup subsys freezer
[    0.168441] CPU: Physical Processor ID: 0
[    0.172842] CPU: Processor Core ID: 0
[    0.176865] mce: CPU supports 22 MCE banks
[    0.181380] CPU0: Thermal monitoring enabled (TM1)
[    0.186653] using mwait in idle threads.
[    0.190958] Performance Events: PEBS fmt1+, Nehalem events, Intel PMU driver.
[    0.198837] ... version:                3
[    0.203237] ... bit width:              48
[    0.207732] ... generic registers:      4
[    0.212132] ... value mask:             0000ffffffffffff
[    0.217961] ... max period:             000000007fffffff
[    0.223791] ... fixed-purpose events:   3
[    0.228191] ... event mask:             000000070000000f
[    0.234139] ACPI: Core revision 20101013
[    0.266242] DMAR: Host address width 40
[    0.270463] DMAR: DRHD base: 0x000000ac000000 flags: 0x0
[    0.276418] IOMMU 0: reg_base_addr ac000000 ver 1:0 cap c90780106f0462 ecap f0207e
[    0.284833] DMAR: DRHD base: 0x000000a8000000 flags: 0x1
[    0.290674] IOMMU 1: reg_base_addr a8000000 ver 1:0 cap c90780106f0462 ecap f0207e
[    0.298985] DMAR: RMRR base: 0x0000007f7ee000 end: 0x0000007f7effff
[    0.305863] DMAR: RMRR base: 0x0000007f7e7000 end: 0x0000007f7ecfff
[    0.312743] DMAR: RMRR base: 0x0000007f62e000 end: 0x0000007f62ffff
[    0.319623] DMAR: ATSR flags: 0x0
[    0.323263] DMAR: ATSR flags: 0x0
[    0.327246] Not enabling x2apic, Intr-remapping init failed.
[    0.333456] Setting APIC routing to physical flat
[    0.339341] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.355908] CPU0: Intel(R) Xeon(R) CPU           X7560  @ 2.27GHz stepping 06
[    0.465527] Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 Ok.
[    1.113504] Booting Node   1, Processors  #8 #9 #10 #11 #12 #13 #14 #15 Ok.
[    1.903797] Booting Node   0, Processors  #16 Ok.
[    2.002595] Booting Node   1, Processors  #17 Ok.
[    2.101438] Booting Node   2, Processors  #18 Ok.
[    2.200161] Booting Node   3, Processors  #19 Ok.
[    2.298980] Booting Node   4, Processors  #20 Ok.
[    2.397807] Booting Node   5, Processors  #21 Ok.
[    2.496533] Booting Node   6, Processors  #22 Ok.
[    2.595281] Booting Node   7, Processors  #23 Ok.
[    2.694071] Booting Node   0, Processors  #24 Ok.
[    2.792885] Booting Node   1, Processors  #25 Ok.
[    2.891713] Booting Node   2, Processors  #26 Ok.
[    2.990416] Booting Node   3, Processors  #27 Ok.
[    3.089223] Booting Node   4, Processors  #28 Ok.
[    3.188038] Booting Node   5, Processors  #29 Ok.
[    3.286840] Booting Node   6, Processors  #30 Ok.
[    3.385642] Booting Node   7, Processors  #31 Ok.
[    3.484367] Booting Node   0, Processors  #32 Ok.
[    3.583180] Booting Node   1, Processors  #33 Ok.
[    3.681948] Booting Node   2, Processors  #34 Ok.
[    3.780756] Booting Node   3, Processors  #35 Ok.
[    3.914442] Booting Node   4, Processors  #36 Ok.
[    4.013294] Booting Node   5, Processors  #37 Ok.
[    4.112001] Booting Node   6, Processors  #38 Ok.
[    4.210805] Booting Node   7, Processors  #39 Ok.
[    4.309606] Booting Node   0, Processors  #40 Ok.
[    4.408411] Booting Node   1, Processors  #41 Ok.
[    4.507248] Booting Node   2, Processors  #42 Ok.
[    4.605932] Booting Node   3, Processors  #43 Ok.
[    4.704747] Booting Node   4, Processors  #44 Ok.
[    4.803562] Booting Node   5, Processors  #45 Ok.
[    4.902385] Booting Node   6, Processors  #46 Ok.
[    5.001097] Booting Node   7, Processors  #47 Ok.
[    5.099909] Booting Node   0, Processors  #48 Ok.
[    5.198705] Booting Node   1, Processors  #49 Ok.
[    5.297518] Booting Node   2, Processors  #50 Ok.
[    5.396236] Booting Node   3, Processors  #51 Ok.
[    5.495055] Booting Node   4, Processors  #52 Ok.
[    5.592893] Booting Node   5, Processors  #53 Ok.
[    5.691609] Booting Node   6, Processors  #54 Ok.
[    5.790442] Booting Node   7, Processors  #55 Ok.
[    5.889226] Booting Node   0, Processors  #56 Ok.
[    5.988025] Booting Node   1, Processors  #57 Ok.
[    6.086806] Booting Node   2, Processors  #58 Ok.
[    6.185541] Booting Node   3, Processors  #59 Ok.
[    6.284365] Booting Node   4, Processors  #60 Ok.
[    6.418052] Booting Node   5, Processors  #61 Ok.
[    6.516870] Booting Node   6, Processors  #62 Ok.
[    6.615640] Booting Node   7, Processors  #63 Ok.
[    6.713775] Brought up 64 CPUs
[    6.717131] Total of 64 processors activated (289375.84 BogoMIPS).
[    7.083688] divide error: 0000 [#1] SMP 
[    7.088006] last sysfs file: 
[    7.091254] CPU 1 
[    7.093266] Modules linked in:
[    7.096816] 
[    7.098448] Pid: 2, comm: kthreadd Not tainted 2.6.37-rc1-00171-g3712c6c #153 /ProLiant DL980 G7
[    7.108085] RIP: 0010:[<ffffffff81034645>]  [<ffffffff81034645>] select_task_rq_fair+0x62a/0x7a0
[    7.117734] RSP: 0000:ffff88046f869c30  EFLAGS: 00010046
[    7.123557] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[    7.131382] RDX: 0000000000000000 RSI: 0000000000000040 RDI: 0000000000000040
[    7.139208] RBP: ffff88046f869d30 R08: 0000000000000000 R09: ffff88046fa6e598
[    7.147033] R10: 0000000000000000 R11: 0000000000000080 R12: ffff88046fa6e580
[    7.154857] R13: ffff88007ee4da50 R14: 0000000000011ac0 R15: 0000000000000000
[    7.162683] FS:  0000000000000000(0000) GS:ffff88007ee40000(0000) knlGS:0000000000000000
[    7.171555] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    7.177855] CR2: 0000000000000000 CR3: 0000000001c07000 CR4: 00000000000006e0
[    7.185680] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    7.193505] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    7.201330] Process kthreadd (pid: 2, threadinfo ffff88046f868000, task ffff88e1f6c40750)
[    7.210296] Stack:
[    7.212496]  ffff880400000000 0000000000011ac0 0000000000011ac0 0000000000011ac0
[    7.220638]  0000000000011ac0 0000000000011ac8 0000000000011ac8 0000000000800711
[    7.228779]  0000000800000000 ffff88046f420000 ffff88007ee51ac0 0000000081c19b60
[    7.236922] Call Trace:
[    7.239607]  [<ffffffff810ab0aa>] ? perf_event_fork+0x10/0x12
[    7.245908]  [<ffffffff8103d735>] ? copy_process+0xdf0/0xf9a
[    7.252115]  [<ffffffff8103787b>] select_task_rq+0x13/0x4a
[    7.258130]  [<ffffffff81038dae>] wake_up_new_task+0x39/0xdb
[    7.264334]  [<ffffffff8103db35>] do_fork+0x256/0x314
[    7.269874]  [<ffffffff810333ae>] ? dequeue_entity+0x19/0x19b
[    7.276173]  [<ffffffff81033213>] ? set_next_entity+0x43/0x96
[    7.282477]  [<ffffffff8100997c>] kernel_thread+0x6b/0x6d
[    7.288397]  [<ffffffff81057b92>] ? kthread+0x0/0x89
[    7.293840]  [<ffffffff81003850>] ? kernel_thread_helper+0x0/0x10
[    7.300521]  [<ffffffff81057cf1>] kthreadd+0xd6/0x111
[    7.306121]  [<ffffffff81003854>] kernel_thread_helper+0x4/0x10
[    7.312613]  [<ffffffff81057c1b>] ? kthreadd+0x0/0x111
[    7.318248]  [<ffffffff81003850>] ? kernel_thread_helper+0x0/0x10
[    7.324928] Code: ff ff ff e8 ee 8c 1b 00 3b 05 58 f3 ca 00 89 c2 44 8b 85 00 ff ff ff 0f 8c 74 ff ff ff 41 8b 4c 24 08 48 c1 e3 0a 31 d2 48 89 d8 <48> f7 f1 83 7d 90 00 48 89 c1 75 16 4c 39 f8 73 0d 49 89 c7 48 
[    7.346101] RIP  [<ffffffff81034645>] select_task_rq_fair+0x62a/0x7a0
[    7.353175]  RSP <ffff88046f869c30>
[    7.357001] ---[ end trace 4eaa2a86a8e2da22 ]---

--=-sj+oWlayMRwjpdkeCdmq--

