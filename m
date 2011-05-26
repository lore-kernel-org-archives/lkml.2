Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab1EZGHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 02:07:01 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59687 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756755Ab1EZGG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 02:06:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=MgOqT3Z2NobRxO6VgsiCM12sqREfXZ1FoEHuQklNCFgIhHFIdcYSNjPHfzs3v1LyXw
         MWu4EnAzlkJHiLFxoqNB4bsm83hvnmu5LkTgOdYkpXL1cYmc75THCkHoWs7Kd4Y1Eopl
         O+KigdooboyzAZa57UL3loMGYKhVq4g/7yFto=
Subject: Re: [GIT PULL] Core block bits for 2.6.40
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Tao Ma <boyu.mt@taobao.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4DDDEA83.5040306@fusionio.com>
References: <4DDCFE21.80003@fusionio.com>
	 <1306388153.2664.4.camel@edumazet-laptop>  <4DDDEA83.5040306@fusionio.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 May 2011 08:06:51 +0200
Message-ID: <1306390011.2664.13.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 26 mai 2011 à 07:52 +0200, Jens Axboe a écrit :
> On 2011-05-26 07:35, Eric Dumazet wrote:
> > Le mercredi 25 mai 2011 à 15:03 +0200, Jens Axboe a écrit :
> >> Hi Linus,
> >>
> >> A real pull request this time. These are the core bits for the next
> >> kernel. Nothing exciting in here in this round, with the churn in
> >> the last release, this release will be mellow.
> >>
> >> - Optimizations for queue flushing on SATA devices, where we
> >>   can't queue a FLUSH command. This fixes up a performance regression
> >>   caused by a bug fix to prevent potential live lock on adding
> >>   FLUSH commands at the head of the queue.
> >>
> >> - Make stats lockless for blk-cgroup.
> >>
> >> - Various bug fixes for blk-cgroup.
> >>
> >> - Various little fixes and improvements to CFQ.
> >>
> >> - Last round of media event changes.
> >>
> >> - Fixes for discard topology reporting and sysfs documentation update
> >>   for the same.
> >>
> >> - Add support for batched discards. This greatly speeds up discarding
> >>   an entire device.
> >>
> >> - Fix for bad return value in the discard ioctl.
> >>
> >> - Remove request plug state debug checks. Haven't triggered even during
> >>   the 2.6.39-rc devel cycle, so get rid of them.
> >>
> >>
> >> Please pull!
> >>
> >>
> >>   git://git.kernel.dk/linux-2.6-block.git for-2.6.40/core
> >>
> > 
> >> Tao Ma (2):
> >>       block: Remove 'plug/unplug' comment in blk_execute_rq_nowait
> >>       block: Remove extra discard_alignment from hd_struct.
> > 
> > At boot, I have a crash in part_discard_alignment_show+0x1b/0x50
> > 
> > CR2 : 000006ac
> > 
> > fault in : mov    0x2c(%rcx),%edx
> > 
> > I suspect commit 23ceb5b7719e9276d4 (block: Remove extra
> > discard_alignment from hd_struct) being in fault
> 
> Hmm, that must be disk->queue == NULL. Do you have a trace of the crash,
> with the surrounding boot messages? I wonder what is special about your
> setup to trigger something like this.
> 
> diff --git a/fs/partitions/check.c b/fs/partitions/check.c
> index 8ed4d34..f82e762 100644
> --- a/fs/partitions/check.c
> +++ b/fs/partitions/check.c
> @@ -256,10 +256,12 @@ ssize_t part_discard_alignment_show(struct device *dev,
>  {
>  	struct hd_struct *p = dev_to_part(dev);
>  	struct gendisk *disk = dev_to_disk(dev);
> +	unsigned int alignment = 0;
>  
> -	return sprintf(buf, "%u\n",
> -			queue_limit_discard_alignment(&disk->queue->limits,
> -							p->start_sect));
> +	if (disk->queue)
> +		alignment = queue_limit_discard_alignment(&disk->queue->limits,
> +								p->start_sect);
> +	return sprintf(buf, "%u\n", alignment);
>  }
>  
>  ssize_t part_stat_show(struct device *dev,
> 
> 

Thats approximatively the patch I tried, yes, I confirm disk->queue can
be NULL.

My setup is an old RedHat4 32bit distro (update 5), but use it every day
for kernel dev. (using a 64bit kernel most of the time)

Here is a copy of my dmesg (you can see my traces of disk->queue=NULL)

[    0.000000] Linux version 2.6.39-06660-ge84bdb8-dirty (root@svivoipvnx021) (gcc version 4.1.2) #652 SMP Thu May 26 07:57:32 CEST 2011
[    0.000000] Command line: root=LABEL=/ nofb sysrq_always_enabled=1 debug netconsole=4444@192.168.20.108/eth1,4444@192.168.20.112/00:1e:0b:ec:c3:e4 vga=6 hashdist=1 slub_nomerge maxcpus=16 possible_cpus=16 thash_entries=4096 rhash_entries=4096 
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
[    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000df62f000 (usable)
[    0.000000]  BIOS-e820: 00000000df62f000 - 00000000df63c000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000df63c000 - 00000000df63d000 (usable)
[    0.000000]  BIOS-e820: 00000000df63d000 - 00000000e4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000011ffff000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.7 present.
[    0.000000] DMI: HP ProLiant BL460c G6, BIOS I24 01/29/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x11ffff max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xdf63d max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000f4f80] f4f80
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000df63d000
[    0.000000]  0000000000 - 00df600000 page 2M
[    0.000000]  00df600000 - 00df63d000 page 4k
[    0.000000] kernel direct mapping tables up to df63d000 @ df629000-df62f000
[    0.000000] init_memory_mapping: 0000000100000000-000000011ffff000
[    0.000000]  0100000000 - 011fe00000 page 2M
[    0.000000]  011fe00000 - 011ffff000 page 4k
[    0.000000] kernel direct mapping tables up to 11ffff000 @ 11fff8000-11ffff000
[    0.000000] RAMDISK: 37f75000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f4f00 00024 (v02 HP    )
[    0.000000] ACPI: XSDT 00000000df630080 000AC (v01 HP     ProLiant 00000002   �? 0000162E)
[    0.000000] ACPI: FACP 00000000df630180 000F4 (v03 HP     ProLiant 00000002   �? 0000162E)
[    0.000000] ACPI Warning: Invalid length for Pm1aControlBlock: 32, using default 16 (20110316/tbfadt-610)
[    0.000000] ACPI Warning: Invalid length for Pm2ControlBlock: 32, using default 8 (20110316/tbfadt-610)
[    0.000000] ACPI: DSDT 00000000df630280 01F90 (v01 HP         DSDT 00000001 INTL 20030228)
[    0.000000] ACPI: FACS 00000000df62f100 00040
[    0.000000] ACPI: SPCR 00000000df62f140 00050 (v01 HP     SPCRRBSU 00000001   �? 0000162E)
[    0.000000] ACPI: MCFG 00000000df62f1c0 0003C (v01 HP     ProLiant 00000001      00000000)
[    0.000000] ACPI: HPET 00000000df62f200 00038 (v01 HP     ProLiant 00000002   �? 0000162E)
[    0.000000] ACPI: FFFF 00000000df62f240 00064 (v02 HP     ProLiant 00000002   �? 0000162E)
[    0.000000] ACPI: SPMI 00000000df62f2c0 00040 (v05 HP     ProLiant 00000001   �? 0000162E)
[    0.000000] ACPI: ERST 00000000df62f300 001D0 (v01 HP     ProLiant 00000001   �? 0000162E)
[    0.000000] ACPI: APIC 00000000df62f500 0015E (v01 HP     ProLiant 00000002      00000000)
[    0.000000] ACPI: SRAT 00000000df62f680 00570 (v01 HP     Proliant 00000001   �? 0000162E)
[    0.000000] ACPI: FFFF 00000000df62fc00 00176 (v01 HP     ProLiant 00000001   �? 0000162E)
[    0.000000] ACPI: BERT 00000000df62fd80 00030 (v01 HP     ProLiant 00000001   �? 0000162E)
[    0.000000] ACPI: HEST 00000000df62fdc0 000BC (v01 HP     ProLiant 00000001   �? 0000162E)
[    0.000000] ACPI: DMAR 00000000df62fe80 0013C (v01 HP     ProLiant 00000001   �? 0000162E)
[    0.000000] ACPI: SSDT 00000000df632240 00125 (v03     HP  CRSPCI0 00000002   HP 00000001)
[    0.000000] ACPI: SSDT 00000000df632380 003BB (v01     HP      pcc 00000001 INTL 20090625)
[    0.000000] ACPI: SSDT 00000000df632740 00377 (v01     HP     pmab 00000001 INTL 20090625)
[    0.000000] ACPI: SSDT 00000000df632ac0 022E4 (v01  INTEL PPM RCM  00000001 INTL 20061109)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x06 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x07 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x10 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x11 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x12 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x13 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x14 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x15 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x16 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x17 -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 0-80000000
[    0.000000] SRAT: Node 1 PXM 1 80000000-e0000000
[    0.000000] SRAT: Node 1 PXM 1 100000000-120000000
[    0.000000] NUMA: Node 1 [80000000,e0000000) + [100000000,11ffff000) -> [80000000,11ffff000)
[    0.000000] Initmem setup node 0 0000000000000000-0000000080000000
[    0.000000]   NODE_DATA [000000007fffd000 - 000000007fffffff]
[    0.000000] Initmem setup node 1 0000000080000000-000000011ffff000
[    0.000000]   NODE_DATA [000000011fffc000 - 000000011fffefff]
[    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff88007de00000-ffff88007f9fffff] on node 0
[    0.000000]  [ffffea0001c00000-ffffea0003ffffff] PMD -> [ffff88011d600000-ffff88011f3fffff] on node 1
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0011ffff
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[5] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x00080000
[    0.000000]     1: 0x00080000 -> 0x000df62f
[    0.000000]     1: 0x000df63c -> 0x000df63d
[    0.000000]     1: 0x00100000 -> 0x0011ffff
[    0.000000] On node 0 totalpages: 524175
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3922 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7112 pages used for memmap
[    0.000000]   DMA32 zone: 513080 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 521775
[    0.000000]   DMA32 zone: 7168 pages used for memmap
[    0.000000]   DMA32 zone: 383536 pages, LIFO batch:31
[    0.000000]   Normal zone: 1792 pages used for memmap
[    0.000000]   Normal zone: 129279 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x908
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x20] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x30] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x24] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x34] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x22] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x32] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x26] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x16] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x36] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x21] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x31] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x25] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x35] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x23] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x33] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x27] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x17] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x37] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec80000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 0, version 32, address 0xfec80000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 16 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 64
[    0.000000] Allocating PCI resources starting at e4000000 (gap: e4000000:1ac00000)
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:16 nr_node_ids:2
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff88007fc00000 s71168 r8192 d23040 u262144
[    0.000000] pcpu-alloc: s71168 r8192 d23040 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 02 04 06 08 10 12 14 [1] 01 03 05 07 09 11 13 15 
[    0.000000] Built 2 zonelists in Node order, mobility grouping on.  Total pages: 1029817
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=LABEL=/ nofb sysrq_always_enabled=1 debug netconsole=4444@192.168.20.108/eth1,4444@192.168.20.112/00:1e:0b:ec:c3:e4 vga=6 hashdist=1 slub_nomerge maxcpus=16 possible_cpus=16 thash_entries=4096 rhash_entries=4096 
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 4033812k/4718588k available (4591k kernel code, 534788k absent, 149988k reserved, 6998k data, 508k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=16, Nodes=2
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	CONFIG_RCU_FANOUT set to non-default value of 32
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU lockdep checking is enabled.
[    0.000000] NR_IRQS:2304
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x60
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.010000] Detected 2533.618 MHz processor.
[    0.000006] Calibrating delay loop (skipped), value calculated using timer frequency.. 5067.23 BogoMIPS (lpj=25336180)
[    0.000226] pid_max: default: 32768 minimum: 301
[    0.000899] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.002180] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.002806] Mount-cache hash table entries: 256
[    0.003837] CPU: Physical Processor ID: 1
[    0.003939] CPU: Processor Core ID: 0
[    0.004044] mce: CPU supports 9 MCE banks
[    0.004155] CPU0: Thermal monitoring enabled (TM1)
[    0.004272] using mwait in idle threads.
[    0.004469] ACPI: Core revision 20110316
[    0.008485] Switched APIC routing to physical flat.
[    0.009096] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.108311] CPU0: Intel(R) Xeon(R) CPU           E5540  @ 2.53GHz stepping 05
[    0.218621] Performance Events: PEBS fmt1+, erratum AAJ80 worked around, Nehalem events, Broken BIOS detected, complain to your hardware vendor.
[    0.218959] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR 38d is 330)
[    0.219125] Intel PMU driver.
[    0.219222] ... version:                3
[    0.219323] ... bit width:              48
[    0.219426] ... generic registers:      4
[    0.219528] ... value mask:             0000ffffffffffff
[    0.219638] ... max period:             000000007fffffff
[    0.219748] ... fixed-purpose events:   3
[    0.219850] ... event mask:             000000070000000f
[    0.220598] lockdep: fixing up alternatives.
[    0.220849] Booting Node   0, Processors  #1
[    0.220946] smpboot cpu 1: start_ip = 9a000
[    0.258603] calibrate_delay_direct() timer_rate_max=25334100 timer_rate_min=25332976 pre_start=305346414386 pre_end=305371747926
[    0.288584] calibrate_delay_direct() timer_rate_max=25334096 timer_rate_min=25332908 pre_start=305422415066 pre_end=305447748530
[    0.318569] calibrate_delay_direct() timer_rate_max=25334076 timer_rate_min=25332964 pre_start=305498415578 pre_end=305523749110
[    0.348553] calibrate_delay_direct() timer_rate_max=25333628 timer_rate_min=25333428 pre_start=305574416202 pre_end=305599749730
[    0.378538] calibrate_delay_direct() timer_rate_max=25334084 timer_rate_min=25332984 pre_start=305650416874 pre_end=305675750406
[    0.398744] lockdep: fixing up alternatives.
[    0.399809]  Ok.
[    0.399898] Booting Node   1, Processors  #2
[    0.399993] smpboot cpu 2: start_ip = 9a000
[    0.438510] calibrate_delay_direct() timer_rate_max=25333940 timer_rate_min=25332988 pre_start=305802418534 pre_end=305827752014
[    0.468492] calibrate_delay_direct() timer_rate_max=25334012 timer_rate_min=25333068 pre_start=305878419098 pre_end=305903752630
[    0.498477] calibrate_delay_direct() timer_rate_max=25334332 timer_rate_min=25333380 pre_start=305954419698 pre_end=305979753562
[    0.528461] calibrate_delay_direct() timer_rate_max=25333652 timer_rate_min=25333096 pre_start=306030420650 pre_end=306055754206
[    0.558446] calibrate_delay_direct() timer_rate_max=25333996 timer_rate_min=25333044 pre_start=306106421230 pre_end=306131754758
[    0.578687] lockdep: fixing up alternatives.
[    0.579768]  Ok.
[    0.579857] Booting Node   0, Processors  #3
[    0.579954] smpboot cpu 3: start_ip = 9a000
[    0.618418] calibrate_delay_direct() timer_rate_max=25333840 timer_rate_min=25332712 pre_start=306258422304 pre_end=306283755588
[    0.648400] calibrate_delay_direct() timer_rate_max=25334068 timer_rate_min=25332984 pre_start=306334422684 pre_end=306359756212
[    0.678384] calibrate_delay_direct() timer_rate_max=25334148 timer_rate_min=25333032 pre_start=306410423596 pre_end=306435757196
[    0.708369] calibrate_delay_direct() timer_rate_max=25333984 timer_rate_min=25332864 pre_start=306486424312 pre_end=306511757744
[    0.738354] calibrate_delay_direct() timer_rate_max=25334152 timer_rate_min=25333504 pre_start=306562424876 pre_end=306587758476
[    0.758608] lockdep: fixing up alternatives.
[    0.759685]  Ok.
[    0.759774] Booting Node   1, Processors  #4
[    0.759870] smpboot cpu 4: start_ip = 9a000
[    0.798326] calibrate_delay_direct() timer_rate_max=25333928 timer_rate_min=25332988 pre_start=306714425673 pre_end=306739759141
[    0.828307] calibrate_delay_direct() timer_rate_max=25333984 timer_rate_min=25333052 pre_start=306790426217 pre_end=306815759737
[    0.858292] calibrate_delay_direct() timer_rate_max=25333612 timer_rate_min=25333044 pre_start=306866427125 pre_end=306891760641
[    0.888277] calibrate_delay_direct() timer_rate_max=25334016 timer_rate_min=25333092 pre_start=306942427769 pre_end=306967761325
[    0.918261] calibrate_delay_direct() timer_rate_max=25334008 timer_rate_min=25333060 pre_start=307018428037 pre_end=307043761577
[    0.938482] lockdep: fixing up alternatives.
[    0.939179]  Ok.
[    0.939231] Booting Node   0, Processors  #5
[    0.939308] smpboot cpu 5: start_ip = 9a000
[    0.978233] calibrate_delay_direct() timer_rate_max=25333996 timer_rate_min=25332860 pre_start=307170429443 pre_end=307195762871
[    1.008215] calibrate_delay_direct() timer_rate_max=25333624 timer_rate_min=25332984 pre_start=307246429983 pre_end=307271763511
[    1.038200] calibrate_delay_direct() timer_rate_max=25334404 timer_rate_min=25333760 pre_start=307322430579 pre_end=307347764439
[    1.068184] calibrate_delay_direct() timer_rate_max=25334112 timer_rate_min=25333004 pre_start=307398431519 pre_end=307423765083
[    1.098169] calibrate_delay_direct() timer_rate_max=25334088 timer_rate_min=25333432 pre_start=307474432155 pre_end=307499765687
[    1.118387] lockdep: fixing up alternatives.
[    1.123299]  Ok.
[    1.123387] Booting Node   1, Processors  #6
[    1.123483] smpboot cpu 6: start_ip = 9a000
[    1.158141] calibrate_delay_direct() timer_rate_max=25334340 timer_rate_min=25333372 pre_start=307626432938 pre_end=307651766774
[    1.188123] calibrate_delay_direct() timer_rate_max=25333672 timer_rate_min=25333088 pre_start=307702433522 pre_end=307727767094
[    1.218107] calibrate_delay_direct() timer_rate_max=25333844 timer_rate_min=25332900 pre_start=307778434462 pre_end=307803767846
[    1.248092] calibrate_delay_direct() timer_rate_max=25334144 timer_rate_min=25333224 pre_start=307854434946 pre_end=307879768626
[    1.278077] calibrate_delay_direct() timer_rate_max=25334016 timer_rate_min=25333072 pre_start=307930435658 pre_end=307955769206
[    1.298306] lockdep: fixing up alternatives.
[    1.299385]  Ok.
[    1.299474] Booting Node   0, Processors  #7
[    1.299571] smpboot cpu 7: start_ip = 9a000
[    1.338049] calibrate_delay_direct() timer_rate_max=25334012 timer_rate_min=25332904 pre_start=308082436722 pre_end=308107770182
[    1.368031] calibrate_delay_direct() timer_rate_max=25334568 timer_rate_min=25333464 pre_start=308158437314 pre_end=308183771322
[    1.398015] calibrate_delay_direct() timer_rate_max=25333956 timer_rate_min=25332840 pre_start=308234438322 pre_end=308259771726
[    1.428000] calibrate_delay_direct() timer_rate_max=25333860 timer_rate_min=25333668 pre_start=308310438794 pre_end=308335772558
[    1.457984] calibrate_delay_direct() timer_rate_max=25334080 timer_rate_min=25332984 pre_start=308386439454 pre_end=308411772982
[    1.478228] lockdep: fixing up alternatives.
[    1.479293]  Ok.
[    1.479382] Booting Node   1, Processors  #8
[    1.479478] smpboot cpu 8: start_ip = 9a000
[    1.517957] calibrate_delay_direct() timer_rate_max=25334124 timer_rate_min=25333124 pre_start=308538440483 pre_end=308563774151
[    1.547939] calibrate_delay_direct() timer_rate_max=25334092 timer_rate_min=25333180 pre_start=308614441055 pre_end=308639774687
[    1.577923] calibrate_delay_direct() timer_rate_max=25334336 timer_rate_min=25333792 pre_start=308690441647 pre_end=308715775559
[    1.607908] calibrate_delay_direct() timer_rate_max=25333660 timer_rate_min=25333092 pre_start=308766442247 pre_end=308791775787
[    1.637893] calibrate_delay_direct() timer_rate_max=25333916 timer_rate_min=25332984 pre_start=308842442987 pre_end=308867776451
[    1.658171] lockdep: fixing up alternatives.
[    1.659249]  Ok.
[    1.659338] Booting Node   0, Processors  #9
[    1.659434] smpboot cpu 9: start_ip = 9a000
[    1.697864] calibrate_delay_direct() timer_rate_max=25334028 timer_rate_min=25332904 pre_start=308994444082 pre_end=309019777558
[    1.727846] calibrate_delay_direct() timer_rate_max=25334584 timer_rate_min=25333484 pre_start=309070444650 pre_end=309095778678
[    1.757831] calibrate_delay_direct() timer_rate_max=25334084 timer_rate_min=25332980 pre_start=309146445630 pre_end=309171779154
[    1.787815] calibrate_delay_direct() timer_rate_max=25334092 timer_rate_min=25332996 pre_start=309222446182 pre_end=309247779722
[    1.817800] calibrate_delay_direct() timer_rate_max=25334056 timer_rate_min=25332948 pre_start=309298446798 pre_end=309323780298
[    1.837985] lockdep: fixing up alternatives.
[    1.838483]  Ok.
[    1.838535] Booting Node   1, Processors  #10
[    1.838612] smpboot cpu 10: start_ip = 9a000
[    1.877772] calibrate_delay_direct() timer_rate_max=25334080 timer_rate_min=25333132 pre_start=309450447622 pre_end=309475781222
[    1.907754] calibrate_delay_direct() timer_rate_max=25334324 timer_rate_min=25333384 pre_start=309526448190 pre_end=309551782038
[    1.937738] calibrate_delay_direct() timer_rate_max=25334040 timer_rate_min=25333076 pre_start=309602449090 pre_end=309627782654
[    1.967723] calibrate_delay_direct() timer_rate_max=25334000 timer_rate_min=25333052 pre_start=309678449698 pre_end=309703783218
[    1.997708] calibrate_delay_direct() timer_rate_max=25333988 timer_rate_min=25333068 pre_start=309754450386 pre_end=309779783910
[    2.017992] lockdep: fixing up alternatives.
[    2.019072]  Ok.
[    2.019161] Booting Node   0, Processors  #11
[    2.019257] smpboot cpu 11: start_ip = 9a000
[    2.057679] calibrate_delay_direct() timer_rate_max=25333600 timer_rate_min=25332920 pre_start=309906451368 pre_end=309931784864
[    2.087662] calibrate_delay_direct() timer_rate_max=25334292 timer_rate_min=25333180 pre_start=309982452120 pre_end=310007785860
[    2.117646] calibrate_delay_direct() timer_rate_max=25333748 timer_rate_min=25333080 pre_start=310058452896 pre_end=310083786544
[    2.147631] calibrate_delay_direct() timer_rate_max=25334104 timer_rate_min=25332992 pre_start=310134453488 pre_end=310159787040
[    2.177615] calibrate_delay_direct() timer_rate_max=25333500 timer_rate_min=25332844 pre_start=310210454224 pre_end=310235787624
[    2.197857] lockdep: fixing up alternatives.
[    2.198924]  Ok.
[    2.199013] Booting Node   1, Processors  #12
[    2.199109] smpboot cpu 12: start_ip = 9a000
[    2.237587] calibrate_delay_direct() timer_rate_max=25333932 timer_rate_min=25332988 pre_start=310362454909 pre_end=310387788377
[    2.267569] calibrate_delay_direct() timer_rate_max=25334280 timer_rate_min=25333340 pre_start=310438455505 pre_end=310463789321
[    2.297554] calibrate_delay_direct() timer_rate_max=25334044 timer_rate_min=25333132 pre_start=310514456097 pre_end=310539789681
[    2.327538] calibrate_delay_direct() timer_rate_max=25333988 timer_rate_min=25333056 pre_start=310590457025 pre_end=310615790549
[    2.357523] calibrate_delay_direct() timer_rate_max=25333996 timer_rate_min=25333032 pre_start=310666457649 pre_end=310691791161
[    2.377751] lockdep: fixing up alternatives.
[    2.378829]  Ok.
[    2.378918] Booting Node   0, Processors  #13
[    2.379014] smpboot cpu 13: start_ip = 9a000
[    2.417495] calibrate_delay_direct() timer_rate_max=25334092 timer_rate_min=25332976 pre_start=310818458655 pre_end=310843792195
[    2.447477] calibrate_delay_direct() timer_rate_max=25333668 timer_rate_min=25333000 pre_start=310894459463 pre_end=310919793035
[    2.477462] calibrate_delay_direct() timer_rate_max=25333620 timer_rate_min=25332976 pre_start=310970460199 pre_end=310995793723
[    2.507446] calibrate_delay_direct() timer_rate_max=25333848 timer_rate_min=25332756 pre_start=311046460775 pre_end=311071794079
[    2.537431] calibrate_delay_direct() timer_rate_max=25333624 timer_rate_min=25332964 pre_start=311122461387 pre_end=311147794911
[    2.557629] lockdep: fixing up alternatives.
[    2.558693]  Ok.
[    2.558782] Booting Node   1, Processors  #14
[    2.558879] smpboot cpu 14: start_ip = 9a000
[    2.597402] calibrate_delay_direct() timer_rate_max=25333976 timer_rate_min=25333004 pre_start=311274462534 pre_end=311299796030
[    2.627385] calibrate_delay_direct() timer_rate_max=25333980 timer_rate_min=25333052 pre_start=311350462778 pre_end=311375796294
[    2.657369] calibrate_delay_direct() timer_rate_max=25334224 timer_rate_min=25333308 pre_start=311426463486 pre_end=311451797242
[    2.687354] calibrate_delay_direct() timer_rate_max=25334180 timer_rate_min=25333260 pre_start=311502464294 pre_end=311527798014
[    2.717338] calibrate_delay_direct() timer_rate_max=25333924 timer_rate_min=25332992 pre_start=311578464618 pre_end=311603798074
[    2.737627] lockdep: fixing up alternatives.
[    2.738295]  Ok.
[    2.738384] Booting Node   0, Processors  #15 Ok.
[    2.738526] smpboot cpu 15: start_ip = 9a000
[    2.777310] calibrate_delay_direct() timer_rate_max=25334076 timer_rate_min=25333424 pre_start=311730466050 pre_end=311755799578
[    2.807293] calibrate_delay_direct() timer_rate_max=25334296 timer_rate_min=25333036 pre_start=311806466618 pre_end=311831800214
[    2.837277] calibrate_delay_direct() timer_rate_max=25334332 timer_rate_min=25333220 pre_start=311882467138 pre_end=311907800922
[    2.867261] calibrate_delay_direct() timer_rate_max=25334052 timer_rate_min=25332932 pre_start=311958468098 pre_end=311983801586
[    2.897246] calibrate_delay_direct() timer_rate_max=25333736 timer_rate_min=25333088 pre_start=312034468670 pre_end=312059802310
[    2.917336] Brought up 16 CPUs
[    2.922226] Total of 16 processors activated (81069.27 BogoMIPS).
[    2.930535] devtmpfs: initialized
[    2.931137] kworker/u:0 used greatest stack depth: 4968 bytes left
[    2.931903] NET: Registered protocol family 16
[    2.932989] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    2.933166] ACPI: bus type pci registered
[    2.933597] PCI: Using configuration type 1 for base access
[    2.942513] bio: create slab <bio-0> at 0
[    2.944935] ACPI: EC: Look up EC in DSDT
[    2.945260] \_SB_:_OSC evaluation returned wrong type
[    2.945319] _OSC request data:1 6 
[    2.951278] ACPI: Interpreter enabled
[    2.951380] ACPI: (supports S0 S5)
[    2.951574] ACPI: Using IOAPIC for interrupt routing
[    2.961987] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    2.962128] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-12])
[    2.962428] pci_root PNP0A03:00: host bridge window [mem 0xe7000000-0xfbffffff]
[    2.962507] pci_root PNP0A03:00: host bridge window [io  0x1000-0x4fff]
[    2.962569] pci_root PNP0A03:00: host bridge window [io  0x0000-0x03af]
[    2.962631] pci_root PNP0A03:00: host bridge window [io  0x03e0-0x0cf7]
[    2.962693] pci_root PNP0A03:00: host bridge window [io  0x0d00-0x0fff]
[    2.962755] pci_root PNP0A03:00: host bridge window [mem 0xfed00000-0xfed03fff]
[    2.962920] pci_root PNP0A03:00: host bridge window [mem 0xfed00000-0xfed44fff]
[    2.963085] pci_root PNP0A03:00: host bridge window [io  0x03b0-0x03bb]
[    2.963203] pci_root PNP0A03:00: host bridge window [io  0x03c0-0x03df]
[    2.963321] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    2.963487] pci_root PNP0A03:00: host bridge window expanded to [mem 0xfed00000-0xfed44fff]; [mem 0xfed00000-0xfed44fff] ignored
[    2.963720] pci 0000:00:00.0: [8086:3403] type 0 class 0x000600
[    2.963915] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    2.964033] pci 0000:00:00.0: PME# disabled
[    2.964158] pci 0000:00:01.0: [8086:3408] type 1 class 0x000604
[    2.964329] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    2.964445] pci 0000:00:01.0: PME# disabled
[    2.964572] pci 0000:00:02.0: [8086:3409] type 1 class 0x000604
[    2.964742] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    2.964858] pci 0000:00:02.0: PME# disabled
[    2.964984] pci 0000:00:03.0: [8086:340a] type 1 class 0x000604
[    2.965154] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    2.965270] pci 0000:00:03.0: PME# disabled
[    2.965399] pci 0000:00:07.0: [8086:340e] type 1 class 0x000604
[    2.965569] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    2.965685] pci 0000:00:07.0: PME# disabled
[    2.965811] pci 0000:00:08.0: [8086:340f] type 1 class 0x000604
[    2.965981] pci 0000:00:08.0: PME# supported from D0 D3hot D3cold
[    2.966097] pci 0000:00:08.0: PME# disabled
[    2.966224] pci 0000:00:09.0: [8086:3410] type 1 class 0x000604
[    2.966393] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    2.966510] pci 0000:00:09.0: PME# disabled
[    2.966647] pci 0000:00:0a.0: [8086:3411] type 1 class 0x000604
[    2.966817] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    2.966934] pci 0000:00:0a.0: PME# disabled
[    2.967059] pci 0000:00:0d.0: [8086:343a] type 0 class 0x000600
[    2.967247] pci 0000:00:0d.1: [8086:343b] type 0 class 0x000600
[    2.967427] pci 0000:00:0d.2: [8086:343c] type 0 class 0x000600
[    2.967603] pci 0000:00:0d.3: [8086:343d] type 0 class 0x000600
[    2.967779] pci 0000:00:0d.4: [8086:3418] type 0 class 0x000600
[    2.967954] pci 0000:00:0d.5: [8086:3419] type 0 class 0x000600
[    2.968130] pci 0000:00:0d.6: [8086:341a] type 0 class 0x000600
[    2.968306] pci 0000:00:0e.0: [8086:341c] type 0 class 0x000600
[    2.968482] pci 0000:00:0e.1: [8086:341d] type 0 class 0x000600
[    2.968658] pci 0000:00:0e.2: [8086:341e] type 0 class 0x000600
[    2.968834] pci 0000:00:0e.3: [8086:341f] type 0 class 0x000600
[    2.969009] pci 0000:00:0e.4: [8086:3439] type 0 class 0x000600
[    2.969189] pci 0000:00:14.0: [8086:342e] type 0 class 0x000800
[    2.969378] pci 0000:00:14.1: [8086:3422] type 0 class 0x000800
[    2.969569] pci 0000:00:14.2: [8086:3423] type 0 class 0x000800
[    2.969780] pci 0000:00:1c.0: [8086:3a40] type 1 class 0x000604
[    2.969961] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    2.970078] pci 0000:00:1c.0: PME# disabled
[    2.970216] pci 0000:00:1d.0: [8086:3a34] type 0 class 0x000c03
[    2.970395] pci 0000:00:1d.0: reg 20: [io  0x1000-0x101f]
[    2.970569] pci 0000:00:1d.1: [8086:3a35] type 0 class 0x000c03
[    2.970747] pci 0000:00:1d.1: reg 20: [io  0x1020-0x103f]
[    2.970922] pci 0000:00:1d.2: [8086:3a36] type 0 class 0x000c03
[    2.971099] pci 0000:00:1d.2: reg 20: [io  0x1040-0x105f]
[    2.971274] pci 0000:00:1d.3: [8086:3a39] type 0 class 0x000c03
[    2.971451] pci 0000:00:1d.3: reg 20: [io  0x1060-0x107f]
[    2.971635] pci 0000:00:1d.7: [8086:3a3a] type 0 class 0x000c03
[    2.971772] pci 0000:00:1d.7: reg 10: [mem 0xf35f0000-0xf35f03ff]
[    2.971977] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    2.972095] pci 0000:00:1d.7: PME# disabled
[    2.972220] pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
[    2.972403] pci 0000:00:1f.0: [8086:3a18] type 0 class 0x000601
[    2.972702] pci 0000:02:00.0: [14e4:1650] type 0 class 0x000200
[    2.972832] pci 0000:02:00.0: reg 10: [mem 0xfb000000-0xfb7fffff 64bit]
[    2.972964] pci 0000:02:00.0: reg 18: [mem 0xfa800000-0xfaffffff 64bit]
[    2.973106] pci 0000:02:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    2.973258] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    2.973375] pci 0000:02:00.0: PME# disabled
[    2.973504] pci 0000:02:00.1: [14e4:1650] type 0 class 0x000200
[    2.973634] pci 0000:02:00.1: reg 10: [mem 0xfa000000-0xfa7fffff 64bit]
[    2.973766] pci 0000:02:00.1: reg 18: [mem 0xf9800000-0xf9ffffff 64bit]
[    2.973908] pci 0000:02:00.1: reg 30: [mem 0x00000000-0x0000ffff pref]
[    2.974061] pci 0000:02:00.1: PME# supported from D0 D3hot D3cold
[    2.974178] pci 0000:02:00.1: PME# disabled
[    2.974296] pci 0000:00:01.0: PCI bridge to [bus 02-02]
[    2.974408] pci 0000:00:01.0:   bridge window [io  0xf000-0x0000] (disabled)
[    2.974531] pci 0000:00:01.0:   bridge window [mem 0xf3800000-0xfb7fffff]
[    2.974655] pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    2.974870] pci 0000:00:02.0: PCI bridge to [bus 0d-0d]
[    2.974981] pci 0000:00:02.0:   bridge window [io  0xf000-0x0000] (disabled)
[    2.975104] pci 0000:00:02.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    2.975275] pci 0000:00:02.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    2.975492] pci 0000:00:03.0: PCI bridge to [bus 03-05]
[    2.975603] pci 0000:00:03.0:   bridge window [io  0xf000-0x0000] (disabled)
[    2.975726] pci 0000:00:03.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    2.975897] pci 0000:00:03.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    2.976111] pci 0000:00:07.0: PCI bridge to [bus 06-08]
[    2.976223] pci 0000:00:07.0:   bridge window [io  0xf000-0x0000] (disabled)
[    2.976346] pci 0000:00:07.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    2.976516] pci 0000:00:07.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    2.976733] pci 0000:00:08.0: PCI bridge to [bus 11-11]
[    2.976844] pci 0000:00:08.0:   bridge window [io  0xf000-0x0000] (disabled)
[    2.976967] pci 0000:00:08.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    2.977138] pci 0000:00:08.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    2.977372] pci 0000:09:00.0: [1166:0103] type 1 class 0x000604
[    2.977544] pci 0000:09:00.0: PME# supported from D0 D3hot D3cold
[    2.977661] pci 0000:09:00.0: PME# disabled
[    2.977775] pci 0000:00:09.0: PCI bridge to [bus 09-0b]
[    2.977887] pci 0000:00:09.0:   bridge window [io  0xf000-0x0000] (disabled)
[    2.978009] pci 0000:00:09.0:   bridge window [mem 0xfba00000-0xfbafffff]
[    2.978133] pci 0000:00:09.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    2.978359] pci 0000:0a:04.0: [14e4:1679] type 0 class 0x000200
[    2.982361] pci 0000:0a:04.0: reg 10: [mem 0xfbaf0000-0xfbafffff 64bit]
[    2.982494] pci 0000:0a:04.0: reg 18: [mem 0xfbae0000-0xfbaeffff 64bit]
[    2.982638] pci 0000:0a:04.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    2.982784] pci 0000:0a:04.0: PME# supported from D3hot D3cold
[    2.982930] pci 0000:0a:04.0: PME# disabled
[    2.983061] pci 0000:0a:04.1: [14e4:1679] type 0 class 0x000200
[    2.983197] pci 0000:0a:04.1: reg 10: [mem 0xfbad0000-0xfbadffff 64bit]
[    2.983329] pci 0000:0a:04.1: reg 18: [mem 0xfbac0000-0xfbacffff 64bit]
[    2.983473] pci 0000:0a:04.1: reg 30: [mem 0x00000000-0x0001ffff pref]
[    2.983619] pci 0000:0a:04.1: PME# supported from D3hot D3cold
[    2.983736] pci 0000:0a:04.1: PME# disabled
[    2.983894] pci 0000:09:00.0: PCI bridge to [bus 0a-0a]
[    2.984008] pci 0000:09:00.0:   bridge window [io  0xfffffffffffff000-0x0000] (disabled)
[    2.984179] pci 0000:09:00.0:   bridge window [mem 0xfba00000-0xfbafffff]
[    2.984303] pci 0000:09:00.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    2.984525] pci 0000:00:0a.0: PCI bridge to [bus 12-12]
[    2.984636] pci 0000:00:0a.0:   bridge window [io  0xf000-0x0000] (disabled)
[    2.984759] pci 0000:00:0a.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    2.984930] pci 0000:00:0a.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    2.985166] pci 0000:0c:00.0: [103c:323a] type 0 class 0x000104
[    2.985303] pci 0000:0c:00.0: reg 10: [mem 0xfbc00000-0xfbffffff 64bit]
[    2.985441] pci 0000:0c:00.0: reg 18: [mem 0xfbbf0000-0xfbbf0fff 64bit]
[    2.985571] pci 0000:0c:00.0: reg 20: [io  0x4000-0x40ff]
[    2.985705] pci 0000:0c:00.0: reg 30: [mem 0x00000000-0x0007ffff pref]
[    2.985864] pci 0000:0c:00.0: supports D1
[    2.985967] pci 0000:0c:00.0: PME# supported from D0
[    2.986079] pci 0000:0c:00.0: PME# disabled
[    2.986200] pci 0000:00:1c.0: PCI bridge to [bus 0c-0c]
[    2.986312] pci 0000:00:1c.0:   bridge window [io  0x4000-0x4fff]
[    2.986429] pci 0000:00:1c.0:   bridge window [mem 0xfbb00000-0xfbffffff]
[    2.986553] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    2.986766] pci 0000:01:03.0: [1002:515e] type 0 class 0x000300
[    2.986900] pci 0000:01:03.0: reg 10: [mem 0xe8000000-0xefffffff pref]
[    2.987028] pci 0000:01:03.0: reg 14: [io  0x3000-0x30ff]
[    2.987148] pci 0000:01:03.0: reg 18: [mem 0xf37f0000-0xf37fffff]
[    2.987310] pci 0000:01:03.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    2.987450] pci 0000:01:03.0: supports D1 D2
[    2.987573] pci 0000:01:04.0: [0e11:b203] type 0 class 0x000880
[    2.987706] pci 0000:01:04.0: reg 10: [io  0x2800-0x28ff]
[    2.987827] pci 0000:01:04.0: reg 14: [mem 0xf37e0000-0xf37e01ff]
[    2.988015] pci 0000:01:04.0: PME# supported from D0 D3hot D3cold
[    2.988133] pci 0000:01:04.0: PME# disabled
[    2.988261] pci 0000:01:04.2: [0e11:b204] type 0 class 0x000880
[    2.988396] pci 0000:01:04.2: reg 10: [io  0x3400-0x34ff]
[    2.988517] pci 0000:01:04.2: reg 14: [mem 0xf37d0000-0xf37d07ff]
[    2.988644] pci 0000:01:04.2: reg 18: [mem 0xf37c0000-0xf37c3fff]
[    2.988771] pci 0000:01:04.2: reg 1c: [mem 0xf3700000-0xf377ffff]
[    2.988921] pci 0000:01:04.2: reg 30: [mem 0x00000000-0x0000ffff pref]
[    2.989063] pci 0000:01:04.2: PME# supported from D0 D3hot D3cold
[    2.989182] pci 0000:01:04.2: PME# disabled
[    2.989308] pci 0000:01:04.4: [103c:3300] type 0 class 0x000c03
[    2.989488] pci 0000:01:04.4: reg 20: [io  0x3800-0x381f]
[    2.989644] pci 0000:01:04.4: PME# supported from D0 D3hot D3cold
[    2.989762] pci 0000:01:04.4: PME# disabled
[    2.989887] pci 0000:01:04.6: [103c:3302] type 0 class 0x000c07
[    2.990020] pci 0000:01:04.6: reg 10: [mem 0xf36f0000-0xf36f00ff]
[    2.990217] pci 0000:01:04.6: PME# supported from D0 D3hot D3cold
[    2.990335] pci 0000:01:04.6: PME# disabled
[    2.990494] pci 0000:00:1e.0: PCI bridge to [bus 01-01] (subtractive decode)
[    2.990617] pci 0000:00:1e.0:   bridge window [io  0x2000-0x3fff]
[    2.990734] pci 0000:00:1e.0:   bridge window [mem 0xf3600000-0xf37fffff]
[    2.990858] pci 0000:00:1e.0:   bridge window [mem 0xe8000000-0xefffffff 64bit pref]
[    2.991025] pci 0000:00:1e.0:   bridge window [mem 0xe7000000-0xfbffffff] (subtractive decode)
[    2.991198] pci 0000:00:1e.0:   bridge window [io  0x1000-0x4fff] (subtractive decode)
[    2.991366] pci 0000:00:1e.0:   bridge window [io  0x0000-0x03af] (subtractive decode)
[    2.991534] pci 0000:00:1e.0:   bridge window [io  0x03e0-0x0cf7] (subtractive decode)
[    2.991703] pci 0000:00:1e.0:   bridge window [io  0x0d00-0x0fff] (subtractive decode)
[    2.991871] pci 0000:00:1e.0:   bridge window [mem 0xfed00000-0xfed44fff] (subtractive decode)
[    2.992044] pci 0000:00:1e.0:   bridge window [io  0x03b0-0x03bb] (subtractive decode)
[    2.992212] pci 0000:00:1e.0:   bridge window [io  0x03c0-0x03df] (subtractive decode)
[    2.992381] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    2.992595] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    2.992985] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IP2P._PRT]
[    2.993171] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IPT1._PRT]
[    2.993350] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT01._PRT]
[    2.993529] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT03._PRT]
[    2.993781] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT07._PRT]
[    2.994031] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PT09._PRT]
[    2.994286]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x18)
[    3.003618] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *7 10 11)
[    3.003999] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7 *10 11)
[    3.004378] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 7 *10 11)
[    3.004758] ACPI: PCI Interrupt Link [LNKD] (IRQs *5 7 10 11)
[    3.005135] ACPI: PCI Interrupt Link [LNKE] (IRQs *5 7 10 11)
[    3.005513] ACPI: PCI Interrupt Link [LNKF] (IRQs 5 7 *10 11)
[    3.005889] ACPI: PCI Interrupt Link [LNKG] (IRQs 5 7 *10 11)
[    3.006265] ACPI: PCI Interrupt Link [LNKH] (IRQs 5 *7 10 11)
[    3.007154] vgaarb: device added: PCI:0000:01:03.0,decodes=io+mem,owns=io+mem,locks=none
[    3.007340] vgaarb: loaded
[    3.007435] vgaarb: bridge control possible 0000:01:03.0
[    3.008241] SCSI subsystem initialized
[    3.008576] libata version 3.00 loaded.
[    3.008833] usbcore: registered new interface driver usbfs
[    3.009073] usbcore: registered new interface driver hub
[    3.009281] usbcore: registered new device driver usb
[    3.009653] PCI: Using ACPI for IRQ routing
[    3.009757] PCI: pci_cache_line_size set to 64 bytes
[    3.010062] reserve RAM buffer: 000000000009f400 - 000000000009ffff 
[    3.010136] reserve RAM buffer: 00000000df62f000 - 00000000dfffffff 
[    3.010287] reserve RAM buffer: 00000000df63d000 - 00000000dfffffff 
[    3.010439] reserve RAM buffer: 000000011ffff000 - 000000011fffffff 
[    3.011160] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    3.127331] Switching to clocksource hpet
[    3.132342] pnp: PnP ACPI init
[    3.132465] ACPI: bus type pnp registered
[    3.132606] pnp 00:00: [bus 00-12]
[    3.132706] pnp 00:00: [mem 0xe7000000-0xfbffffff window]
[    3.132816] pnp 00:00: [io  0x1000-0x4fff window]
[    3.132923] pnp 00:00: [io  0x0000-0x03af window]
[    3.133029] pnp 00:00: [io  0x03e0-0x0cf7 window]
[    3.133136] pnp 00:00: [io  0x0d00-0x0fff window]
[    3.133242] pnp 00:00: [mem 0xfed00000-0xfed03fff window]
[    3.133353] pnp 00:00: [mem 0xfed00000-0xfed44fff window]
[    3.133463] pnp 00:00: [io  0x03b0-0x03bb window]
[    3.133570] pnp 00:00: [io  0x03c0-0x03df window]
[    3.133675] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    3.133959] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 PNP0a08 (active)
[    3.134355] pnp 00:01: [io  0x0070-0x0077]
[    3.134459] pnp 00:01: [io  0x0408-0x040f]
[    3.134563] pnp 00:01: [io  0x04d0-0x04d1]
[    3.134666] pnp 00:01: [io  0x0020-0x003f]
[    3.134740] pnp 00:01: [io  0x00a0-0x00bf]
[    3.134804] pnp 00:01: [io  0x0090-0x009f]
[    3.134861] pnp 00:01: [io  0x0050-0x0053]
[    3.134918] pnp 00:01: [io  0x0700-0x071f]
[    3.134975] pnp 00:01: [io  0x0880-0x08ff]
[    3.135031] pnp 00:01: [io  0x0900-0x097f]
[    3.137161] Switched to NOHz mode on CPU #0
[    3.137213] Switched to NOHz mode on CPU #6
[    3.137217] Switched to NOHz mode on CPU #13
[    3.137233] Switched to NOHz mode on CPU #12
[    3.137236] Switched to NOHz mode on CPU #9
[    3.137239] Switched to NOHz mode on CPU #4
[    3.137247] Switched to NOHz mode on CPU #2
[    3.137262] Switched to NOHz mode on CPU #8
[    3.137272] Switched to NOHz mode on CPU #15
[    3.137276] Switched to NOHz mode on CPU #5
[    3.137293] Switched to NOHz mode on CPU #10
[    3.137295] Switched to NOHz mode on CPU #14
[    3.137303] Switched to NOHz mode on CPU #11
[    3.137319] Switched to NOHz mode on CPU #1
[    3.137336] Switched to NOHz mode on CPU #3
[    3.140581] Switched to NOHz mode on CPU #7
[    3.140688] pnp 00:01: [io  0x0010-0x001f]
[    3.140791] pnp 00:01: [io  0x0c80-0x0c83]
[    3.140893] pnp 00:01: [io  0x0cd4-0x0cd7]
[    3.140996] pnp 00:01: [io  0x0f50-0x0f58]
[    3.141099] pnp 00:01: [io  0x00f0]
[    3.141198] pnp 00:01: [io  0x0ca0-0x0ca1]
[    3.141301] pnp 00:01: [io  0x0ca4-0x0ca5]
[    3.141405] pnp 00:01: [mem 0xe0000000-0xe3ffffff]
[    3.141512] pnp 00:01: [mem 0xfe000000-0xfebfffff]
[    3.141619] pnp 00:01: [mem 0xe7ffe000-0xe7ffffff]
[    3.141727] pnp 00:01: [mem 0x00000000-0xffffffffffffffff disabled]
[    3.141842] pnp 00:01: [io  0x03f8-0x03ff]
[    3.142192] system 00:01: [io  0x0408-0x040f] has been reserved
[    3.142307] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    3.142422] system 00:01: [io  0x0700-0x071f] has been reserved
[    3.142537] system 00:01: [io  0x0880-0x08ff] has been reserved
[    3.142651] system 00:01: [io  0x0900-0x097f] has been reserved
[    3.142766] system 00:01: [io  0x0c80-0x0c83] has been reserved
[    3.142881] system 00:01: [io  0x0cd4-0x0cd7] has been reserved
[    3.142995] system 00:01: [io  0x0f50-0x0f58] has been reserved
[    3.143110] system 00:01: [io  0x0ca0-0x0ca1] has been reserved
[    3.143225] system 00:01: [io  0x0ca4-0x0ca5] has been reserved
[    3.143340] system 00:01: [io  0x03f8-0x03ff] has been reserved
[    3.143455] system 00:01: [mem 0xe0000000-0xe3ffffff] has been reserved
[    3.143575] system 00:01: [mem 0xfe000000-0xfebfffff] has been reserved
[    3.143693] system 00:01: [mem 0xe7ffe000-0xe7ffffff] has been reserved
[    3.143815] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    3.143947] pnp 00:02: [io  0x0ca2-0x0ca3]
[    3.144176] pnp 00:02: Plug and Play ACPI device, IDs IPI0001 (active)
[    3.144326] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    3.144558] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    3.144687] pnp 00:04: [dma 7]
[    3.144785] pnp 00:04: [io  0x0000-0x000f]
[    3.144887] pnp 00:04: [io  0x0080-0x008f]
[    3.144989] pnp 00:04: [io  0x00c0-0x00df]
[    3.145219] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    3.145347] pnp 00:05: [io  0x0061]
[    3.145574] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    3.145702] pnp 00:06: [io  0x0060]
[    3.145804] pnp 00:06: [io  0x0064]
[    3.145913] pnp 00:06: [irq 1]
[    3.146138] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 (active)
[    3.146271] pnp 00:07: [irq 12]
[    3.146495] pnp 00:07: Plug and Play ACPI device, IDs PNP0f13 PNP0f0e (active)
[    3.146671] pnp 00:08: [io  0x002e-0x002f]
[    3.146775] pnp 00:08: [io  0x0620-0x065f]
[    3.146878] pnp 00:08: [io  0x0680-0x069f]
[    3.146980] pnp 00:08: [io  0x0600-0x061f]
[    3.147084] pnp 00:08: [io  0x0660-0x067f]
[    3.147186] pnp 00:08: [io  0x0300-0x031f]
[    3.147422] pnp 00:08: Plug and Play ACPI device, IDs PNP0a06 (active)
[    3.147686] pnp 00:09: [irq 3]
[    3.147784] pnp 00:09: [io  0x02f8-0x02ff]
[    3.148102] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 PNP0500 (active)
[    3.148318] pnp 00:0a: [io  0x0070-0x0071]
[    3.148552] pnp 00:0a: Plug and Play ACPI device, IDs PNP0b00 (active)
[    3.148867] pnp: PnP ACPI: found 11 devices
[    3.148971] ACPI: ACPI bus type pnp unregistered
[    3.160664] PCI: max bus depth: 2 pci_try_num: 3
[    3.160846] pci 0000:00:01.0: BAR 9: assigned [mem 0xe7000000-0xe70fffff pref]
[    3.161012] pci 0000:00:09.0: BAR 9: assigned [mem 0xe7100000-0xe71fffff pref]
[    3.161177] pci 0000:00:1c.0: BAR 9: assigned [mem 0xe7200000-0xe72fffff pref]
[    3.161342] pci 0000:02:00.0: BAR 6: assigned [mem 0xe7000000-0xe700ffff pref]
[    3.161507] pci 0000:02:00.1: BAR 6: assigned [mem 0xe7010000-0xe701ffff pref]
[    3.161671] pci 0000:00:01.0: PCI bridge to [bus 02-02]
[    3.161780] pci 0000:00:01.0:   bridge window [io  disabled]
[    3.161896] pci 0000:00:01.0:   bridge window [mem 0xf3800000-0xfb7fffff]
[    3.162017] pci 0000:00:01.0:   bridge window [mem 0xe7000000-0xe70fffff pref]
[    3.162186] pci 0000:00:02.0: PCI bridge to [bus 0d-0d]
[    3.162295] pci 0000:00:02.0:   bridge window [io  disabled]
[    3.162410] pci 0000:00:02.0:   bridge window [mem disabled]
[    3.162524] pci 0000:00:02.0:   bridge window [mem pref disabled]
[    3.162643] pci 0000:00:03.0: PCI bridge to [bus 03-05]
[    3.162752] pci 0000:00:03.0:   bridge window [io  disabled]
[    3.162866] pci 0000:00:03.0:   bridge window [mem disabled]
[    3.162980] pci 0000:00:03.0:   bridge window [mem pref disabled]
[    3.163099] pci 0000:00:07.0: PCI bridge to [bus 06-08]
[    3.163208] pci 0000:00:07.0:   bridge window [io  disabled]
[    3.163323] pci 0000:00:07.0:   bridge window [mem disabled]
[    3.163436] pci 0000:00:07.0:   bridge window [mem pref disabled]
[    3.163555] pci 0000:00:08.0: PCI bridge to [bus 11-11]
[    3.163664] pci 0000:00:08.0:   bridge window [io  disabled]
[    3.163779] pci 0000:00:08.0:   bridge window [mem disabled]
[    3.163893] pci 0000:00:08.0:   bridge window [mem pref disabled]
[    3.164013] pci 0000:09:00.0: BAR 9: assigned [mem 0xe7100000-0xe71fffff pref]
[    3.164179] pci 0000:0a:04.0: BAR 6: assigned [mem 0xe7100000-0xe711ffff pref]
[    3.164344] pci 0000:0a:04.1: BAR 6: assigned [mem 0xe7120000-0xe713ffff pref]
[    3.164509] pci 0000:09:00.0: PCI bridge to [bus 0a-0a]
[    3.164618] pci 0000:09:00.0:   bridge window [io  disabled]
[    3.164734] pci 0000:09:00.0:   bridge window [mem 0xfba00000-0xfbafffff]
[    3.164855] pci 0000:09:00.0:   bridge window [mem 0xe7100000-0xe71fffff pref]
[    3.165024] pci 0000:00:09.0: PCI bridge to [bus 09-0b]
[    3.165134] pci 0000:00:09.0:   bridge window [io  disabled]
[    3.165248] pci 0000:00:09.0:   bridge window [mem 0xfba00000-0xfbafffff]
[    3.165370] pci 0000:00:09.0:   bridge window [mem 0xe7100000-0xe71fffff pref]
[    3.165538] pci 0000:00:0a.0: PCI bridge to [bus 12-12]
[    3.165647] pci 0000:00:0a.0:   bridge window [io  disabled]
[    3.165763] pci 0000:00:0a.0:   bridge window [mem disabled]
[    3.165877] pci 0000:00:0a.0:   bridge window [mem pref disabled]
[    3.165997] pci 0000:0c:00.0: BAR 6: assigned [mem 0xe7200000-0xe727ffff pref]
[    3.166161] pci 0000:00:1c.0: PCI bridge to [bus 0c-0c]
[    3.166272] pci 0000:00:1c.0:   bridge window [io  0x4000-0x4fff]
[    3.166390] pci 0000:00:1c.0:   bridge window [mem 0xfbb00000-0xfbffffff]
[    3.166511] pci 0000:00:1c.0:   bridge window [mem 0xe7200000-0xe72fffff pref]
[    3.166682] pci 0000:01:03.0: BAR 6: assigned [mem 0xf3600000-0xf361ffff pref]
[    3.166848] pci 0000:01:04.2: BAR 6: assigned [mem 0xf3620000-0xf362ffff pref]
[    3.167012] pci 0000:00:1e.0: PCI bridge to [bus 01-01]
[    3.167123] pci 0000:00:1e.0:   bridge window [io  0x2000-0x3fff]
[    3.167240] pci 0000:00:1e.0:   bridge window [mem 0xf3600000-0xf37fffff]
[    3.167361] pci 0000:00:1e.0:   bridge window [mem 0xe8000000-0xefffffff 64bit pref]
[    3.167548] pci 0000:00:01.0: setting latency timer to 64
[    3.171541] pci 0000:00:02.0: setting latency timer to 64
[    3.171658] pci 0000:00:03.0: setting latency timer to 64
[    3.171774] pci 0000:00:07.0: setting latency timer to 64
[    3.171890] pci 0000:00:08.0: setting latency timer to 64
[    3.172006] pci 0000:00:09.0: setting latency timer to 64
[    3.172123] pci 0000:09:00.0: setting latency timer to 64
[    3.172238] pci 0000:00:0a.0: setting latency timer to 64
[    3.172360] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.172482] pci 0000:00:1c.0: setting latency timer to 64
[    3.172597] pci 0000:00:1e.0: setting latency timer to 64
[    3.172709] pci_bus 0000:00: resource 4 [mem 0xe7000000-0xfbffffff]
[    3.172825] pci_bus 0000:00: resource 5 [io  0x1000-0x4fff]
[    3.172936] pci_bus 0000:00: resource 6 [io  0x0000-0x03af]
[    3.173048] pci_bus 0000:00: resource 7 [io  0x03e0-0x0cf7]
[    3.173159] pci_bus 0000:00: resource 8 [io  0x0d00-0x0fff]
[    3.173271] pci_bus 0000:00: resource 9 [mem 0xfed00000-0xfed44fff]
[    3.173387] pci_bus 0000:00: resource 10 [io  0x03b0-0x03bb]
[    3.173500] pci_bus 0000:00: resource 11 [io  0x03c0-0x03df]
[    3.173613] pci_bus 0000:00: resource 12 [mem 0x000a0000-0x000bffff]
[    3.173730] pci_bus 0000:02: resource 1 [mem 0xf3800000-0xfb7fffff]
[    3.173847] pci_bus 0000:02: resource 2 [mem 0xe7000000-0xe70fffff pref]
[    3.173967] pci_bus 0000:09: resource 1 [mem 0xfba00000-0xfbafffff]
[    3.174082] pci_bus 0000:09: resource 2 [mem 0xe7100000-0xe71fffff pref]
[    3.174201] pci_bus 0000:0a: resource 1 [mem 0xfba00000-0xfbafffff]
[    3.174316] pci_bus 0000:0a: resource 2 [mem 0xe7100000-0xe71fffff pref]
[    3.174435] pci_bus 0000:0c: resource 0 [io  0x4000-0x4fff]
[    3.174547] pci_bus 0000:0c: resource 1 [mem 0xfbb00000-0xfbffffff]
[    3.174663] pci_bus 0000:0c: resource 2 [mem 0xe7200000-0xe72fffff pref]
[    3.174782] pci_bus 0000:01: resource 0 [io  0x2000-0x3fff]
[    3.174894] pci_bus 0000:01: resource 1 [mem 0xf3600000-0xf37fffff]
[    3.175009] pci_bus 0000:01: resource 2 [mem 0xe8000000-0xefffffff 64bit pref]
[    3.175174] pci_bus 0000:01: resource 4 [mem 0xe7000000-0xfbffffff]
[    3.175290] pci_bus 0000:01: resource 5 [io  0x1000-0x4fff]
[    3.175402] pci_bus 0000:01: resource 6 [io  0x0000-0x03af]
[    3.175514] pci_bus 0000:01: resource 7 [io  0x03e0-0x0cf7]
[    3.175626] pci_bus 0000:01: resource 8 [io  0x0d00-0x0fff]
[    3.175737] pci_bus 0000:01: resource 9 [mem 0xfed00000-0xfed44fff]
[    3.175853] pci_bus 0000:01: resource 10 [io  0x03b0-0x03bb]
[    3.175965] pci_bus 0000:01: resource 11 [io  0x03c0-0x03df]
[    3.176078] pci_bus 0000:01: resource 12 [mem 0x000a0000-0x000bffff]
[    3.176313] NET: Registered protocol family 2
[    3.176586] IP route cache hash table entries: 4096 (order: 3, 32768 bytes)
[    3.176969] TCP established hash table entries: 4096 (order: 4, 65536 bytes)
[    3.177137] TCP bind hash table entries: 4096 (order: 6, 262144 bytes)
[    3.177521] TCP: Hash tables configured (established 4096 bind 4096)
[    3.177654] TCP reno registered
[    3.177777] UDP hash table entries: 2048 (order: 6, 327680 bytes)
[    3.178182] UDP-Lite hash table entries: 2048 (order: 6, 327680 bytes)
[    3.178925] NET: Registered protocol family 1
[    3.197545] pci 0000:01:03.0: Boot video device
[    3.198286] PCI: CLS 64 bytes, default 64
[    3.198492] Trying to unpack rootfs image as initramfs...
[    3.207191] Freeing initrd memory: 492k freed
[    3.207303] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    3.207364] Placing 64MB software IO TLB between ffff8800db629000 - ffff8800df629000
[    3.207442] software IO TLB at phys 0xdb629000 - 0xdf629000
[    3.208649] udev used greatest stack depth: 4480 bytes left
[    3.224666] audit: initializing netlink socket (disabled)
[    3.224784] type=2000 audit(1306396954.960:1): initialized
[    3.261951] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.278942] VFS: Disk quotas dquot_6.5.2
[    3.279247] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    3.281061] msgmni has been set to 7879
[    3.282353] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    3.282444] io scheduler noop registered
[    3.282501] io scheduler deadline registered
[    3.282826] io scheduler cfq registered (default)
[    3.283934] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.285103] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    3.285217] ACPI: Power Button [PWRF]
[    3.285524] ACPI: acpi_idle registered with cpuidle
[    3.285753] Monitor-Mwait will be used to enter C-1 state
[    3.291926] thermal LNXTHERM:00: registered as thermal_zone0
[    3.291988] ACPI: Thermal Zone [THM0] (8 C)
[    3.292422] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    3.367645] synchronize_rcu() in 89718 us
[    3.457419] synchronize_rcu() in 89753 us
[    3.527372] synchronize_rcu() in 69927 us
[    3.588823] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.677281] synchronize_rcu() in 88030 us
[    3.978369] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    4.037106] synchronize_rcu() in 58483 us
[    4.107072] synchronize_rcu() in 69759 us
[    4.187034] synchronize_rcu() in 79788 us
[    4.207064] Refined TSC clocksource calibration: 2533.422 MHz.
[    4.207142] Switching to clocksource tsc
[    4.208521] 00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    4.266991] synchronize_rcu() in 58184 us
[    4.267783] Real Time Clock Driver v1.12b
[    4.267840] Linux agpgart interface v0.103
[    4.268686] [drm] Initialized drm 1.1.0 20060810
[    4.273558] brd: module loaded
[    4.273614] HP CISS Driver (v 3.6.26)
[    4.273939] Uniform Multi-Platform E-IDE driver
[    4.276920] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[    4.277042] Probing IDE interface ide0...
[    4.876897] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    4.877008] Probing IDE interface ide1...
[    5.476538] ide1 at 0x170-0x177,0x376 on irq 15
[    5.476643] ide-gd driver 1.18
[    5.476799] ide-cd driver 5.00
[    5.477011] HP HPSA Driver (v 2.0.2-1)
[    5.477090] hpsa 0000:0c:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.477182] hpsa 0000:0c:00.0: MSIX
[    5.477385] hpsa 0000:0c:00.0: irq 64 for MSI/MSI-X
[    5.477448] hpsa 0000:0c:00.0: irq 65 for MSI/MSI-X
[    5.477509] hpsa 0000:0c:00.0: irq 66 for MSI/MSI-X
[    5.477570] hpsa 0000:0c:00.0: irq 67 for MSI/MSI-X
[    5.496453] hpsa 0000:0c:00.0: hpsa0: <0x323a> at IRQ 64 using DAC
[    5.517245] scsi0 : hpsa
[    5.519018] hpsa 0000:0c:00.0: Direct-Access     device c0b0t0l0 added.
[    5.519083] hpsa 0000:0c:00.0: RAID              device c0b3t0l0 added.
[    5.519812] scsi 0:0:0:0: Direct-Access     HP       LOGICAL VOLUME   2.50 PQ: 0 ANSI: 5
[    5.521435] scsi 0:3:0:0: RAID              HP       P410i            2.50 PQ: 0 ANSI: 0
[    5.522810] sd 0:0:0:0: [sda] 488327040 512-byte logical blocks: (250 GB/232 GiB)
[    5.522833] Broadcom NetXtreme II 5771x 10Gigabit Ethernet Driver bnx2x 1.62.12-0 (2011/03/20)
[    5.522963] bnx2x 0000:02:00.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
[    5.522973] bnx2x 0000:02:00.0: setting latency timer to 64
[    5.523534] sd 0:0:0:0: [sda] Write Protect is off
[    5.523593] sd 0:0:0:0: [sda] Mode Sense: 6b 00 00 08
[    5.523805] sd 0:0:0:0: [sda] Write cache: disabled, read cache: disabled, doesn't support DPO or FUA
[    5.524936] bnx2x 0000:02:00.0: part number 412F4E-0-0-0
[    5.526094] bnx2x 0000:02:00.0: irq 68 for MSI/MSI-X
[    5.526156] bnx2x 0000:02:00.0: irq 69 for MSI/MSI-X
[    5.526218] bnx2x 0000:02:00.0: irq 70 for MSI/MSI-X
[    5.526279] bnx2x 0000:02:00.0: irq 71 for MSI/MSI-X
[    5.526341] bnx2x 0000:02:00.0: irq 72 for MSI/MSI-X
[    5.526457] bnx2x 0000:02:00.0: irq 73 for MSI/MSI-X
[    5.526519] bnx2x 0000:02:00.0: irq 74 for MSI/MSI-X
[    5.526581] bnx2x 0000:02:00.0: irq 75 for MSI/MSI-X
[    5.526642] bnx2x 0000:02:00.0: irq 76 for MSI/MSI-X
[    5.526704] bnx2x 0000:02:00.0: irq 77 for MSI/MSI-X
[    5.526765] bnx2x 0000:02:00.0: irq 78 for MSI/MSI-X
[    5.526826] bnx2x 0000:02:00.0: irq 79 for MSI/MSI-X
[    5.526888] bnx2x 0000:02:00.0: irq 80 for MSI/MSI-X
[    5.530896] bnx2x 0000:02:00.0: irq 81 for MSI/MSI-X
[    5.530957] bnx2x 0000:02:00.0: irq 82 for MSI/MSI-X
[    5.531019] bnx2x 0000:02:00.0: irq 83 for MSI/MSI-X
[    5.531080] bnx2x 0000:02:00.0: irq 84 for MSI/MSI-X
[    5.534762] bnx2x 0000:02:00.0: eth0: Broadcom NetXtreme II BCM57711E XGb (A0) PCI-E x4 5GHz (Gen2) found at mem fb000000, IRQ 28, node addr f4:ce:46:bb:32:d0
[    5.534933] bnx2x 0000:02:00.1: PCI INT D -> GSI 47 (level, low) -> IRQ 47
[    5.535000] bnx2x 0000:02:00.1: setting latency timer to 64
[    5.536999] bnx2x 0000:02:00.1: part number 412F4E-0-0-0
[    5.538090] bnx2x 0000:02:00.1: irq 85 for MSI/MSI-X
[    5.538152] bnx2x 0000:02:00.1: irq 86 for MSI/MSI-X
[    5.538214] bnx2x 0000:02:00.1: irq 87 for MSI/MSI-X
[    5.538275] bnx2x 0000:02:00.1: irq 88 for MSI/MSI-X
[    5.538337] bnx2x 0000:02:00.1: irq 89 for MSI/MSI-X
[    5.538398] bnx2x 0000:02:00.1: irq 90 for MSI/MSI-X
[    5.538459] bnx2x 0000:02:00.1: irq 91 for MSI/MSI-X
[    5.538521] bnx2x 0000:02:00.1: irq 92 for MSI/MSI-X
[    5.538582] bnx2x 0000:02:00.1: irq 93 for MSI/MSI-X
[    5.538643] bnx2x 0000:02:00.1: irq 94 for MSI/MSI-X
[    5.538704] bnx2x 0000:02:00.1: irq 95 for MSI/MSI-X
[    5.538766] bnx2x 0000:02:00.1: irq 96 for MSI/MSI-X
[    5.538827] bnx2x 0000:02:00.1: irq 97 for MSI/MSI-X
[    5.538889] bnx2x 0000:02:00.1: irq 98 for MSI/MSI-X
[    5.538950] bnx2x 0000:02:00.1: irq 99 for MSI/MSI-X
[    5.539011] bnx2x 0000:02:00.1: irq 100 for MSI/MSI-X
[    5.539073] bnx2x 0000:02:00.1: irq 101 for MSI/MSI-X
[    5.542564] bnx2x 0000:02:00.1: eth1: Broadcom NetXtreme II BCM57711E XGb (A0) PCI-E x4 5GHz (Gen2) found at mem fa000000, IRQ 47, node addr f4:ce:46:bb:32:d4
[    5.542938] usbcore: registered new interface driver asix
[    5.543093] usbcore: registered new interface driver cdc_ether
[    5.543255] usbcore: registered new interface driver net1080
[    5.543416] usbcore: registered new interface driver rndis_host
[    5.543576] usbcore: registered new interface driver cdc_subset
[    5.543738] usbcore: registered new interface driver zaurus
[    5.543802] cdc_ncm: 24-May-2011
[    5.543960] usbcore: registered new interface driver cdc_ncm
[    5.544023] netconsole: local port 4444
[    5.544079] netconsole: local IP 192.168.20.108
[    5.544136] netconsole: interface 'eth1'
[    5.544192] netconsole: remote port 4444
[    5.544247] netconsole: remote IP 192.168.20.112
[    5.544305] netconsole: remote ethernet address 00:1e:0b:ec:c3:e4
[    5.544366] netconsole: device eth1 not up yet, forcing it
[    5.560001]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
[    5.562328] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.836933] bnx2x 0000:02:00.1: eth1: using MSI-X  IRQs: sp 85  fp[0] 86 ... fp[15] 101
[   10.084211] bnx2x 0000:02:00.1: eth1: NIC Link is Up, 1000 Mbps full duplex
[   10.095488] console [netcon0] enabled
[   10.095546] netconsole: network logging started
[   10.095610] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   10.095739] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   10.095845] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   10.095909] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   10.096349] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[   10.096491] ehci_hcd 0000:00:1d.7: debug port 1
[   10.100430] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[   10.100519] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xf35f0000
[   10.124141] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   10.125110] hub 1-0:1.0: USB hub found
[   10.125198] hub 1-0:1.0: 8 ports detected
[   10.125998] uhci_hcd: USB Universal Host Controller Interface driver
[   10.126241] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   10.126311] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   10.126374] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   10.126448] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[   10.126553] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00001000
[   10.127020] hub 2-0:1.0: USB hub found
[   10.127087] hub 2-0:1.0: 2 ports detected
[   10.127432] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 23 (level, low) -> IRQ 23
[   10.127503] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   10.127566] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   10.127640] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[   10.127763] uhci_hcd 0000:00:1d.1: irq 23, io base 0x00001020
[   10.128205] hub 3-0:1.0: USB hub found
[   10.128269] hub 3-0:1.0: 2 ports detected
[   10.128601] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[   10.128671] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   10.128734] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   10.128808] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[   10.128927] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00001040
[   10.129371] hub 4-0:1.0: USB hub found
[   10.129435] hub 4-0:1.0: 2 ports detected
[   10.129760] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[   10.129831] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[   10.129894] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   10.129970] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[   10.130074] uhci_hcd 0000:00:1d.3: irq 23, io base 0x00001060
[   10.130531] hub 5-0:1.0: USB hub found
[   10.130595] hub 5-0:1.0: 2 ports detected
[   10.130934] uhci_hcd 0000:01:04.4: PCI INT B -> GSI 22 (level, low) -> IRQ 22
[   10.131006] uhci_hcd 0000:01:04.4: UHCI Host Controller
[   10.131080] uhci_hcd 0000:01:04.4: new USB bus registered, assigned bus number 6
[   10.131171] uhci_hcd 0000:01:04.4: port count misdetected? forcing to 2 ports
[   10.131865] uhci_hcd 0000:01:04.4: irq 22, io base 0x00003800
[   10.132357] hub 6-0:1.0: USB hub found
[   10.132420] hub 6-0:1.0: 2 ports detected
[   10.133195] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
[   10.134798] serio: i8042 KBD port at 0x60,0x64 irq 1
[   10.134909] serio: i8042 AUX port at 0x60,0x64 irq 12
[   10.135373] mousedev: PS/2 mouse device common for all mice
[   10.136083] cpuidle: using governor ladder
[   10.136145] cpuidle: using governor menu
[   10.136674] usbcore: registered new interface driver usbhid
[   10.136737] usbhid: USB HID core driver
[   10.136810] GACT probability on
[   10.136868] Mirror/redirect action on
[   10.136926] Simple TC action Loaded
[   10.137408] u32 classifier
[   10.137467]     Performance counters on
[   10.137525]     input device check on
[   10.137582]     Actions configured
[   10.137728] TCP cubic registered
[   10.137787] NET: Registered protocol family 17
[   10.137855] Registering the dns_resolver key type
[   10.138413] Kernel not built with RTC support, ALARM timers will not wake from suspend
[   10.140374] Freeing unused kernel memory: 508k freed
[   10.140586] Write protecting the kernel read-only data: 10240k
[   10.145104] Freeing unused kernel memory: 1532k freed
[   10.149317] Freeing unused kernel memory: 1352k freed
[   10.181061] dev=ffff88007cd85420 p=ffff88007cd85400 disk=ffff88007cd853b8 disk->queue=          (null)
[   10.182574] dev=ffff88007cd85820 p=ffff88007cd85800 disk=ffff88007cd857b8 disk->queue=          (null)
[   10.184045] dev=ffff88007cd85c20 p=ffff88007cd85c00 disk=ffff88007cd85bb8 disk->queue=          (null)
[   10.185502] dev=ffff88007cd86020 p=ffff88007cd86000 disk=ffff88007cd85fb8 disk->queue=          (null)
[   10.186942] dev=ffff88007cd86420 p=ffff88007cd86400 disk=ffff88007cd863b8 disk->queue=          (null)
[   10.192361] dev=ffff88007cd86820 p=ffff88007cd86800 disk=ffff88007cd867b8 disk->queue=          (null)
[   10.193798] dev=ffff88007cd86c20 p=ffff88007cd86c00 disk=ffff88007cd86bb8 disk->queue=          (null)
[   10.220239] dev=ffff88007cd85420 p=ffff88007cd85400 disk=ffff88007cd853b8 disk->queue=          (null)
[   10.221617] dev=ffff88007cd85820 p=ffff88007cd85800 disk=ffff88007cd857b8 disk->queue=          (null)
[   10.222995] dev=ffff88007cd85c20 p=ffff88007cd85c00 disk=ffff88007cd85bb8 disk->queue=          (null)
[   10.224431] dev=ffff88007cd86020 p=ffff88007cd86000 disk=ffff88007cd85fb8 disk->queue=          (null)
[   10.225815] dev=ffff88007cd86420 p=ffff88007cd86400 disk=ffff88007cd863b8 disk->queue=          (null)
[   10.227202] dev=ffff88007cd86820 p=ffff88007cd86800 disk=ffff88007cd867b8 disk->queue=          (null)
[   10.228579] dev=ffff88007cd86c20 p=ffff88007cd86c00 disk=ffff88007cd86bb8 disk->queue=          (null)
[   10.360251] EXT3-fs: barriers not enabled
[   10.371446] kjournald starting.  Commit interval 5 seconds
[   10.371580] EXT3-fs (sda2): mounted filesystem with writeback data mode
[   10.443990] usb 6-1: new full speed USB device number 2 using uhci_hcd
[   10.675657] input: HP Virtual Keyboard as /devices/pci0000:00/0000:00:1e.0/0000:01:04.4/usb6/6-1/6-1:1.0/input/input1
[   10.676072] generic-usb 0003:03F0:1027.0001: input: USB HID v1.01 Keyboard [HP Virtual Keyboard] on usb-0000:01:04.4-1/input0
[   10.686286] input: HP Virtual Keyboard as /devices/pci0000:00/0000:00:1e.0/0000:01:04.4/usb6/6-1/6-1:1.1/input/input2
[   10.686719] generic-usb 0003:03F0:1027.0002: input: USB HID v1.01 Mouse [HP Virtual Keyboard] on usb-0000:01:04.4-1/input1
[   11.184098] 10-udev.hotplug used greatest stack depth: 4288 bytes left
[   11.213204] awk used greatest stack depth: 3248 bytes left
[   11.330142] mount used greatest stack depth: 3200 bytes left
[   11.618319] hotplug used greatest stack depth: 2720 bytes left
[   14.157307] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   14.157523] scsi 0:3:0:0: Attached scsi generic sg1 type 12
[   25.206904] dev=ffff88007cd85c20 p=ffff88007cd85c00 disk=ffff88007cd85bb8 disk->queue=          (null)
[   25.215961] dev=ffff88007cd86420 p=ffff88007cd86400 disk=ffff88007cd863b8 disk->queue=          (null)
[   25.223713] dev=ffff88007cd86c20 p=ffff88007cd86c00 disk=ffff88007cd86bb8 disk->queue=          (null)
[   25.224391] dev=ffff88007cd85420 p=ffff88007cd85400 disk=ffff88007cd853b8 disk->queue=          (null)
[   25.225657] dev=ffff88007cd86020 p=ffff88007cd86000 disk=ffff88007cd85fb8 disk->queue=          (null)
[   25.232220] dev=ffff88007cd86820 p=ffff88007cd86800 disk=ffff88007cd867b8 disk->queue=          (null)
[   25.236902] dev=ffff88007cd85820 p=ffff88007cd85800 disk=ffff88007cd857b8 disk->queue=          (null)
[   30.157514] warning: process `kmodule' used the deprecated sysctl system call with 1.23.
[   30.459387] tg3.c:v3.119 (May 18, 2011)
[   30.459409] tg3 0000:0a:04.0: PCI INT A -> GSI 32 (level, low) -> IRQ 32
[   30.574209] synchronize_rcu() in 99915 us
[   30.600063] tg3 0000:0a:04.0: eth2: Tigon3 [partno(N/A) rev 9003] (PCIX:133MHz:64-bit) MAC address f4:ce:46:87:96:ce
[   30.600069] tg3 0000:0a:04.0: eth2: attached PHY is 5714 (1000Base-SX Ethernet) (WireSpeed[0], EEE[0])
[   30.600073] tg3 0000:0a:04.0: eth2: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[   30.600077] tg3 0000:0a:04.0: eth2: dma_rwctrl[76148000] dma_mask[40-bit]
[   30.600152] tg3 0000:0a:04.1: PCI INT B -> GSI 42 (level, low) -> IRQ 42
[   30.714142] synchronize_rcu() in 99971 us
[   30.739945] tg3 0000:0a:04.1: eth3: Tigon3 [partno(N/A) rev 9003] (PCIX:133MHz:64-bit) MAC address f4:ce:46:87:96:cf
[   30.739951] tg3 0000:0a:04.1: eth3: attached PHY is 5714 (1000Base-SX Ethernet) (WireSpeed[0], EEE[0])
[   30.739956] tg3 0000:0a:04.1: eth3: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[   30.739961] tg3 0000:0a:04.1: eth3: dma_rwctrl[76148000] dma_mask[40-bit]
[   30.762940] md: Autodetecting RAID arrays.
[   30.762943] md: Scanned 0 and added 0 devices.
[   30.762944] md: autorun ...
[   30.762946] md: ... autorun DONE.
[   33.713679] bnx2x 0000:02:00.1: eth1: using MSI-X  IRQs: sp 85  fp[0] 86 ... fp[15] 101
[   37.368209] EXT3-fs (sda2): using internal journal
[   39.101941] EXT3-fs: barriers not enabled
[   39.105114] kjournald starting.  Commit interval 5 seconds
[   39.116182] EXT3-fs (sda6): using internal journal
[   39.116190] EXT3-fs (sda6): mounted filesystem with writeback data mode
[   39.126847] EXT3-fs: barriers not enabled
[   39.130703] kjournald starting.  Commit interval 5 seconds
[   39.145586] EXT3-fs (sda1): using internal journal
[   39.145592] EXT3-fs (sda1): mounted filesystem with writeback data mode
[   39.163040] EXT3-fs: barriers not enabled
[   39.166240] kjournald starting.  Commit interval 5 seconds
[   39.178196] EXT3-fs (sda7): using internal journal
[   39.178201] EXT3-fs (sda7): mounted filesystem with writeback data mode
[   39.190527] EXT3-fs: barriers not enabled
[   39.198186] kjournald starting.  Commit interval 5 seconds
[   39.207669] EXT3-fs (sda3): using internal journal
[   39.207675] EXT3-fs (sda3): mounted filesystem with writeback data mode
[   39.309979] bnx2x 0000:02:00.1: eth1: NIC Link is Up, 1000 Mbps full duplex
[   39.720767] Adding 4192928k swap on /dev/sda5.  Priority:-1 extents:1 across:4192928k 
[   41.726651] ip_tables: (C) 2000-2006 Netfilter Core Team


